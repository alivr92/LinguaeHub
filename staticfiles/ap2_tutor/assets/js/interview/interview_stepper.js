document.addEventListener('DOMContentLoaded', function () {
    // --------------------------------------------
    // | Step 1: Done (Primitive application)     |
    // | Step 2: Basic Profile                    |
    // | Step -: Teaching Skill ( -- Not set --)  |
    // | Step -: Education      ( -- Not set --)  |
    // | Step 3: Schedule                         |
    // | Step 4: Review and submit                |
    // | Step 5: Result (Decision)                |
    // | Step 6: Accepted (Approved)              |
    // | Step 7: Rejected (Declined)              |
    // --------------------------------------------


    // Initialize the stepper
    const stepperElement = document.querySelector('.bs-stepper');
    const stepper = new Stepper(stepperElement, {
        linear: true
    });

    window.updateStepVisuals = updateStepVisuals;
    // Track completed steps (Step 1 is pre-completed)
    const completedSteps = new Set([1]);
    window.completedSteps = completedSteps;
    let currentStep = 2; // We want to start at step 2

    // Immediately show step 2 on page load
    function initializeToStep2() {
        // Hide all content divs
        document.querySelectorAll('.bs-stepper-content .content').forEach(content => {
            content.classList.remove('active', 'show', 'd-block');
            content.style.display = 'none';
        });

        // Show only step 2
        const step2 = document.querySelector('#step-2');
        step2.classList.add('active', 'show', 'd-block');
        step2.style.display = 'block';

        // Update stepper header state
        document.querySelectorAll('.step').forEach((step, index) => {
            if (index === 1) { // Step 2 is index 1 (0-based)
                step.classList.add('active');
            } else {
                step.classList.remove('active');
            }
        });

        // Update visual indicators
        updateStepVisuals();
    }

    function initializeStepper() {
        // Read the step from the hidden input
        let stepValue = parseInt(document.getElementById('currentStep')?.value || '1', 10) - 1;

        // Cap the step if it's beyond your max step (e.g., 6 steps from 0 to 5)
        // const maxStep = 5;
        // if (stepValue >= maxStep) {
        //     stepValue = maxStep;
        // }

        if (stepValue === 6 || stepValue === 7) {
            stepValue = 5; // keep in step 6 : "Result"
            completedSteps.add(6);
            updateStepVisuals();
        }

        // Hide all content divs
        document.querySelectorAll('.bs-stepper-content .content').forEach(content => {
            content.classList.remove('active', 'show', 'd-block');
            content.style.display = 'none';
        });

        // Mark previous steps as completed by for loop
        for (let i = 1; i <= stepValue; i++) {
            completedSteps.add(i);
        }

        // Set current step (for correct functionality of btn-next and btn-prev)
        console.log('stepValue : ', stepValue);
        console.log('stepValue +1 : ', stepValue + 1);
        goToStep(stepValue + 1);

        // Show only the correct step
        const stepId = `#step-${stepValue + 1}`;  // +1 because your step IDs are 1-based
        const targetStep = document.querySelector(stepId);
        if (targetStep) {
            targetStep.classList.add('active', 'show', 'd-block');
            targetStep.style.display = 'block';
        }

        // Update stepper header state
        document.querySelectorAll('.step').forEach((step, index) => {
            if (index === stepValue) {
                step.classList.add('active');
            } else {
                step.classList.remove('active');
            }
        });

        // Update visual indicators
        updateStepVisuals();
    }


    // Disable all header navigation buttons
    function disableHeaderNavigation() {
        document.querySelectorAll('.step-trigger').forEach(trigger => {
            trigger.style.pointerEvents = 'none';
            trigger.style.cursor = 'default';
            trigger.setAttribute('tabindex', '-1');
            trigger.setAttribute('aria-disabled', 'true');
        });
    }

    // Form validation for step 2
    function validateStep2() {
        const profileForm = document.getElementById('profileForm');
        if (!profileForm) return true;

        // Reset validation states
        profileForm.querySelectorAll('.is-invalid').forEach(el => {
            el.classList.remove('is-invalid');
        });
        profileForm.querySelectorAll('.invalid-feedback').forEach(el => {
            el.remove();
        });

        let isValid = true;
        const requiredFields = profileForm.querySelectorAll('[required]');

        requiredFields.forEach(field => {
            if (!field.value.trim()) {
                field.classList.add('is-invalid');
                isValid = false;

                const errorElement = document.createElement('div');
                errorElement.className = 'invalid-feedback';
                errorElement.textContent = field.dataset.error || 'This field is required';
                field.parentNode.insertBefore(errorElement, field.nextSibling);
            }
        });

        if (!isValid) {
            const firstInvalid = profileForm.querySelector('.is-invalid');
            if (firstInvalid) {
                firstInvalid.scrollIntoView({
                    behavior: 'smooth',
                    block: 'center'
                });
                firstInvalid.focus();
            }
        }

        return isValid;
    }

    // Handle step navigation
    function goToStep_MAIN(stepNumber) {
        // Validate before proceeding forward
        if (stepNumber > currentStep) {
            if (currentStep === 2 && !validateStep2()) {
                return false;
            }

            // Mark current step as completed
            completedSteps.add(currentStep);
            updateStepVisuals();
        }

        // Update current step
        currentStep = stepNumber;

        // Hide all content
        document.querySelectorAll('.bs-stepper-content .content').forEach(content => {
            content.classList.remove('active', 'show', 'd-block');
            content.style.display = 'none';
        });

        showTargetStep(stepNumber);


        // Update stepper header
        document.querySelectorAll('.step').forEach((step, index) => {
            if (index === stepNumber - 1) {
                step.classList.add('active');
            } else {
                step.classList.remove('active');
            }
        });


        return true;
    }

    function goToStep(stepNumber) {
        console.log(`Navigating from ${currentStep} → ${stepNumber}`);

        // Special case: Prevent going back to step 1
        if (stepNumber === 1) return false;

        // When moving forward, validate current step first
        if (stepNumber > currentStep) {
            let validationPassed = true;

            if (currentStep === 2) {
                validationPassed = validateStep2();
                console.log('Step 2 validation:', validationPassed);
            }
            else if (currentStep === 3) {
                validationPassed = validateStep3();
                console.log('Step 3 validation:', validationPassed);
            }

            if (!validationPassed) {
                console.log('Validation failed - blocking navigation');
                return false;
            }

            // Only mark as completed if validation passed
            completedSteps.add(currentStep);
            updateStepVisuals();
        }

        // Proceed with navigation
        currentStep = stepNumber;

        // Hide all content
        document.querySelectorAll('.bs-stepper-content .content').forEach(content => {
            content.classList.remove('active', 'show', 'd-block');
            content.style.display = 'none';
        });

        // Show target step
        const targetStep = document.querySelector(`#step-${stepNumber}`);
        if (targetStep) {
            targetStep.classList.add('active', 'show', 'd-block');
            targetStep.style.display = 'block';
        }

        // Update stepper header
        document.querySelectorAll('.step').forEach((step, index) => {
            if (index === stepNumber - 1) {
                step.classList.add('active');
            } else {
                step.classList.remove('active');
            }
        });

        return true;
    }

    // Handle form submission in step 2
    const profileForm = document.getElementById('profileForm');
    if (profileForm) {
        profileForm.addEventListener('submit', async function (e) {
            e.preventDefault();

            const submitBtn = document.getElementById('submitProfileBtn');
            const originalText = submitBtn.innerHTML;

            // Validate form
            if (!validateStep2()) {
                return;
            }

            // Show loading state
            submitBtn.disabled = true;
            submitBtn.innerHTML = `
                <span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span>
                Processing...
            `;

            try {
                const formData = new FormData(profileForm);
                const response = await fetch(profileForm.action, {
                    method: 'POST',
                    body: formData,
                    headers: {
                        'X-CSRFToken': document.querySelector('[name=csrfmiddlewaretoken]').value
                    }
                });

                const data = await response.json();

                if (data.success) {
                    // Mark step 2 as completed
                    completedSteps.add(2);
                    updateStepVisuals();

                    // Go to step 3
                    goToStep(3);
                } else {
                    // Handle server-side validation errors
                    if (data.errors) {
                        for (const field in data.errors) {
                            const input = document.querySelector(`[name="${field}"]`);
                            if (input) {
                                input.classList.add('is-invalid');
                                const errorElement = document.createElement('div');
                                errorElement.className = 'invalid-feedback';
                                errorElement.textContent = data.errors[field];
                                input.parentNode.insertBefore(errorElement, input.nextSibling);
                            }
                        }
                    }
                    throw new Error('Form submission failed');
                }
            } catch (error) {
                console.error('Error:', error);
                alert('An error occurred. Please try again.');
            } finally {
                submitBtn.disabled = false;
                submitBtn.innerHTML = originalText;
            }
        });
    }

    // Update step visuals (checkmarks for completed steps)
    function updateStepVisuals() {
        document.querySelectorAll('.step').forEach((step, index) => {
            const stepNumber = index + 1;
            const circle = step.querySelector('.bs-stepper-circle');

            if (completedSteps.has(stepNumber)) {
                circle.classList.add('completed-step', 'bg-success', 'text-white', 'd-flex',
                    'justify-content-center', 'align-items-center');
                circle.innerHTML = '<i class="bi bi-check" style="font-size: 2rem;"></i>';
            } else {
                circle.classList.remove('completed-step', 'bg-success', 'text-white', 'd-flex',
                    'justify-content-center', 'align-items-center');
                circle.innerHTML = stepNumber;
            }
        });
    }

    // Navigation button handlers
    // document.addEventListener('click', function (e) {
    //     // Next button handler
    //     if (e.target.classList.contains('btn-next')) {
    //         e.preventDefault();
    //         console.log('btn-next clicked!');
    //         goToStep(currentStep + 1);
    //     }
    //
    //     // Previous button handler
    //     if (e.target.classList.contains('btn-prev')) {
    //         e.preventDefault();
    //         console.log('btn-prev clicked!');
    //         goToStep(currentStep - 1);
    //     }
    // });

    // Fix the space between title and content ---------CHECK ?!!!
    function fixContentSpacing() {
        document.querySelectorAll('.content').forEach(content => {
            const title = content.querySelector('h4');
            if (title) {
                title.style.marginBottom = '0.5rem';
            }
            const hr = content.querySelector('hr');
            if (hr) {
                hr.style.marginTop = '0.5rem';
                hr.style.marginBottom = '1rem';
            }
        });
    }

    // Show target step
    function showTargetStep(stepNumber) {
        const targetStep = document.querySelector(`#step-${stepNumber}`);
        targetStep.classList.add('active', 'show', 'd-block');
        targetStep.style.display = 'block';
    }


    //-------------------------------------------------------------------------------------------------
// Session validation for step 3
    function validateStep3() {
        console.log("[validateStep3] selectedSessions:", window.selectedSessions); // Debug

        // Get the selected sessions count from the global variable
        const selectedCount = window.selectedSessions ? window.selectedSessions.length : 0;
        const maxSelectable = window.maxSelectableSessions || 1; // Default to 1 if not set
        console.log('selectedCount: ', selectedCount);
        if (selectedCount !== maxSelectable || selectedCount === 0) {
            const msg = maxSelectable === 1
                ? "Please select 1 interview session"
                : `Please select ${maxSelectable} sessions`;

            showBootstrapAlert(msg, 'danger', 5000);

            return false;
        }
        return true;
    }


// Update the handleStepChange function to include step 3 validation
    function handleStepChange(targetStep) {
        // Prevent going back to step 1
        if (targetStep === 1) return false;

        // Validate current step before proceeding
        if (targetStep > currentStep) {
            if (currentStep === 2 && !validateStep2()) return false;
            if (currentStep === 3 && !validateStep3()) return false;

            // Mark current step as completed
            completedSteps.add(currentStep);
            updateStepVisuals();
        }

        // Update current step
        currentStep = targetStep;


        // Update UI
        // updateStepUI();

        // For step 4, update the review content
        if (targetStep === 4) {
            updateReviewContent();
        }

        return true;
    }

// Update review content in step 4
    function updateReviewContent() {
        if (!window.selectedSessions || window.selectedSessions.length === 0) {
            document.getElementById('SessionsTable').innerHTML = `
            <ul class="list-group list-group-flush">
                <li class="list-group-item">
                    <strong>You have not selected any sessions yet! Go to previous step and choose a time.</strong>
                </li>
            </ul>
        `;
            return;
        }

        // Generate the review content using the same function from reservation.js
        if (typeof generateOrderReview === 'function') {
            generateOrderReview(window.selectedSessions);
        }
    }

    // Handle next button in step 3
    document.getElementById('btnNextSchedule').addEventListener('click', function (e) {
        console.log('Next button clicked - currentStep:', currentStep);
        e.preventDefault();
        if (validateStep3()) {
            console.log('Proceeding to Step 4');
            goToStep(4);
        } else {
            console.log('Validation failed - staying on Step 3');
        }
    });
    // Handle final submission in step 4
    document.getElementById('btnFinalSubmit').addEventListener('click', function (e) {
        // Only handle the click if we're on step 4
        if (currentStep !== 4) return;

        e.preventDefault();

        // Validate sessions one more time
        if (!validateStep3()) {
            // handleStepChange(3); // Go back to step 3 if invalid
            // showTargetStep(3);

            // go to previous step by clicking on prev-btn
            const btnPrevious = this.closest('.d-md-flex')?.querySelector('.prev-btn');
            btnPrevious.click();
            return;
        }

        // Show loading state on the submit button
        const originalText = this.innerHTML;
        this.innerHTML = `
        <span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span>
        Processing...
    `;
        this.disabled = true;

        window.handleSubmitProcess();
    });
    //-------------------------------------------------------------------------------------------------

    // Initialize everything
    initializeStepper();
    disableHeaderNavigation();
    // fixContentSpacing();
});