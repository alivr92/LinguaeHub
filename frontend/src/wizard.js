import {validatePhoneNumber} from './phone.js';
import {validate_profile} from './profile.js';
import {validate_skills, submit_skills, initTooltips, initSelects} from './skills.js';
import {saveMethod} from './method.js';
import {validate_education, submit_education} from './edu.js';
import {submitTimes, validateAvailability} from './availability.js';
import {updatePricing} from './pricing.js';
import {showAlert} from './utils.js';
// Set MAX Entries limit based on VIP status (3 in general and 5 for VIP users)
export const maxEntries = parseInt(document.getElementById('maxEntries').value);
// Initialize the stepper
const stepperElement = document.querySelector('.bs-stepper');
const stepper = new Stepper(stepperElement, {
    linear: true
});
// Track completed steps (Step 1 is pre-completed)
const completedSteps = new Set([0]);
window.completedSteps = completedSteps;
let currentStep = 1; // We want to start at step 1
const totalSteps = 11; // CHECK LATER !!!!
// --------------------------------------------
// | Step 1: Basic Profile                    |
// | Step 2: Teaching Skill ( -- Not set --)  |
// | Step 3: Teaching Method                  |
// | Step 4: Education      ( -- Not set --)  |
// | Step 5: Availability                     |
// | Step 6: Pricing                          |
// | Step 7: Review                           |
// | Step 8: Result (Decision)                |
// | Step 9: Accepted (Approved)              |
// | Step 10: Rejected (Declined)             |
// --------------------------------------------

function initializeStepper() {
    // Read the step from the hidden input
    let stepValue = parseInt(document.getElementById('currentStep')?.value || '1', 10) - 1;

    // Cap the step if it's beyond your max step (e.g., 6 steps from 0 to 5)
    if (stepValue === 9 || stepValue === 10) {
        stepValue = 7; // keep in step 6 : "Result" -> 8
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

//---------------------- Handle skip action based on current step ----------------------
function handleSkipAction(step) {
    switch (step) {
        case 3:
            return skipStep3();
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
            return saveProfile();
        case 2:
            return saveSkills();
        case 3:
            return saveTeachingMethods();
        case 4:
            return saveEducation();
        case 5:
            return saveAvailability();
        case 6:
            return savePricing();
        case 7:
            return saveStep7();
        // Add more steps as needed
        default:
            console.error('Unknown step:', step);
            return false;
    }
}

//--------- Step-specific save functions
async function saveProfile() {
    const profileForm = document.getElementById('profileForm');
    if (!profileForm) {
        console.error('Profile form not found');
        return false;
    }

    const submitBtn = document.querySelector('#btnSave_profile, #btnNext_profile');
    const originalText = submitBtn?.innerHTML;

    try {
        if (!validate_profile()) {
            showAlert('Please correct the errors, then retry.', 'error');
            return false;
        } else if (!validatePhoneNumber()) {
            showAlert('Please insert a valid phone number, then retry.', 'error');
            return false;
        }
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
        showAlert('Your profile saved successfully.', 'success');
        completedSteps.add(1);
        updateCompletedSteps();
        return true;

    } catch (error) {
        console.error('Error saving profile:', error);
        showAlert('An error occurred. Please try again.', 'error');
        return false;
    } finally {
        if (submitBtn) {
            submitBtn.disabled = false;
            submitBtn.innerHTML = originalText;
        }
    }
}

async function saveSkills() {
    if (!validate_skills()) {
        return false;
    }
    try {
        const result = await submit_skills();
        if (result.success) {
            showAlert('Your skills saved successfully.', 'success');
            return true;
        } else {
            showAlert(result.error || 'Error saving skills', 'error');
            return false;
        }
    } catch (error) {
        console.error('Error saving skills:', error);
        showAlert('Error saving skills', 'error');
        return false;
    }
}
async function saveAvailability() {
    if (!validateAvailability()) {
        return false;
    }
    try {
        const result = await submitTimes();
        if (result.success) {
            showAlert('Your available times saved successfully.', 'success');
            completedSteps.add(5); // Make sure to mark step 5 as completed
            updateCompletedSteps();
            return true;
        } else {
            showAlert(result.error || 'Error saving availabilities', 'error');
            return false;
        }
    } catch (error) {
        console.error('Error saving availabilities:', error);
        showAlert('Error saving availabilities', 'error');
        return false;
    }
}

async function saveTeachingMethods() {
    const locationForm = document.getElementById('providerLocationForm');
    if (!locationForm) {
        console.error('location form not found');
        return false;
    }

    const submitBtn = document.querySelector('#btnSave_method, #btnNext_method');
    const originalText = submitBtn?.innerHTML;

    try {
        // if (!validate_teaching_method()) {
        //     showAlert('Please correct the errors, then retry.', 'error');
        //     return false;
        // }
        // Show loading state if buttons exist
        if (submitBtn) {
            submitBtn.disabled = true;
            submitBtn.innerHTML = `
                <span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span>
                Processing...
            `;
        }

        // Prepare and submit form data
        const formData = new FormData(locationForm);
        const url = `/tutor/wizard/submit-teaching-method/`;
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
        showAlert('Your teaching method saved successfully.', 'success');
        completedSteps.add(3);
        updateCompletedSteps();
        return true;

    } catch (error) {
        console.error('Error saving teaching method:', error);
        showAlert('An error occurred. Please try again.', 'error');
        return false;
    } finally {
        if (submitBtn) {
            submitBtn.disabled = false;
            submitBtn.innerHTML = originalText;
        }
    }
}

//validate_education() , submit_education()
async function saveEducation() {
    if (!validate_education()) {
        return false;
    }
    try {
        const result = await submit_education();
        if (result.success) {
            showAlert('Your Education and Qualifications saved successfully.', 'success');
            // Save was successful
            // updateReviewStep(); // <-- trigger refresh
            // location.reload(); // This will reload the whole page
            return true;
        } else {
            showAlert(result.error || 'Error saving education', 'error');
            return false;
        }
    } catch (error) {
        console.error('Error saving education:', error);
        showAlert('Error saving education', 'error');
        return false;
    }
}

// Availability

// Pricing
function savePricing() {
    console.log('save pricing!');
    updatePricing();
    location.reload(); // This will reload the whole page
    // Add your step 4 validation and save logic here
    // Return true if successful, false otherwise
    return true;
}

function saveStep7() {
    // Add your step 4 validation and save logic here
    // Return true if successful, false otherwise
    return true;
}

function skipStep3() {
    console.log('Skipping step 3 ...');
    // ****** Do VALIDATION  for data which inserted! or skip if cards are empty! ******
    // Add your step validation here

    location.reload(); // This will reload the whole page

    // Return true if successful, false otherwise
    return true;
}

function handleSubmitAction() {
    return true;
}

function goToStep_MAIN(stepNumber) {
    // console.log(`AVR-Navigating from ${currentStep} → ${stepNumber}`);
    // Prevent invalid navigation
    if (stepNumber < 1 || stepNumber > totalSteps) { // Assuming step 0 is disabled
        console.warn(`Invalid navigation to step ${stepNumber}`);
        return false;
    }
    // Update current step (no forward validation needed - already handled by handleSaveAction)
    // Proceed with navigation
    currentStep = stepNumber;

    // Update UI
    // Only mark as completed if validation passed
    completedSteps.add(currentStep - 1);
    updateCompletedSteps();

    // console.log('currentStep: ', currentStep);
    updateStepHeader(); // Update stepper header
    hideStepperContents(); // Hide all Stepper content divs
    showTargetStep(currentStep);  // Show target step
    return true;
}
function goToStep(stepNumber) {
    // Prevent invalid navigation
    if (stepNumber < 1 || stepNumber > totalSteps) {
        console.warn(`Invalid navigation to step ${stepNumber}`);
        return false;
    }

    // Update current step
    currentStep = stepNumber;

    // Update UI
    completedSteps.add(currentStep - 1); // Steps are 0-indexed in completedSteps
    updateCompletedSteps();

    updateStepHeader(currentStep - 1); // Update stepper header (0-indexed)
    hideStepperContents(); // Hide all Stepper content divs
    showTargetStep(currentStep);  // Show target step
    return true;
}

// Fix the updateStepHeader function

function updateStepHeader_MAIN(stepNumber) {
    document.querySelectorAll('.step').forEach((step, index) => {
        if (index === stepNumber) {
            // if (index === stepNumber - 1) {
            step.classList.add('active');
        } else {
            step.classList.remove('active');
        }
    });
}
function updateStepHeader(stepIndex) {
    document.querySelectorAll('.step').forEach((step, index) => {
        if (index === stepIndex) {
            step.classList.add('active');
        } else {
            step.classList.remove('active');
        }
    });
}
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

document.addEventListener('DOMContentLoaded', function () {

    initTooltips();
    initSelects();

    window.updateStepVisuals = updateCompletedSteps;


    // ------------------------------ Navigation button handlers --------------------------
    document.addEventListener('click', function (e) {
        const btn = e.target.closest('[data-step]'); // Handles icon clicks inside buttons
        if (!btn) return;

        const step = parseInt(btn.getAttribute('data-step'));
        const action = btn.getAttribute('data-action');

        e.preventDefault();

        switch (action) {
            case 'prev':
                goToStep(step - 1); // No validation needed
                break;
            case 'skip':
                handleSkipAction(step); // Validates internally
                goToStep(step + 1);
                break;
            case 'save':
                handleSaveAction(step); // Validates internally
                break;
            case 'next':
                // next process for step 4, 5
                // if (handleSaveAction(step)) {
                //     goToStep(step + 1);
                // }
                // next process for step 1 to 3
                handleSaveAction(step).then(success => {
                    if (success) {
                        goToStep(step + 1);
                    }
                }).catch(error => {
                    console.error('Error:', error);
                });
                break;


            case 'submit':
                // console.log(`Submission clicked for step ${step}`);
                // handleSubmitAction would validate final step
                // if (await (handleSubmitAction(step))) {
                if (handleSubmitAction(step)) {
                    goToStep(step + 1);// OR Go to submission page!
                }
                break;
        }
    });
    //-------------------------------------------------------------------------------------

    // Initialize everything
    initializeStepper();
    disableHeaderNavigation();
});

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