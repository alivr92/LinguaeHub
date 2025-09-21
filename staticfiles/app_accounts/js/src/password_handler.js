//=================================================================================
document.addEventListener('DOMContentLoaded', function () {
    const passwordInput = document.getElementById('password1');
    const confirmInput = document.getElementById('password2');
    const strengthBar = document.getElementById('passwordStrength');
    const feedback = document.getElementById('passwordFeedback');
    const form = document.getElementById('registrationForm');
    const mismatchError = document.getElementById('mismatch-error');
    const shownErrors = new Set();

    // Enable Bootstrap validation
    form.addEventListener('submit', function (event) {
        if (!form.checkValidity()) {
            event.preventDefault();
            event.stopPropagation();
        }
        form.classList.add('was-validated');
    }, false);

    // Real-time validation for all fields
    document.querySelectorAll('#registrationForm input').forEach(input => {
        input.addEventListener('input', function() {
            validateField(this);

            // Special case for password confirmation
            if (this.id === 'password1' || this.id === 'password2') {
                validatePasswordMatch();
            }
        });

        input.addEventListener('blur', function() {
            validateField(this);
        });
    });

    function validateField(field) {
        const inputGroup = field.closest('.input-group');
        if (!inputGroup) return;

        inputGroup.classList.remove('is-valid-group', 'is-invalid-group');

        if (field.checkValidity()) {
            inputGroup.classList.add('is-valid-group');
        } else if (field.value.length > 0 || field.wasTouched) {
            inputGroup.classList.add('is-invalid-group');
        }

        field.wasTouched = true;
    }

    // Password toggle functionality
    document.querySelectorAll('.password-toggle').forEach(toggle => {
        toggle.addEventListener('click', function () {
            const inputId = this.getAttribute('data-toggle');
            const input = document.getElementById(inputId);
            const icon = this.querySelector('i');

            if (input.type === 'password') {
                input.type = 'text';
                icon.classList.remove('bi-eye-fill');
                icon.classList.add('bi-eye-slash-fill');
                this.setAttribute('title', 'Conceal password');
            } else {
                input.type = 'password';
                icon.classList.remove('bi-eye-slash-fill');
                icon.classList.add('bi-eye-fill');
                this.setAttribute('title', 'Reveal password');
            }
        });
    });

    // Password strength and requirement validation
    passwordInput.addEventListener('input', function () {
        const password = this.value;
        const inputGroup = this.closest('.password-input-group');
        inputGroup.classList.remove('is-valid-group', 'is-invalid-group');

        const hasUpper = /[A-Z]/.test(password);
        const hasLower = /[a-z]/.test(password);
        const hasNumber = /[0-9]/.test(password);
        const hasSpecial = /[^A-Za-z0-9]/.test(password);
        const hasValidLength = password.length >= 8;

        updateRequirement('req-length', hasValidLength, password.length > 0);
        updateRequirement('req-uppercase', hasUpper, password.length > 0);
        updateRequirement('req-lowercase', hasLower, password.length > 0);
        updateRequirement('req-number', hasNumber, password.length > 0);
        updateRequirement('req-special', hasSpecial, password.length > 0);

        if (hasValidLength && hasUpper && hasLower && hasNumber && hasSpecial) {
            inputGroup.classList.add('is-valid-group');
        } else if (password.length > 0) {
            inputGroup.classList.add('is-invalid-group');
        }

        if (password.length > 0) {
            const result = zxcvbn(password);
            const strengthPercent = (result.score + 1) * 20;

            strengthBar.style.width = `${strengthPercent}%`;
            strengthBar.className = `progress-bar ${
                ['bg-danger', 'bg-danger', 'bg-warning', 'bg-info', 'bg-success'][result.score]
                }`;

            const strengthText = ['Very Weak', 'Weak', 'Moderate', 'Strong', 'Very Strong'];
            feedback.textContent = strengthText[result.score];

            if (result.feedback.warning) {
                feedback.textContent += ` - ${result.feedback.warning}`;
            }
            if (result.feedback.suggestions.length > 0) {
                feedback.textContent += ` (${result.feedback.suggestions.join(', ')})`;
            }
        } else {
            strengthBar.style.width = '0%';
            feedback.textContent = '';
        }

        if (confirmInput.value) {
            validatePasswordMatch();
        }
    });

    // Confirm password validation
    confirmInput.addEventListener('input', validatePasswordMatch);

    function validatePasswordMatch() {
        const confirmGroup = confirmInput.closest('.password-input-group');
        if (confirmInput.value !== passwordInput.value) {
            confirmInput.setCustomValidity("Passwords do not match");
            mismatchError.style.display = 'block';
            confirmGroup.classList.remove('is-valid-group');
            confirmGroup.classList.add('is-invalid-group');
            shownErrors.add('mismatch');
        } else {
            confirmInput.setCustomValidity("");
            mismatchError.style.display = 'none';
            confirmGroup.classList.remove('is-invalid-group');
            if (passwordInput.value.length >= 8) {
                confirmGroup.classList.add('is-valid-group');
            }
            shownErrors.delete('mismatch');
        }
    }

    function updateRequirement(id, isValid, hasInput) {
        const element = document.getElementById(id);
        const icon = element.querySelector('i');

        if (!hasInput) {
            element.classList.remove('valid', 'invalid');
            icon.className = 'bi bi-circle';
            return;
        }

        element.classList.toggle('valid', isValid);
        element.classList.toggle('invalid', !isValid);

        if (isValid) {
            icon.className = 'bi bi-check-circle-fill';
            element.querySelector('span').style.fontWeight = 'normal';
        } else {
            icon.className = 'bi bi-x-circle-fill';
            element.querySelector('span').style.fontWeight = '500';
        }
    }
});