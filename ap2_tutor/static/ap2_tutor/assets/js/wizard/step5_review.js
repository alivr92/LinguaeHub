document.addEventListener('DOMContentLoaded', function () {
    const form = document.getElementById('agreement-form');

    form.addEventListener('submit', function (event) {
        if (!form.checkValidity()) {
            event.preventDefault();
            event.stopPropagation();

            // Find first invalid field
            const invalidField = form.querySelector(':invalid');
            if (invalidField) {
                const container = invalidField.closest('.form-check');
                // console.log('container: ', container);
                // Scroll to container
                container.scrollIntoView({
                    behavior: 'smooth',
                    block: 'center'
                });

                // Add highlight classes to entire row
                container.classList.add('highlight-error', 'was-validated');

                // Remove highlight after animation completes
                setTimeout(() => {
                    container.classList.remove('highlight-error');
                }, 4000);

                invalidField.focus();
            }
        }
    }, false);
});