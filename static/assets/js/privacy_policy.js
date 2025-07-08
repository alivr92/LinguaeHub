document.addEventListener('DOMContentLoaded', function() {
    // Smooth scrolling for TOC links
    document.querySelectorAll('#privacyTOC a').forEach(anchor => {
        anchor.addEventListener('click', function(e) {
            e.preventDefault();

            // Remove active class from all links
            document.querySelectorAll('#privacyTOC a').forEach(link => {
                link.classList.remove('active');
            });

            // Add active class to clicked link
            this.classList.add('active');

            // Scroll to section
            const targetId = this.getAttribute('href');
            document.querySelector(targetId).scrollIntoView({
                behavior: 'smooth',
                block: 'start'
            });
        });
    });

    // Highlight current section in TOC while scrolling
    const sections = document.querySelectorAll('section[id]');
    const navLinks = document.querySelectorAll('#privacyTOC a');

    window.addEventListener('scroll', function() {
        let current = '';

        sections.forEach(section => {
            const sectionTop = section.offsetTop;
            const sectionHeight = section.clientHeight;

            if (pageYOffset >= (sectionTop - 100)) {
                current = section.getAttribute('id');
            }
        });

        navLinks.forEach(link => {
            link.classList.remove('active');
            if (link.getAttribute('href') === `#${current}`) {
                link.classList.add('active');
            }
        });
    });

    // Cookie toggles
    const cookieToggles = document.querySelectorAll('.form-check-input');
    cookieToggles.forEach(toggle => {
        if (!toggle.id.includes('essential')) {
            toggle.addEventListener('change', function() {
                // In a real implementation, this would set the cookie preference
                console.log(`${this.id} set to ${this.checked}`);
            });
        }
    });

    // Acceptance tracking
    const acceptBtn = document.getElementById('acceptPrivacyBtn');
    acceptBtn.addEventListener('click', function() {
        // In a real implementation, this would set a consent cookie
        console.log('Privacy policy acknowledged');
    });
});