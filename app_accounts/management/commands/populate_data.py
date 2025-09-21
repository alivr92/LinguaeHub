import random
import os
import requests
from django.core.management.base import BaseCommand
from django.contrib.auth.models import User, Group
from faker import Faker
from app_accounts.models import UserProfile, Language, COUNTRY_CHOICES, GENDER_CHOICES, LANGUAGE_CHOICES
from ap2_student.models import Student, Subject
from ap2_tutor.models import Tutor, Skill, SkillLevel, SKILL_CHOICES, RATING, LEVEL_CHOICES
from django.core.files import File
from django.conf import settings
from PIL import Image  # Add this import at the top of your file


class Command(BaseCommand):
    help = "Populate the database with dummy users and user profiles"

    def handle(self, *args, **kwargs):
        faker = Faker()

        # Number of users to create
        NUM_USERS = 20

        # Pre-fetch some languages, skills, skill levels, and subjects for ManyToManyField
        languages = list(Language.objects.all())
        skills = list(Skill.objects.all())
        skill_levels = list(SkillLevel.objects.all())
        subjects = list(Subject.objects.all())

        # Path to save profile photos
        media_path = os.path.join(settings.MEDIA_ROOT, "photos/fake_profiles/")
        if not os.path.exists(media_path):
            os.makedirs(media_path)

        for i in range(NUM_USERS):
            # Step 1: Create a User
            fname = faker.first_name()
            lname = faker.last_name()
            username = faker.user_name()
            email = faker.email()
            user = User.objects.create_user(
                first_name=fname,
                last_name=lname,
                username=username,
                email=email,
                password="1234"
            )

            # Step 2: Add user to a random group based on user_type
            # user_type = random.choice(['student', 'tutor', 'staff'])
            user_type = random.choice(['tutor'])
            user_group, _ = Group.objects.get_or_create(name=user_type)
            user.groups.add(user_group)

            # Step 3: Create a UserProfile
            gender = random.choice(GENDER_CHOICES)[0]
            phone = faker.phone_number()[:20]
            country = random.choice(COUNTRY_CHOICES)[0]
            lang_native = random.choice(LANGUAGE_CHOICES)[0]
            bio = faker.text(max_nb_chars=350)
            is_vip = random.choice([True, False])
            rating = round(random.uniform(1.0, 5.0), 1)
            reviews_count = random.randint(0, 200)
            create_date = faker.date()

            # Fetch a random profile photo
            # photo_url = f"https://loremflickr.com/200/200/portrait"  # API providing random portrait photos
            photo_url = "https://thispersondoesnotexist.com/"  # Updated: API for realistic fake profile photos
            response = requests.get(photo_url, stream=True)
            image_filename = f"profile_{i+1}.jpg"
            image_path = os.path.join(media_path, image_filename)

            # Save and resize the image
            with open(image_path, "wb") as img_file:
                img_file.write(response.content)

            # Resize the image using Pillow
            with Image.open(image_path) as img:
                img = img.resize((200, 200))  # Resize to 200x200 pixels
                img.save(image_path)  # Overwrite the original image with the resized version

            # Add the photo to the user profile
            with open(image_path, "rb") as img_file:
                user_profile = UserProfile.objects.create(
                    user=user,
                    gender=gender,
                    phone=phone,
                    country=country,
                    user_type=user_type,
                    bio=bio,
                    is_vip=is_vip,
                    rating=rating,
                    reviews_count=reviews_count,
                    availability=random.choice([True, False]),
                    title=faker.job(),
                    lang_native=lang_native,
                    create_date=create_date,
                    # photo=File(img_file),  # Dynamically fetched image
                )
                user_profile.photo.save(image_filename, File(img_file))  # Save the resized image

            # Step 4: Add random languages to the `lang_speak` field (ManyToManyField)
            if languages:
                selected_languages = random.sample(languages, k=min(3, len(languages)))  # Pick up to 3 languages
                user_profile.lang_speak.set(selected_languages)

            # --------------------------------------------------------------------
            # Step 5: Create Tutor or Student based on user_type
            if user_type == 'tutor':
                # Create a Tutor instance
                tutor = Tutor.objects.create(
                    profile=user_profile,
                    video_url=faker.url(),  # Generate a fake video URL
                    cost_trial=round(random.uniform(0.0, 50.0), 2),  # Random trial cost
                    cost_hourly=round(random.uniform(10.0, 100.0), 2),  # Random hourly cost
                    session_count=random.randint(0, 100),
                    student_count=random.randint(0, 50),
                    course_count=random.randint(0, 20),
                    rating=round(random.uniform(1.0, 5.0), 2),
                )
                # Add random skills and skill levels
                tutor.skills.set(random.sample(skills, k=min(3, len(skills))))  # Add up to 3 skills
                tutor.skill_level.set(
                    random.sample(skill_levels, k=min(2, len(skill_levels))))  # Add up to 2 skill levels

            elif user_type == 'student':
                # Create a Student instance
                student = Student.objects.create(
                    profile=user_profile,
                    major=faker.job(),  # Generate a fake major
                    session_count=random.randint(0, 50),
                    tutor_count=random.randint(0, 10),
                )
                # Add random interests (subjects)
                student.interests.set(random.sample(subjects, k=min(3, len(subjects))))  # Add up to 3 interests

                # Save the user profile (already saved by `create()`, but just in case)
                user_profile.save()

        self.stdout.write(self.style.SUCCESS(f"Successfully populated {NUM_USERS} users, profiles, tutors, and students!"))
