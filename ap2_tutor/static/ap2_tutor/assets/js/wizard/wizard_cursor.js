document.addEventListener('DOMContentLoaded', function () {
    // --------------------------------------------
    // | Step 1: Primitive application (Done)     |
    // | Step 2: Basic Profile                    |
    // | Step 3: Teaching Skill (add skill)       |
    // | Step 4: Education (Add edu)              |
    // | Step 5: Review and submit                |
    // | Step 6: Result (Decision)                |
    // | Step 7: Accepted (Approved)              |
    // | Step 8: Rejected (Declined)              |
    // --------------------------------------------

    // Initialize the stepper
    const stepperElement = document.querySelector('.bs-stepper');
    const stepper = new Stepper(stepperElement, {
        linear: true
    });

    // Track completed steps (Step 1 is pre-completed)
    const completedSteps = new Set([1]);
    let currentStep = 2; // Start at step 2

    // Initialize stepper on page load
    initializeStepper();

    // Disable header navigation
    disableHeaderNavigation();

    // Add event listeners for navigation buttons
    document.querySelectorAll('[data-action]').forEach(button => {
        button.addEventListener('click', async (e) => {
            e.preventDefault();
            const action = button.getAttribute('data-action');
            console.log('Button clicked:', action);

            // Set the action value in the hidden input
            const currentForm = document.querySelector(`#step-${currentStep} form`);
            console.log('Current form found:', currentForm ? 'Yes' : 'No');
            if (currentForm) {
                const actionInput = currentForm.querySelector('input[name="action"]');
                console.log('Action input found:', actionInput ? 'Yes' : 'No');
                if (actionInput) {
                    actionInput.value = action;
                    console.log('Set action value to:', action);
                }
            }

            switch (action) {
                case 'next':
                    console.log('Processing next action');
                    if (await validateCurrentStep()) {
                        console.log('Validation passed');
                        if (await submitCurrentForm('next')) {
                            //     const nextStep = currentStep + 1;
                            //     if (nextStep <= 6) {
                            //         completedSteps.add(currentStep);
                            //         currentStep = nextStep;
                            //         updateStepUI(currentStep);
                            //         updateStepVisuals();
                            //         stepper.next();
                            //     }
                            await handleStepTransition(currentStep + 1);

                        }
                    } else {
                        console.log('Validation failed');
                    }
                    break;
                case 'prev':
                    console.log('Processing prev action');
                    if (currentStep > 2) {
                        currentStep--;
                        updateStepUI(currentStep);
                        stepper.previous();
                    }
                    break;
                case 'save':
                    console.log('Processing save action');
                    if (await validateCurrentStep()) {
                        await submitCurrentForm('save');
                    }
                    break;
            }
        });
    });

    function initializeStepper() {
        const stepValue = parseInt(document.getElementById('currentStep')?.value || '2', 10);

        // Handle special cases for decision steps
        if (stepValue === 7 || stepValue === 8) {
            currentStep = 6; // Keep in decision step
            completedSteps.add(6);
        } else {
            currentStep = stepValue;
            // Mark previous steps as completed
            for (let i = 1; i < stepValue; i++) {
                completedSteps.add(i);
            }
        }

        updateStepUI(currentStep);
        updateStepVisuals();
    }

    function disableHeaderNavigation() {
        document.querySelectorAll('.step-trigger').forEach(trigger => {
            trigger.style.pointerEvents = 'none';
            trigger.style.cursor = 'default';
            trigger.setAttribute('tabindex', '-1');
            trigger.setAttribute('aria-disabled', 'true');
        });
    }

    async function handleNextButton() {
        if (await validateCurrentStep()) {
            if (await submitCurrentForm('next')) {
                const nextStep = currentStep + 1;
                if (nextStep <= 6) { // Don't go beyond decision step
                    completedSteps.add(currentStep);
                    currentStep = nextStep;
                    updateStepUI(currentStep);
                    updateStepVisuals();
                }
            }
        }
    }

    async function handleSaveButton() {
        if (await validateCurrentStep()) {
            await submitCurrentForm('save');
            // Stay on current step, just show success message
            showBootstrapAlert('Changes saved successfully!', 'success', 3000);
        }
    }

    function handlePrevButton() {
        if (currentStep > 2) { // Don't go back before step 2
            currentStep--;
            updateStepUI(currentStep);
            updateStepVisuals();
        }
    }

    async function validateCurrentStep() {
        switch (currentStep) {
            case 2:
                return validateProfileForm();
            case 3:
                return validateSkillsForm();
            case 4:
                return validateEducationForm();
            case 5:
                return validateReviewForm();
            default:
                return true;
        }
    }

    async function submitCurrentForm(action) {
        let form;
        switch (currentStep) {
            case 2:
                form = document.querySelector('#profileForm');
                console.log('Found profile form:', form);
                console.log('Form action attribute:', form ? form.getAttribute('action') : 'Form not found');
                break;
            case 3:
                form = document.querySelector('#skillsForm');
                break;
            case 4:
                form = document.querySelector('#educationForm');
                break;
            case 5:
                form = document.querySelector('#reviewForm');
                break;
            default:
                return true;
        }

        if (!form) {
            console.error('Form not found for step:', currentStep);
            return true;
        }

        try {
            const formData = new FormData(form);
            formData.append('action', action);
            formData.append('step', currentStep);

            // Debug: Log form data
            console.log('Form data entries:');
            for (let pair of formData.entries()) {
                console.log(pair[0] + ': ' + pair[1]);
            }

            // Get the CSRF token
            const csrfToken = document.querySelector('[name=csrfmiddlewaretoken]').value;
            console.log('CSRF Token:', csrfToken ? 'Found' : 'Not found');

            // Get the correct form action URL
            const formAction = form.getAttribute('action');
            console.log('Submitting to URL:', formAction);

            const response = await fetch(formAction, {
                method: 'POST',
                body: formData,
                headers: {
                    'X-Requested-With': 'XMLHttpRequest',
                    'X-CSRFToken': csrfToken
                }
            });

            console.log('Response status:', response.status);
            const data = await response.json();
            console.log('Response data:', data);

            if (data.success) {
                showBootstrapAlert(data.message || 'Success!', 'success', 3000);
                return true;
            } else {
                console.error('Form submission failed:', data.errors);
                handleFormErrors(data.errors);
                return false;
            }
        } catch (error) {
            console.error('Form submission error:', error);
            showBootstrapAlert('An error occurred. Please try again.', 'danger', 5000);
            return false;
        }
    }

    function validateProfileForm() {
        const form = document.querySelector('#profileForm');
        if (!form) return true;

        clearValidationErrors(form);
        let isValid = true;

        // Required fields validation
        form.querySelectorAll('[required]').forEach(field => {
            if (!field.value.trim()) {
                showFieldError(field, 'This field is required');
                isValid = false;
            }
        });

        // Email validation
        const emailField = form.querySelector('[type="email"]');
        if (emailField && emailField.value && !isValidEmail(emailField.value)) {
            showFieldError(emailField, 'Please enter a valid email address');
            isValid = false;
        }

        if (!isValid) {
            scrollToFirstError(form);
        }

        return isValid;
    }

    function validateSkillsForm() {
        const form = document.querySelector('#skillsForm');
        if (!form) return true;

        clearValidationErrors(form);
        let isValid = true;

        // At least one skill required
        const skillInputs = form.querySelectorAll('[name="skills[]"]');
        if (skillInputs.length === 0) {
            showBootstrapAlert('Please add at least one skill', 'danger', 5000);
            isValid = false;
        }

        return isValid;
    }

    function validateEducationForm() {
        const form = document.querySelector('#educationForm');
        if (!form) return true;

        clearValidationErrors(form);
        let isValid = true;

        // Required fields validation
        form.querySelectorAll('[required]').forEach(field => {
            if (!field.value.trim()) {
                showFieldError(field, 'This field is required');
                isValid = false;
            }
        });

        if (!isValid) {
            scrollToFirstError(form);
        }

        return isValid;
    }

    function validateReviewForm() {
        // Add any final review validation if needed
        return true;
    }

    function updateStepUI(stepNumber) {
        // Hide all content
        document.querySelectorAll('.bs-stepper-content .content').forEach(content => {
            // content.classList.remove('active', 'show', 'd-block');
            content.classList.remove('active', 'show');

            content.style.display = 'none';
        });

        // Show target step
        const targetStep = document.querySelector(`#step-${stepNumber}`);
        if (targetStep) {
            targetStep.classList.add('active', 'show');
            targetStep.style.display = 'block';
            // If it's step 3, trigger the skill loading
            if (stepNumber === 3) {
                showExistedSkills();
            }
        }

        // Update stepper header
        document.querySelectorAll('.step').forEach((step, index) => {
            const stepNum = index + 1;
            step.classList.toggle('active', stepNum === stepNumber);
            // if (completedSteps.has(stepNum)) {
            //     step.classList.add('completed');
            //     const circle = step.querySelector('.bs-stepper-circle');
            //     if (circle) {
            //         circle.innerHTML = '<i class="bi bi-check"></i>';
            //     }
            // }
        });

        // Update step visuals after transition
        updateStepVisuals();
    }

    function updateStepVisuals() {
        document.querySelectorAll('.step').forEach((step, index) => {
            const stepNum = index + 1;
            if (completedSteps.has(stepNum)) {
                step.classList.add('completed');
                const circle = step.querySelector('.bs-stepper-circle');
                if (circle) {
                    circle.innerHTML = '<i class="bi bi-check"></i>';
                }
            }
        });
    }

    // Utility functions
    function clearValidationErrors(form) {
        form.querySelectorAll('.is-invalid').forEach(el => {
            el.classList.remove('is-invalid');
        });
        form.querySelectorAll('.invalid-feedback').forEach(el => {
            el.remove();
        });
    }

    function showFieldError(field, message) {
        field.classList.add('is-invalid');
        const errorDiv = document.createElement('div');
        errorDiv.className = 'invalid-feedback';
        errorDiv.textContent = message;
        field.parentNode.insertBefore(errorDiv, field.nextSibling);
    }

    function scrollToFirstError(form) {
        const firstInvalid = form.querySelector('.is-invalid');
        if (firstInvalid) {
            firstInvalid.scrollIntoView({behavior: 'smooth', block: 'center'});
            firstInvalid.focus();
        }
    }

    function isValidEmail(email) {
        return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
    }

    function showBootstrapAlert(message, type = 'success', duration = 3000) {
        const alertDiv = document.createElement('div');
        alertDiv.className = `alert alert-${type} alert-dismissible fade show position-fixed top-0 start-50 translate-middle-x mt-3`;
        alertDiv.style.zIndex = '1050';
        alertDiv.innerHTML = `
            ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        `;

        document.body.appendChild(alertDiv);

        if (duration) {
            setTimeout(() => {
                alertDiv.remove();
            }, duration);
        }
    }

    function handleFormErrors(errors) {
        if (!errors) return;

        // Clear any existing error messages
        document.querySelectorAll('.is-invalid').forEach(el => {
            el.classList.remove('is-invalid');
        });
        document.querySelectorAll('.invalid-feedback').forEach(el => {
            el.remove();
        });

        // Handle field-specific errors
        Object.entries(errors).forEach(([field, message]) => {
            const input = document.querySelector(`[name="${field}"]`);
            if (input) {
                input.classList.add('is-invalid');
                const errorDiv = document.createElement('div');
                errorDiv.className = 'invalid-feedback';
                errorDiv.textContent = Array.isArray(message) ? message[0] : message;
                input.parentNode.insertBefore(errorDiv, input.nextSibling);
            }
        });

        // If there are any errors, scroll to the first error
        const firstError = document.querySelector('.is-invalid');
        if (firstError) {
            firstError.scrollIntoView({behavior: 'smooth', block: 'center'});
            firstError.focus();
        }

        // Show a general error message
        showBootstrapAlert('Please correct the errors and try again.', 'danger', 5000);
    }
});