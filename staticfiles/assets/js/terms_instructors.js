document.addEventListener('DOMContentLoaded', function() {
    // Enable accept button when checkbox is checked
    const termsCheckbox = document.getElementById('termsAcceptance');
    const acceptBtn = document.getElementById('acceptTermsBtn');

    termsCheckbox.addEventListener('change', function() {
        acceptBtn.disabled = !this.checked;
    });

    // Dark mode toggle
    const darkModeToggle = document.getElementById('darkModeToggle');
    const modalContent = document.querySelector('.modal-content');

    darkModeToggle.addEventListener('change', function() {
        modalContent.classList.toggle('dark-mode');
    });

    // Smooth scrolling for TOC links
    document.querySelectorAll('#termsTOC a').forEach(anchor => {
        anchor.addEventListener('click', function(e) {
            e.preventDefault();

            // Remove active class from all links
            document.querySelectorAll('#termsTOC a').forEach(link => {
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
    const navLinks = document.querySelectorAll('#termsTOC a');

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
});
