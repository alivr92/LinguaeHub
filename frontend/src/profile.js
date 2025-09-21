//--------------------------- Step Validations ---------------------------
export function validate_profile() {
    const profileForm = document.getElementById('profileForm');
    let isValid = true;

    // Clear previous errors
    profileForm.querySelectorAll('.is-invalid').forEach(el => el.classList.remove('is-invalid'));
    profileForm.querySelectorAll('.invalid-feedback').forEach(el => el.remove());

    // Validate required fields
    profileForm.querySelectorAll('[required]').forEach(field => {
        if (!field.value.trim()) {
            field.classList.add('is-invalid');
            isValid = false;

            const errorElement = document.createElement('div');
            errorElement.className = 'invalid-feedback';
            errorElement.textContent = field.dataset.error || 'This field is required';
            field.parentNode.appendChild(errorElement);
        }
    });

    // Focus first invalid field if any
    if (!isValid) {
        const firstInvalid = profileForm.querySelector('.is-invalid');
        firstInvalid?.scrollIntoView({behavior: 'smooth', block: 'center'});
        firstInvalid?.focus();
    }

    return isValid;
}