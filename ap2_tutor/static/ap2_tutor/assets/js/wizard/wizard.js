import {validateStep3, submitStep3, initTooltips, initSelects} from './step3_skills.js';
import {validateStep4, submitStep4} from './step4_edu.js';
// Import shared utilities
// import {} from '/static/assets/js/fileHandlers.js';
// import {showBootstrapAlert2} from '/static/assets/js/avr.js';
// Set MAX Entries limit based on VIP status (3 in general and 5 for VIP users)
export const maxEntries = parseInt(document.getElementById('maxEntries').value);


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

    initTooltips();
    initSelects();
    // Initialize the stepper
    const stepperElement = document.querySelector('.bs-stepper');
    const stepper = new Stepper(stepperElement, {
        linear: true
    });

    window.updateStepVisuals = updateCompletedSteps;
    // Track completed steps (Step 1 is pre-completed)
    const completedSteps = new Set([1]);
    window.completedSteps = completedSteps;
    let currentStep = 2; // We want to start at step 2
    const totalSteps = 6;

    function initializeStepper() {
        // Read the step from the hidden input
        let stepValue = parseInt(document.getElementById('currentStep')?.value || '1', 10) - 1;

        // Cap the step if it's beyond your max step (e.g., 6 steps from 0 to 5)
        if (stepValue === 6 || stepValue === 7) {
            stepValue = 5; // keep in step 6 : "Result"
            completedSteps.add(6);
            updateCompletedSteps();
        }

        // Hide all content divs
        hideStepperContents();

        // Mark previous steps as completed by for-loop
        for (let i = 1; i <= stepValue; i++) {
            completedSteps.add(i);
        }

        // Set current step (for correct functionality of btn-next and btn-prev)
        console.log('stepValue : ', stepValue);
        goToStep(stepValue + 1);

        // Show only the correct step
        // const stepId = `#step-${stepValue + 1}`;  // +1 because your step IDs are 1-based
        // const targetStep = document.querySelector(stepId);
        // if (targetStep) {
        //     targetStep.classList.add('active', 'show', 'd-block');
        //     targetStep.style.display = 'block';
        // }
        // showTargetStep(stepValue + 1);

        updateStepHeader(stepValue); // Update stepper header state (Show us active step!)
        updateCompletedSteps(); // Update visual indicators
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

    // ------------------------------ Navigation button handlers --------------------------
    document.addEventListener('click', function (e) {
        const btn = e.target.closest('[data-step]'); // Handles icon clicks inside buttons
        if (!btn) return;

        const step = parseInt(btn.getAttribute('data-step'));
        const action = btn.getAttribute('data-action');

        e.preventDefault();

        switch (action) {
            case 'prev':
                console.log(`Previous clicked for step ${step}`);
                goToStep(step - 1); // No validation needed
                break;
            case 'skip':
                console.log(`Skip clicked for step ${step}`);
                handleSkipAction(step); // Validates internally
                goToStep(step + 1);
                break;
            case 'save':
                console.log(`Save clicked for step ${step}`);
                handleSaveAction(step); // Validates internally
                break;
            case 'next':
                console.log(`Next clicked for step ${step}`);
                // if (handleSaveAction(step)) {
                //     goToStep(step + 1);
                // }
                handleSaveAction(step).then(success => {
                    if (success) {
                        goToStep(step + 1);
                    }
                }).catch(error => {
                    console.error('Error:', error);
                });
                break;

            case 'submit':
                console.log(`Submission clicked for step ${step}`);
                // handleSubmitAction would validate final step
                // if (await (handleSubmitAction(step))) {
                if (handleSubmitAction(step)) {
                    goToStep(step + 1);// OR Go to submission page!
                }
                break;
        }
    });
    //-------------------------------------------------------------------------------------
    //---------------------- Handle skip action based on current step ----------------------
    function handleSkipAction(step) {
        switch (step) {
            case 1:
                return skipStep1();
            case 4:
                return skipStep4();
            // Add more steps as needed
            default:
                console.error('Unknown step:', step);
                return false;
        }
    }

    //---------------------- Handle save action based on current step ----------------------
    function handleSaveAction(step) {
        switch (step) {
            case 1:
                return skipStep1();
            case 2:
                return saveStep2();
            case 3:
                return saveStep3();
            case 4:
                return saveStep4();
            // Add more steps as needed
            default:
                console.error('Unknown step:', step);
                return false;
        }
    }

    //--------- Step-specific save functions
    async function saveStep2() {
        const profileForm = document.getElementById('profileForm');
        if (!profileForm) {
            console.error('Profile form not found');
            return false;
        }

        const submitBtn = document.querySelector('#btnSave_step2, #btnNext_step2');
        const originalText = submitBtn?.innerHTML;

        try {
            if (!validateStep2()) return false;

            // Show loading state if buttons exist
            if (submitBtn) {
                submitBtn.disabled = true;
                submitBtn.innerHTML = `
                <span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span>
                Processing...
            `;
            }

            // Prepare and submit form data
            const formData = new FormData(profileForm);
            const url = `/tutor/wizard/submit-profile/`;
            const response = await fetch(url, {
                method: 'POST',
                body: formData,
                headers: {
                    'X-CSRFToken': document.querySelector('[name=csrfmiddlewaretoken]').value
                }
            });

            const data = await response.json();

            if (!data.success) {
                if (data.errors) {
                    clearExistingErrors();
                    for (const field in data.errors) {
                        showFieldError(field, data.errors[field]);
                    }
                }
                throw new Error(data.message || 'Form submission failed');
            }

            completedSteps.add(2);
            updateCompletedSteps();
            return true;

        } catch (error) {
            console.error('Error saving step 2:', error);
            showAlert('An error occurred. Please try again.', 'danger');
            return false;
        } finally {
            if (submitBtn) {
                submitBtn.disabled = false;
                submitBtn.innerHTML = originalText;
            }
        }
    }

    async function saveStep3_main() {
        console.log('Saving step 3 data');
        // Client-side validation
        if (!validateStep3()) return false;

        try {
            const result = await submitStep3();
            if (result.success) {
                // showBootstrapAlert(result.success || 'Your skills saved successfully.', 'success', 5000);
                showBootstrapAlert('Your skills saved successfully.', 'success', 5000);
                return true;
            } else {
                showBootstrapAlert(result.error || 'Error saving skills', 'danger', 5000);
                return false;
            }
        } catch (error) {
            console.error('Error saving step 3:', error);
            return false;
        }
    }

    async function saveStep3() {
        console.log('Saving step 3 data');
        // Client-side validation
        let temp = validateStep3();
        console.log('validateStep3: ', temp);
        if (!validateStep3()) {
            return false;
        }
        try {
            const result = await submitStep3();
            if (result.success) {
                showBootstrapAlert('Your skills saved successfully.', 'success', 5000);
                return true;
            } else {
                showBootstrapAlert(result.error || 'Error saving skills', 'danger', 5000);
                return false;
            }
        } catch (error) {
            console.error('Error saving step 3:', error);
            showBootstrapAlert('Error saving skills', 'danger', 5000);
            return false;
        }
    }

    //validateStep4() , submitStep4()
    async function saveStep4() {
        console.log('Saving step 4 data ...');
        // Client-side validation
        let temp = validateStep4();
        console.log('validateStep4: ', temp);
        if (!validateStep4()) {
            return false;
        }
        try {
            const result = await submitStep4();
            if (result.success) {
                showBootstrapAlert('Your Education and Qualifications saved successfully.', 'success', 5000);
                return true;
            } else {
                showBootstrapAlert(result.error || 'Error saving education', 'danger', 5000);
                return false;
            }
        } catch (error) {
            console.error('Error saving step 4:', error);
            showBootstrapAlert('Error saving education', 'danger', 5000);
            return false;
        }
    }

    function saveStep5() {
        // Add your step 4 validation and save logic here
        // Return true if successful, false otherwise
        return true;
    }

    function skipStep1() {
        console.log('Skipping step 1 ...');
        return true;
    }

    function skipStep4() {
        console.log('Skipping step 4 ...');
        // ****** Do VALIDATION  for data which inserted! or skip if cards are empty! ******
        // Add your step 4 validation here
        // Return true if successful, false otherwise
        return true;
    }


    function handleSubmitAction() {
        return true;
    }


    //--------------------------------------------------------------------------------------------
    function goToStep(stepNumber) {
        console.log(`AVR-Navigating from ${currentStep} → ${stepNumber}`);
        // Prevent invalid navigation
        if (stepNumber < 2 || stepNumber > totalSteps) { // Assuming step 1 is disabled
            console.warn(`Invalid navigation to step ${stepNumber}`);
            return false;
        }
        // Update current step (no forward validation needed - already handled by handleSaveAction)
        // Proceed with navigation
        currentStep = stepNumber;

        // Update UI
        // Only mark as completed if validation passed
        completedSteps.add(currentStep);
        updateCompletedSteps();

        console.log('currentStep: ', currentStep);
        updateStepHeader(); // Update stepper header
        hideStepperContents(); // Hide all Stepper content divs
        showTargetStep(currentStep);  // Show target step
        return true;
    }

    //------------------------------------------------------------------------
    //--------------------------- Step Validations ---------------------------
    function validateStep2() {
        console.log('validation step 2 ...');
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

    //------------------------------------------------------------------------
    // -------------------------- Helper Functions ---------------------------
    // Update step visuals (checkmarks for completed steps)
    function updateCompletedSteps() {
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

    // Hide all content divs
    function hideStepperContents() {
        document.querySelectorAll('.bs-stepper-content .content').forEach(content => {
            content.classList.remove('active', 'show', 'd-block');
            content.style.display = 'none';
        });
        return;
    }


    // Show target step
    function showTargetStep(stepNumber) {
        const targetStep = document.querySelector(`#step-${stepNumber}`);
        if (targetStep) {
            targetStep.classList.add('active', 'show', 'd-block');
            targetStep.style.display = 'block';
        }
    }

    function clearExistingErrors() {
        document.querySelectorAll('.is-invalid').forEach(el => {
            el.classList.remove('is-invalid');
        });
        document.querySelectorAll('.invalid-feedback').forEach(el => {
            el.remove();
        });
    }

    function showFieldError(fieldName, message) {
        const input = document.querySelector(`[name="${fieldName}"]`);
        if (input) {
            input.classList.add('is-invalid');
            const errorElement = document.createElement('div');
            errorElement.className = 'invalid-feedback';
            errorElement.textContent = Array.isArray(message) ? message[0] : message;
            input.parentNode.appendChild(errorElement);
        }
    }


    function updateStepHeader(stepNumber) {
        document.querySelectorAll('.step').forEach((step, index) => {
            if (index === stepNumber) {
                // if (index === stepNumber - 1) {
                step.classList.add('active');
            } else {
                step.classList.remove('active');
            }
        });
        // document.querySelectorAll('.step').forEach((step, index) => {
        //     if (index === stepValue) {
        //         step.classList.add('active');
        //     } else {
        //         step.classList.remove('active');
        //     }
        // });
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

    function showAlert(message, type = 'danger') {
        // Implement your alert/notification system
        alert(message); // Replace with your preferred notification system
    }

//--------------------------------------------------------------------------------------------

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

    // Handle final submission in step 4
    // document.getElementById('btnFinalSubmit').addEventListener('click', function (e) {
    //     // Only handle the click if we're on step 4
    //     if (currentStep !== 4) return;
    //
    //     e.preventDefault();
    //
    //     // Validate sessions one more time
    //     if (!validateStep3()) {
    //         // handleStepChange(3); // Go back to step 3 if invalid
    //         // showTargetStep(3);
    //
    //         // go to previous step by clicking on prev-btn
    //         const btnPrevious = this.closest('.d-md-flex')?.querySelector('.prev-btn');
    //         btnPrevious.click();
    //         return;
    //     }
    //
    //     // Show loading state on the submit button
    //     const originalText = this.innerHTML;
    //     this.innerHTML = `
    //     <span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span>
    //     Processing...
    // `;
    //     this.disabled = true;
    //
    //     window.handleSubmitProcess();
    // });
    //-------------------------------------------------------------------------------------------------

    // Initialize everything
    initializeStepper();
    disableHeaderNavigation();
    // fixContentSpacing();
});


//--------------------------------------- Archived -----------------------------------------------
// Step 2 Form validation
function validateStep2_DELETE() {
    const profileForm = document.getElementById('profileForm');
    if (!profileForm) {
        console.error('Profile form not found');
        return false;
    }

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

// Handle step navigation
function goToStep_DELETE(stepNumber) {
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

function goToStep_main(stepNumber) {
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

// Handle next button in step 3
// document.getElementById('btnNextSchedule').addEventListener('click', function (e) {
//     console.log('Next button clicked - currentStep:', currentStep);
//     e.preventDefault();
//     if (validateStep3()) {
//         console.log('Proceeding to Step 4');
//         goToStep(4);
//     } else {
//         console.log('Validation failed - staying on Step 3');
//     }
// });

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

function showAlert(message, type) {
    const container = document.getElementById("alert-container");
    const alertBox = document.createElement("div");
    alertBox.className = `alert alert-${type} alert-dismissible`;
    alertBox.innerHTML = `${message}<button type="button" class="close" data-dismiss="alert">&times;</button>`;
    container.appendChild(alertBox);
}
