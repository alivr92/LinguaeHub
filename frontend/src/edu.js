import {showAlert, showConfirm, showWizardErrors, modalManager} from './utils.js';

import {initSelects} from "./skills.js";

const maxEntries = parseInt(document.getElementById('maxEntries').value);

// =============================================
// GLOBAL VARIABLES
// =============================================
const educationTemplate = document.getElementById('education-template');
const certificationTemplate = document.getElementById('certification-template');
const applicantUId = parseInt(document.getElementById('applicantUId').value);
const educationContainer = document.getElementById('education-container');
const certificationContainer = document.getElementById('certification-container');
const validDocumentTypes = ['pdf', 'jpg', 'jpeg', 'png'];
const currentYear = new Date().getFullYear();
// const maxYear = currentYear + 10;
const maxYear = currentYear;

// ===== FILE STATE TRACKING =====
const trackers = {
    // attached file to the certification
    educationDoc: {
        existed: [],   // IDs that existed when loaded
        uploaded: [],  // New document uploads
        changed: [],   // Documents that replaced existing ones
        removed: []    // Documents that were removed
    },
    certificationDoc: {
        existed: [],
        uploaded: [],
        changed: [],
        removed: []
    },
    certification: {
        new: [],
        existed: [],
        removed: []
    },
    education: {
        new: [],
        existed: [],
        removed: []
    },
};

// ====================== EXPORTED FUNCTIONS ======================
export function validate_education_main() {
    // console.log(`validate4-trackers: `, trackers);
    let isValid = true;

    // Validate education entries
    const educationCards = educationContainer.querySelectorAll('.education-card');
    educationCards.forEach((card, index) => {
        const cardId = card.dataset.entryId;
        const degree = card.querySelector('[name="degree_level"]');
        const field = card.querySelector('[name="study_field"]');
        const institution = card.querySelector('[name="institution"]');
        const startYear = card.querySelector('[name="start_year"]');
        const endYear = card.querySelector('[name="end_year"]');
        const description = card.querySelector('[name="description"]');
        const documentInput = card.querySelector('[name="education_file"]');
        // Required fields validation
        if (!degree?.value) {
            showAlert(`Please select a degree for Education entry ${index + 1}`, 'error');
            isValid = false;
        }
        if (!field?.value) {
            showAlert(`Please enter a field of study for Education entry ${index + 1}`, 'error');
            isValid = false;
        }
        if (!institution?.value) {
            showAlert(`Please enter an institution for Education entry ${index + 1}`, 'error');
            isValid = false;
        }
        if (!startYear?.value) {
            showAlert(`Please enter a start year for Education entry ${index + 1}`, 'error');
            isValid = false;
        } else if (startYear.value < 1900 || startYear.value > maxYear) {
            showAlert(`Please enter a valid start year (1900–${maxYear}) for Education entry ${index + 1}`, 'error');
            isValid = false;
        }
        if (!endYear?.value) {
            showAlert(`Please enter a graduation year for Education entry ${index + 1}`, 'error');
            isValid = false;
        } else if (endYear.value < 1900 || endYear.value > maxYear) {
            showAlert(`Please enter a valid graduation year (1900–${maxYear}) for Education entry ${index + 1}`, 'error');
            isValid = false;
        } else if (endYear?.value < startYear.value) {
            showAlert(`Graduation year must be greater than or equal to start year for Education entry ${index + 1}`, 'error');
            isValid = false;
        }

        if (description?.value && description.value.length > 500) {
            showAlert(`Description for Education entry ${index + 1} must be 500 characters or less`, 'error');
            isValid = false;
        }


        // Document validation if newly uploaded
        if (documentInput?.files[0]) {
            const file = documentInput.files[0];
            if (!validateFileType(file, validDocumentTypes)) {
                showAlert(`Invalid document format for education entry ${index + 1}. Allowed: ${validDocumentTypes.join(', ')}`, 'error');
                isValid = false;
            } else {
                // const isExisted = trackers.education.existed.includes(cardId);
                // const action = isExisted ? 'changed' : 'uploaded';
                // updateTracker('education', action, cardId);
            }
        }
    });

    // Validate certification entries
    const certificationCards = certificationContainer.querySelectorAll('.certification-card');
    certificationCards.forEach((card, index) => {
        const cardId = card.dataset.entryId;
        const name = card.querySelector('[name="cert_name"]');
        const org = card.querySelector('[name="cert_org"]');
        const year = card.querySelector('[name="cert_year"]');
        const documentInput = card.querySelector('[name="certification_file"]');

        // Required fields validation
        if (!name?.value) {
            showAlert(`Please select a certificate name for certification ${index + 1}`, 'error');
            isValid = false;
        }
        if (!org?.value || org.value.trim().length < 2) {
            showAlert(`Please enter a valid issuing organization (at least 2 characters) for Certification entry ${index + 1}`, 'error');
            isValid = false;
        }

        if (!year?.value) {
            showAlert(`Please enter a completion year for Certification entry ${index + 1}`, 'error');
            isValid = false;
        } else {
            const yearValue = parseInt(year.value, 10); // 10 : base decimal
            if (isNaN(yearValue) || yearValue < 1900 || yearValue > maxYear) {
                showAlert(`Please enter a valid completion year (1900–${maxYear}) for Certification entry ${index + 1}`, 'error');
                isValid = false;
            }
        }

        // Document validation if newly uploaded
        if (documentInput?.files[0]) {
            const file = documentInput.files[0];
            if (!validateFileType(file, validDocumentTypes)) {
                showAlert(`Invalid document format for certification ${index + 1}. Allowed: ${validDocumentTypes.join(', ')}`, 'error');
                isValid = false;
            } else {
                // const isExisted = trackers.certification.existed.includes(cardId);
                // const action = isExisted ? 'changed' : 'uploaded';
                // updateTracker('certificationDoc', action, cardId);

            }
        } else {
            showAlert(`Please upload a suitable document for certification ${index + 1}`, 'error');
            isValid = false;
        }
    });

    return isValid;
}

export function validate_education() {
    const currentYear = new Date().getFullYear();
    const maxYear = currentYear + 10;
    const MAX_FILE_SIZE_MB = 5;
    const MAX_FILE_SIZE_BYTES = MAX_FILE_SIZE_MB * 1024 * 1024;
    const validDocumentTypes = ['pdf', 'jpg', 'jpeg', 'png'];
    const errors = [];

    // Validate education entries
    const educationCards = educationContainer.querySelectorAll('.education-card');
    educationCards.forEach((card, index) => {
        const cardId = card.dataset.entryId;
        const cardPrefix = `education-card-${index + 1}`;
        const removeFlag = card.querySelector(`[name="education_remove_${cardId}"]`);

        if (removeFlag?.value === 'true') return;

        const degree = card.querySelector('[name="degree_level"]');
        const field = card.querySelector('[name="study_field"]');
        const institution = card.querySelector('[name="institution"]');
        const startYear = card.querySelector('[name="start_year"]');
        const endYear = card.querySelector('[name="end_year"]');
        const description = card.querySelector('[name="description"]');
        const documentInput = card.querySelector(`[name="education_doc_${cardId}"]`);

        // Degree validation
        if (!degree?.value) {
            errors.push({
                message: `Education #${index + 1}: Please select a degree level`,
                selector: `[name="degree_level"]`,
                cardId
            });
        }

        // Field of study validation
        if (!field?.value || field.value.trim().length < 2) {
            errors.push({
                message: `Education #${index + 1}: Field of study must be at least 2 characters`,
                selector: `[name="study_field"]`,
                cardId
            });
        } else if (field.value.trim().length > 100) {
            errors.push({
                message: `Education #${index + 1}: Field of study must be 100 characters or less`,
                selector: `[name="study_field"]`,
                cardId
            });
        }

        // Institution validation
        if (!institution?.value || institution.value.trim().length < 2) {
            errors.push({
                message: `Education #${index + 1}: Institution name must be at least 2 characters`,
                selector: `[name="institution"]`,
                cardId
            });
        } else if (institution.value.trim().length > 150) {
            errors.push({
                message: `Education #${index + 1}: Institution name must be 150 characters or less`,
                selector: `[name="institution"]`,
                cardId
            });
        }

        // Year validation
        const startYearValue = startYear?.value ? parseInt(startYear.value, 10) : null;
        const endYearValue = endYear?.value ? parseInt(endYear.value, 10) : null;

        if (!startYearValue || isNaN(startYearValue)) {
            errors.push({
                message: `Education #${index + 1}: Please enter a valid start year`,
                selector: `[name="start_year"]`,
                cardId
            });
        } else if (startYearValue < 1900 || startYearValue > maxYear) {
            errors.push({
                message: `Education #${index + 1}: Start year must be between 1900 and ${maxYear}`,
                selector: `[name="start_year"]`,
                cardId
            });
        }

        if (!endYearValue || isNaN(endYearValue)) {
            errors.push({
                message: `Education #${index + 1}: Please enter a valid graduation year`,
                selector: `[name="end_year"]`,
                cardId
            });
        } else if (endYearValue < 1900 || endYearValue > maxYear) {
            errors.push({
                message: `Education #${index + 1}: Graduation year must be between 1900 and ${maxYear}`,
                selector: `[name="end_year"]`,
                cardId
            });
        } else if (startYearValue && endYearValue < startYearValue) {
            errors.push({
                message: `Education #${index + 1}: Graduation year cannot be before start year`,
                selector: `[name="end_year"]`,
                cardId
            });
        }

        // Description validation
        if (description?.value && description.value.length > 500) {
            errors.push({
                message: `Education #${index + 1}: Description must be 500 characters or less`,
                selector: `[name="description"]`,
                cardId
            });
        }

        // Document validation (optional for education)
        if (documentInput?.files[0]) {
            const file = documentInput.files[0];
            if (!validateFileType(file, validDocumentTypes)) {
                errors.push({
                    message: `Education #${index + 1}: Invalid document format. Allowed: ${validDocumentTypes.join(', ')}`,
                    selector: `[name="education_doc_${cardId}"]`,
                    cardId
                });
            } else if (file.size > MAX_FILE_SIZE_BYTES) {
                errors.push({
                    message: `Education #${index + 1}: Document exceeds maximum size of ${MAX_FILE_SIZE_MB}MB`,
                    selector: `[name="education_doc_${cardId}"]`,
                    cardId
                });
            }
        }
    });

    // Validate certification entries
    const certificationCards = certificationContainer.querySelectorAll('.certification-card');
    certificationCards.forEach((card, index) => {
        const cardId = card.dataset.entryId;
        const cardPrefix = `certification-card-${index + 1}`;
        const removeFlag = card.querySelector(`[name="certification_remove_${cardId}"]`);

        if (removeFlag?.value === 'true') return;

        const name = card.querySelector('[name="cert_name"]');
        const org = card.querySelector('[name="cert_org"]');
        const year = card.querySelector('[name="cert_year"]');
        const documentInput = card.querySelector(`[name="certification_doc_${cardId}"]`);

        // Name validation
        if (!name?.value) {
            errors.push({
                message: `Certification #${index + 1}: Please select a certificate name`,
                selector: `[name="cert_name"]`,
                cardId
            });
        }

        // Organization validation
        if (!org?.value || org.value.trim().length < 2) {
            errors.push({
                message: `Certification #${index + 1}: Organization must be at least 2 characters`,
                selector: `[name="cert_org"]`,
                cardId
            });
        } else if (org.value.trim().length > 150) {
            errors.push({
                message: `Certification #${index + 1}: Organization name must be 150 characters or less`,
                selector: `[name="cert_org"]`,
                cardId
            });
        }

        // Year validation
        const yearValue = year?.value ? parseInt(year.value, 10) : null;
        if (!yearValue || isNaN(yearValue)) {
            errors.push({
                message: `Certification #${index + 1}: Please enter a valid completion year`,
                selector: `[name="cert_year"]`,
                cardId
            });
        } else if (yearValue < 1900 || yearValue > maxYear) {
            errors.push({
                message: `Certification #${index + 1}: Completion year must be between 1900 and ${maxYear}`,
                selector: `[name="cert_year"]`,
                cardId
            });
        }

        // Document validation (required for certification)
        const isNewCard = trackers.certification.new.includes(cardId);
        const hasExistingFile = trackers.certificationDoc.existed.includes(cardId);

        if (isNewCard && !hasExistingFile && !documentInput?.files[0]) {
            errors.push({
                message: `Certification #${index + 1}: Please upload a document`,
                selector: `[name="certification_doc_${cardId}"]`,
                cardId
            });
        }
        else if (documentInput?.files[0]) {
            const file = documentInput.files[0];
            const extension = file.name.split('.').pop().toLowerCase();

            if (!validDocumentTypes.includes(extension)) {
                errors.push({
                    message: `Certification #${index + 1}: Invalid document format. Allowed: ${validDocumentTypes.join(', ')}`,
                    selector: `[name="certification_doc_${cardId}"]`,
                    cardId
                });
            }

            if (file.size > MAX_FILE_SIZE_BYTES) {
                errors.push({
                    message: `Certification #${index + 1}: Document exceeds maximum size of ${MAX_FILE_SIZE_MB}MB`,
                    selector: `[name="certification_doc_${cardId}"]`,
                    cardId
                });
            }
        }
    });

    // Process validation results
    if (errors.length > 0) {
        showWizardErrors(errors);

        // Scroll to first error
        const firstError = errors[0];
        const firstErrorElement = document.querySelector(firstError.selector);
        if (firstErrorElement) {
            firstErrorElement.scrollIntoView({
                behavior: 'smooth',
                block: 'center'
            });
            firstErrorElement.focus();
        }

        return false;
    }

    // showAlert('All education and certification information is valid', 'success');
    return true;
}

export async function submit_education() {
    if (!validate_education()) {
        showAlert('Please correct the errors in the form before submitting.', 'error');
        return {success: false, error: 'Validation failed'};
    }

    const formData = new FormData();

    try {
        // Add form data
        formData.append('years_experience', document.querySelector('#id_years_experience').value);

        // For teaching_tags (assuming it's a multi-select or similar):
        const selectedTags = Array.from(document.querySelectorAll('#id_teaching_tags option:checked'))
            .map(opt => opt.value);
        formData.append('teaching_tags', JSON.stringify(selectedTags));

        // Add tracking data
        formData.append('education_new', JSON.stringify(trackers.education.new));
        formData.append('education_removed', JSON.stringify(trackers.education.removed));
        formData.append('education_doc_uploaded', JSON.stringify(trackers.educationDoc.uploaded));
        formData.append('education_doc_changed', JSON.stringify(trackers.educationDoc.changed));
        formData.append('education_doc_removed', JSON.stringify(trackers.educationDoc.removed));
        formData.append('certification_new', JSON.stringify(trackers.certification.new));
        formData.append('certification_removed', JSON.stringify(trackers.certification.removed));
        formData.append('certification_doc_uploaded', JSON.stringify(trackers.certificationDoc.uploaded));
        formData.append('certification_doc_changed', JSON.stringify(trackers.certificationDoc.changed));
        formData.append('certification_doc_removed', JSON.stringify(trackers.certificationDoc.removed));

        // Process education cards
        const educationCards = educationContainer.querySelectorAll('.education-card');
        educationCards.forEach(card => {
            const cardId = card.dataset.entryId;

            formData.append(`education_ids[]`, cardId);
            formData.append(`degrees[]`, card.querySelector('[name="degree_level"]').value);
            formData.append(`fields[]`, card.querySelector('[name="study_field"]').value);
            formData.append(`institutions[]`, card.querySelector('[name="institution"]').value);
            formData.append(`start_years[]`, card.querySelector('[name="start_year"]').value);
            formData.append(`end_years[]`, card.querySelector('[name="end_year"]').value);
            formData.append(`descriptions[]`, card.querySelector('[name="description"]').value || '');

            const documentInput = card.querySelector(`[name="education_doc_${cardId}"]`);
            if (documentInput?.files[0]) {
                formData.append(`education_doc_${cardId}`, documentInput.files[0]);
            }
            const removeFlag = card.querySelector(`[name="education_remove_${cardId}"]`);
            if (removeFlag) formData.append(removeFlag.name, removeFlag.value);
        });

        // Process certification cards
        const certificationCards = certificationContainer.querySelectorAll('.certification-card');
        certificationCards.forEach(card => {
            const cardId = card.dataset.entryId;

            formData.append(`certification_ids[]`, cardId);
            formData.append(`cert_names[]`, card.querySelector('[name="cert_name"]').value);
            formData.append(`cert_orgs[]`, card.querySelector('[name="cert_org"]').value);
            formData.append(`cert_years[]`, card.querySelector('[name="cert_year"]').value);

            const documentInput = card.querySelector(`[name="certification_doc_${cardId}"]`);
            if (documentInput?.files[0]) {
                formData.append(`certification_doc_${cardId}`, documentInput.files[0]);
            }

            const removeFlag = card.querySelector(`[name="certification_remove_${cardId}"]`);
            if (removeFlag) formData.append(removeFlag.name, removeFlag.value);
        });

        // Add CSRF token
        const csrfToken = document.querySelector('[name="csrfmiddlewaretoken"]')?.value;
        if (csrfToken) formData.append('csrfmiddlewaretoken', csrfToken);

        // Initialize XHR
        const xhr = new XMLHttpRequest();
        xhr.open('POST', '/tutor/save-educations/', true);
        xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');

        // Show modal
        modalManager.show('Uploading Education Data');

        return new Promise((resolve, reject) => {
            // Progress tracking
            xhr.upload.onprogress = (event) => {
                modalManager.updateProgress(event);
            };

            // Set up cancel button
            modalManager.setupCancelButton(xhr);

            // Completion handler
            xhr.onload = async () => {
                if (xhr.status >= 200 && xhr.status < 300) {
                    try {
                        const result = JSON.parse(xhr.responseText);
                        if (result.success) {
                            // Mark success and wait a moment before hiding
                            modalManager.markSuccess('Upload completed! Finalizing...');

                            // Reset trackers and load data
                            resetTrackers();

                            try {
                                await loadExistingData();
                                // Show warnings if any
                                if (result.warnings?.length) {
                                    result.warnings.forEach(warning => showAlert(warning, 'warning'));
                                }
                                // Give a small delay for user to see success message
                                setTimeout(() => {
                                    modalManager.hide();
                                    // showAlert('Education and certification data saved successfully!', 'success');
                                }, 1000);
                                resolve(result);
                            } catch (loadError) {
                                console.error('Error loading data:', loadError);
                                modalManager.hide();
                                showAlert('Data saved but there was an issue refreshing the page.', 'warning');
                                resolve(result);
                            }

                        } else {
                            modalManager.markError(result.error || 'Failed to save education data.');
                            setTimeout(() => {
                                modalManager.hide();
                                showAlert(result.error || 'Failed to save education data.', 'error');
                            }, 2000);
                            reject(new Error(result.error || 'Failed to save education data'));
                        }
                    } catch (e) {
                        modalManager.markError('Invalid server response.');
                        setTimeout(() => {
                            modalManager.hide();
                            showAlert('Invalid server response.', 'error');
                        }, 2000);
                        reject(new Error('Invalid server response'));
                    }
                } else {
                    modalManager.markError(`Server error: ${xhr.status}`);
                    setTimeout(() => {
                        modalManager.hide();
                        showAlert('Failed to save education data.', 'error');
                    }, 2000);
                    reject(new Error(`HTTP error: ${xhr.status}`));
                }
            };

            // Error handling
            xhr.onerror = () => {
                modalManager.markError('Network error during upload.');
                setTimeout(() => {
                    modalManager.hide();
                    showAlert('Network error during upload.', 'error');
                }, 2000);
                reject(new Error('Network error'));
            };

            xhr.onabort = () => {
                modalManager.hide();
                showAlert('Upload cancelled.', 'info');
                reject(new Error('Upload aborted'));
            };

            xhr.timeout = 30000; // 30 seconds timeout
            xhr.ontimeout = () => {
                modalManager.markError('Request timed out.');
                setTimeout(() => {
                    modalManager.hide();
                    showAlert('Request timed out.', 'error');
                }, 2000);
                reject(new Error('Timeout'));
            };

            xhr.send(formData);
        });
    } catch (error) {
        modalManager.hide();
        console.error('Submission error:', error);
        showAlert(error.message || 'Failed to save education data. Please try again.', 'error');
        return {success: false, error: error.message || 'Failed to save education data'};
    }
}

// =============================================
// MAIN FUNCTIONS
// =============================================

function resetTrackers() {
    // Reset file state trackers
    Object.keys(trackers).forEach(type => {
        Object.keys(trackers[type]).forEach(action => {
            trackers[type][action] = [];
        });
    });
}


function addBlankCard(type) {
    if (checkCardLimit(type)) return null;
    const cardId = `${type}_${Date.now()}`;
    const template = type === 'education' ? educationTemplate : certificationTemplate;
    const container = type === 'education' ? educationContainer : certificationContainer;
    const card = createCard(type, template, cardId);
    if (card) {
        container.appendChild(card);
        updateTracker(type, 'new', cardId); // Track new card
    }
    return cardId;
}

function createCard(type, template, cardId, options = {}) {
    // if (!educationTemplate) {
    //     console.error(`${type} template not found!`);
    //     return null;
    // }

    if (!template) {
        console.error(`${type} template not found!`);
        return null;
    }

    const newCard = template.content.cloneNode(true);
    const card = newCard.querySelector(`.${type}-card`);
    card.dataset.entryId = cardId;

    if (type === 'education') {
        // Set values if provided
        if (options.degree) card.querySelector('[name="degree_level"]').value = options.degree;
        if (options.field) card.querySelector('[name="study_field"]').value = options.field;
        if (options.institution) card.querySelector('[name="institution"]').value = options.institution;
        if (options.startYear) card.querySelector('[name="start_year"]').value = options.startYear;
        if (options.endYear) card.querySelector('[name="end_year"]').value = options.endYear;
        if (options.description) card.querySelector('[name="description"]').value = options.description;

    } else if (type === 'certification') {
        // Set values if provided
        if (options.name) card.querySelector('[name="cert_name"]').value = options.name;
        if (options.org) card.querySelector('[name="cert_org"]').value = options.org;
        if (options.year) card.querySelector('[name="cert_year"]').value = options.year;
    }

    // Initialize select
    initSelectForCard(card);

    // Setup file input and remove button
    setupFileInput(type, card, cardId);
    setupRemoveButton(type, card, cardId);

    return card;
}

function addExistingCard(type, data) {
    let card;
    const template = type === 'education' ? educationTemplate : certificationTemplate;
    if (type === 'education') {
        card = createCard(type, template, data.id, {
            degree: data.degree,
            field: data.field,
            institution: data.institution,
            startYear: data.start_year,
            endYear: data.end_year,
            description: data.description
        });
        if (!card) return;

        educationContainer.appendChild(card);

    } else if (type === 'certification') {
        card = createCard(type, template, data.id, {
            name: data.name,
            org: data.organization,
            year: data.completion_year
        });
        if (!card) return;
        certificationContainer.appendChild(card);

    }

    // Display existing document if present
    // const documentInput = card.querySelector('[name="education_file"]');
    const documentInput = card.querySelector(`.input-${type}-file`);
    const documentLabel = card.querySelector(`.label-${type}-file`);

    const fileField = type === 'education' ? data.document : data.document;
    if (documentInput && documentLabel && fileField) {
        createExistingFileDisplay(type, documentInput, documentLabel, card);
        // updateTracker(`${type}Doc`, 'existed', data.id);
    }
}


// =======================
// FILE HANDLING
// =======================

function createExistingFileDisplay(type, inputElement, labelElement, card) {
    const container = inputElement.parentNode;
    const cardId = card.dataset.entryId;
    const removeFlagName = `${type}_remove_${cardId}`;

    // Remove any previous display
    container.querySelector('.file-display')?.remove();

    // Create display preview
    const displayDiv = document.createElement('div');
    displayDiv.className = 'd-flex align-items-center bg-light rounded  file-display';

    const icon = document.createElement('i');
    icon.className = 'bi bi-file-earmark-text-fill text-primary fs-5 me-2';

    const label = document.createElement('span');
    label.className = 'small';
    label.textContent = 'Document uploaded';

    const btnGroup = document.createElement('div');
    btnGroup.className = 'btn-group ms-auto';

    // Change button
    const changeBtn = document.createElement('button');
    changeBtn.type = 'button';
    changeBtn.className = 'btn btn-sm btn-outline-primary';
    changeBtn.innerHTML = '<i class="bi bi-pencil-fill"></i>';
    changeBtn.setAttribute('data-bs-toggle', 'tooltip');
    changeBtn.setAttribute('title', 'Change file');

    changeBtn.onclick = () => {
        // Track removal of current file before picking new one
        // updateTracker(`${type}Doc`, 'removed', cardId);

        // Trigger file input
        inputElement.click();

        // Handle change
        inputElement.onchange = () => {
            if (!inputElement.files.length) return;
            displayDiv.remove();
            handleFileUploadForCard(type, inputElement, labelElement, card);
            updateTracker(`${type}Doc`, 'changed', cardId);
        };
    };

    // Remove button
    const removeBtn = document.createElement('button');
    removeBtn.type = 'button';
    removeBtn.className = 'btn btn-sm btn-outline-danger';
    removeBtn.innerHTML = '<i class="bi bi-trash-fill"></i>';
    removeBtn.setAttribute('data-bs-toggle', 'tooltip');
    removeBtn.setAttribute('title', 'Remove file');

    removeBtn.onclick = () => {
        // Add hidden flag for backend
        const removeFlag = document.createElement('input');
        removeFlag.type = 'hidden';
        removeFlag.name = removeFlagName;
        removeFlag.value = 'true';
        card.appendChild(removeFlag);

        updateTracker(`${type}Doc`, 'removed', cardId);

        // Show input and label again
        displayDiv.remove();
        inputElement.style.display = 'block';
        inputElement.value = '';
        labelElement.style.display = 'block';
    };

    btnGroup.appendChild(changeBtn);
    btnGroup.appendChild(removeBtn);

    displayDiv.appendChild(icon);
    displayDiv.appendChild(label);
    displayDiv.appendChild(btnGroup);

    // Insert preview, hide inputs
    container.insertBefore(displayDiv, inputElement);
    inputElement.style.display = 'none';
    labelElement.style.display = 'none';

    initTooltips();
    return displayDiv;
}

function handleFileUploadForCard(type, fileInput, fileLabel, card) {
    if (!fileInput.files || fileInput.files.length === 0) return;

    const file = fileInput.files[0];
    const fileName = file.name;
    const container = fileInput.parentNode;
    const cardId = card.dataset.entryId;
    // const isExisting = trackers[type].existed.includes(cardId);
    //
    // // Update tracking based on whether this is an existing card
    // if (isExisting) {
    //     updateTracker(`${type}Doc`, 'changed', cardId);
    // } else {
    //     updateTracker(`${type}Doc`, 'uploaded', cardId);
    // }
    // Determine action based on whether this was an existing entry
    const action = trackers[`${type}Doc`].existed.includes(cardId) ? 'changed' : 'uploaded';

    updateTracker(`${type}Doc`, action, cardId);


    // Remove old preview
    container.querySelector('.file-display')?.remove();

    // Create new display
    const displayDiv = document.createElement('div');
    displayDiv.className = 'd-flex align-items-center bg-light rounded file-display';

    const icon = document.createElement('i');
    icon.className = 'bi bi-file-earmark-text-fill text-success fs-5 me-2';

    const nameSpan = document.createElement('span');
    nameSpan.className = 'small text-truncate me-3';
    nameSpan.style.maxWidth = '150px';
    nameSpan.textContent = fileName;

    const removeBtn = document.createElement('button');
    removeBtn.type = 'button';
    removeBtn.className = 'btn btn-sm btn-outline-danger ms-auto';
    removeBtn.innerHTML = '<i class="bi bi-trash-fill"></i>';
    removeBtn.setAttribute('data-bs-toggle', 'tooltip');
    removeBtn.setAttribute('title', 'Remove file');

    removeBtn.onclick = () => {
        displayDiv.remove();
        fileInput.style.display = 'none';
        fileInput.value = '';
        fileLabel.style.display = 'block';

        // Update tracker
        if (action === 'uploaded') {
            trackers[`${type}Doc`].uploaded = trackers[`${type}Doc`].uploaded.filter(id => id !== cardId);
        } else {
            updateTracker(`${type}Doc`, 'removed', cardId);
        }
    };

    displayDiv.appendChild(icon);
    displayDiv.appendChild(nameSpan);
    displayDiv.appendChild(removeBtn);

    fileLabel.style.display = 'none';
    fileInput.style.display = 'none';
    container.insertBefore(displayDiv, fileInput.nextSibling);

    initTooltips();
}

// ============================
// SUPPORTING FUNCTIONS
// ============================

function setupFileInput(type, card, cardId) {
    const input = card.querySelector(`.input-${type}-file`);
    const label = card.querySelector(`.label-${type}-file`);

    if (input && label) {
        // Use consistent naming pattern
        input.name = `${type}_doc_${cardId}`;
        label.addEventListener('click', () => input.click());
        input.addEventListener('change', () => {
            handleFileUploadForCard(type, input, label, card);
        });
    }
}


/**
 * Sets up the remove button for a skill card
 * @param {String} type - The card types (education, certification)
 * @param {HTMLElement} card - The card element
 * @param {string} cardId - The card's unique ID
 */
function setupRemoveButton(type, card, cardId) {
    const removeBtn = card.querySelector('.remove-entry');
    if (!removeBtn) return;

    // removeBtn.addEventListener('click', function () {
    //     // if (!confirm(`Are you sure you want to remove this ${type} entry?`)) return;
    //     if (!confirm(`Are you sure you want to remove this ${type} entry?`)) return;
    //
    //     //-----------------------------------------------
    //
    //
    //
    //     // Track removal
    //     if (trackers[type].existed.includes(cardId)) {
    //         // For existing cards
    //         updateTracker(type, 'removed', cardId);
    //
    //         // Check if card had a document (either existed or was uploaded/changed)
    //         const hadDocument =
    //             trackers[`${type}Doc`].existed.includes(cardId) ||
    //             trackers[`${type}Doc`].uploaded.includes(cardId) ||
    //             trackers[`${type}Doc`].changed.includes(cardId);
    //
    //         if (hadDocument) {
    //             updateTracker(`${type}Doc`, 'removed', cardId);
    //         }
    //     } else {
    //         // For new cards
    //         trackers[type].new = trackers[type].new.filter(id => id !== cardId);
    //         trackers[`${type}Doc`].uploaded = trackers[`${type}Doc`].uploaded.filter(id => id !== cardId);
    //     }
    //
    //     card.remove();
    //     checkCardLimit(type);
    // });

    removeBtn.addEventListener('click', async function () {
        try {
            // Use await with showConfirm
            const isConfirmed = await showConfirm(`Are you sure you want to remove this ${type} entry?`, {
                type: 'danger',
                confirmText: 'Yes, remove',
                cancelText: 'Keep it'
            });

            if (!isConfirmed) return;

            //-----------------------------------------------
            // Only execute removal if user confirmed

            // Track removal
            if (trackers[type].existed.includes(cardId)) {
                // For existing cards
                updateTracker(type, 'removed', cardId);

                // Check if card had a document (either existed or was uploaded/changed)
                const hadDocument =
                    trackers[`${type}Doc`].existed.includes(cardId) ||
                    trackers[`${type}Doc`].uploaded.includes(cardId) ||
                    trackers[`${type}Doc`].changed.includes(cardId);

                if (hadDocument) {
                    updateTracker(`${type}Doc`, 'removed', cardId);
                }
            } else {
                // For new cards
                trackers[type].new = trackers[type].new.filter(id => id !== cardId);
                trackers[`${type}Doc`].uploaded = trackers[`${type}Doc`].uploaded.filter(id => id !== cardId);
            }

            card.remove();
            checkCardLimit(type);
        } catch (error) {
            console.error('Error in removal process:', error);
        }
    });


}


function initSelectForCard(card) {
    if (typeof Choices !== 'undefined') {
        card.querySelectorAll('.js-choice:not([data-choicejs])').forEach(select => {
            try {
                new Choices(select, {
                    searchEnabled: true,
                    removeItemButton: true,
                    shouldSort: false,
                    classNames: {
                        containerInner: 'choices__inner bg-transparent',
                        listDropdown: 'choices__list--dropdown',
                        item: 'choices__item',
                        placeholder: 'choices__placeholder'
                    }
                });
                select.setAttribute('data-choicejs', 'true');
            } catch (e) {
                console.error('Choices.js initialization failed:', e);
            }
        });
    }
}

function validateFileType(file, allowedExtensions) {
    if (!file || !file.name) return false;
    const extension = file.name.split('.').pop().toLowerCase();
    return allowedExtensions.includes(extension);
}

function updateTracker(type, action, id, logger = false) {
    // First remove the ID from any other actions in the same type
    Object.keys(trackers[type]).forEach(key => {
        if (key !== action) {
            trackers[type][key] = trackers[type][key].filter(item => item !== id);
        }
    });

    // Then add to the specified action if not already present
    if (!trackers[type][action].includes(id)) {
        trackers[type][action].push(id);
    }

    if (logger) console.log(`${type} - ${action}: `, trackers[type][action]);
}

async function loadExistingData() {
    try {
        const response = await fetch(`/tutor/get-education-data/?applicantUId=${applicantUId}`);
        if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`);

        const data = await response.json();
        if (data.status !== 'success') throw new Error(data.message || 'Failed to load data');


        // Clear containers
        educationContainer.innerHTML = '';
        certificationContainer.innerHTML = '';

        // Process education data
        if (data.education && Array.isArray(data.education)) {
            data.education.forEach(edu => {
                addExistingCard('education', {
                    id: edu.id,
                    degree: edu.degree,
                    field: edu.field,
                    institution: edu.institution,
                    start_year: edu.start_year,
                    end_year: edu.end_year,
                    description: edu.description,
                    document: edu.document
                });
                updateTracker('education', 'existed', edu.id);
                if (edu.document) {
                    updateTracker('educationDoc', 'existed', edu.id);
                }
            });
        }
        // if (data.education.length === 0) {
        //     addBlankCard('education');
        // }

        // Process certification data
        if (data.certifications && Array.isArray(data.certifications)) {
            data.certifications.forEach(cert => {
                addExistingCard('certification', {
                    id: cert.id,
                    name: cert.name,
                    organization: cert.organization,
                    completion_year: cert.completion_year,
                    document: cert.document
                });
                updateTracker('certification', 'existed', cert.id);
                if (cert.document) {
                    updateTracker('certificationDoc', 'existed', cert.id);
                }
            });
        }
        // if (data.certifications.length === 0) {
        //     addBlankCard('certification');
        // }

    } catch (error) {
        console.error('Error loading education data:', error);
        showAlert('Failed to load education data. Please refresh the page.', 'error');
    }
}

function initTooltips() {
    if (typeof bootstrap !== 'undefined') {
        document.querySelectorAll('[data-bs-toggle="tooltip"]').forEach(el => {
            const tooltipInstance = bootstrap.Tooltip.getInstance(el);
            if (tooltipInstance) tooltipInstance.dispose();
            new bootstrap.Tooltip(el);
        });
    }
}


// ============================
// INITIALIZATION
// ============================
document.addEventListener('DOMContentLoaded', function () {
    // EVENT LISTENERS
    document.getElementById('btnAddEducation')?.addEventListener('click', () => addBlankCard('education'));
    document.getElementById('btnAddCertification')?.addEventListener('click', () => addBlankCard('certification'));

    try {
        loadExistingData();
        initSelects();
        initTooltips();
    } catch (e) {
        console.error('Initialization error:', e);
    }
});


//-------------------------------------------------------------
/**
 * Checks if entry limit has been reached for a specific type
 * @param {string} type - The type of entry ('skill', 'education', 'certification')
 * @param {number} maxLimit - Maximum allowed entries for this type
 * @returns {boolean} - True if limit reached, false otherwise
 */
function checkCardLimit(type, maxLimit = maxEntries) {
    // Get elements based on type
    const config = {
        // skill: {
        //     container: '#skills-container',
        //     cardClass: '.skill-card',
        //     addButton: '#btnAddSkill',
        //     alertMessage: '#skillLimitAlert'
        // },
        education: {
            container: '#education-container',
            cardClass: '.education-card',
            addButton: '#btnAddEducation',
            alertMessage: '#educationLimitAlert'
        },
        certification: {
            container: '#certification-container',
            cardClass: '.certification-card',
            addButton: '#btnAddCertification',
            alertMessage: '#certificationLimitAlert'
        }
    };

    const {container, cardClass, addButton, alertMessage} = config[type] || {};

    if (!container || !cardClass || !addButton) {
        console.error(`Missing configuration for type: ${type}`);
        return true; // Default to limit reached if config is missing
    }

    const containerEl = document.querySelector(container);
    const alertEl = document.querySelector(alertMessage);
    const addButtonEl = document.querySelector(addButton);

    if (!containerEl || !addButtonEl) {
        console.error(`Missing elements for type: ${type}`);
        return true;
    }

    const currentCount = containerEl.querySelectorAll(cardClass).length;
    const limitReached = currentCount >= maxLimit;

    // Update UI based on limit status
    if (alertEl) {
        alertEl.classList.toggle('d-none', !limitReached);
    }

    addButtonEl.disabled = limitReached;

    if (limitReached) {
        showAlert(`Maximum ${maxLimit} ${type}s allowed`, 'error');
    }

    return limitReached;
}


//====================== ARCHIVED =======================
export async function submit_education_MAIN() {
    if (!validate_education()) {
        showAlert('Please correct the errors in the form before submitting.', 'error');
        return {success: false, error: 'Validation failed'};
    }

    const formData = new FormData();
    let submitTimeout;

    try {
        // Set timeout
        const timeoutPromise = new Promise((_, reject) => {
            submitTimeout = setTimeout(() => reject(new Error('Request timed out')), 15000);
        });

        formData.append('years_experience', document.querySelector('#id_years_experience').value);
        // For teaching_tags (assuming it's a multi-select or similar):
        const selectedTags = Array.from(document.querySelectorAll('#id_teaching_tags option:checked'))
            .map(opt => opt.value);
        formData.append('teaching_tags', JSON.stringify(selectedTags));

        // Add tracking data
        formData.append('education_new', JSON.stringify(trackers.education.new));
        formData.append('education_removed', JSON.stringify(trackers.education.removed));

        formData.append('education_doc_uploaded', JSON.stringify(trackers.educationDoc.uploaded));
        formData.append('education_doc_changed', JSON.stringify(trackers.educationDoc.changed));
        formData.append('education_doc_removed', JSON.stringify(trackers.educationDoc.removed));

        formData.append('certification_new', JSON.stringify(trackers.certification.new));
        formData.append('certification_removed', JSON.stringify(trackers.certification.removed));

        formData.append('certification_doc_uploaded', JSON.stringify(trackers.certificationDoc.uploaded));
        formData.append('certification_doc_changed', JSON.stringify(trackers.certificationDoc.changed));
        formData.append('certification_doc_removed', JSON.stringify(trackers.certificationDoc.removed));

        // Process education cards
        const educationCards = educationContainer.querySelectorAll('.education-card');
        educationCards.forEach(card => {
            const cardId = card.dataset.entryId;

            formData.append(`education_ids[]`, cardId);
            formData.append(`degrees[]`, card.querySelector('[name="degree_level"]').value);
            formData.append(`fields[]`, card.querySelector('[name="study_field"]').value);
            formData.append(`institutions[]`, card.querySelector('[name="institution"]').value);
            formData.append(`start_years[]`, card.querySelector('[name="start_year"]').value);
            formData.append(`end_years[]`, card.querySelector('[name="end_year"]').value);
            formData.append(`descriptions[]`, card.querySelector('[name="description"]').value || '');

            const documentInput = card.querySelector(`[name="education_doc_${cardId}"]`);
            if (documentInput?.files[0]) {
                formData.append(`education_doc_${cardId}`, documentInput.files[0]);
            }
            const removeFlag = card.querySelector(`[name="education_remove_${cardId}"]`);
            if (removeFlag) formData.append(removeFlag.name, removeFlag.value);


        });

        // Process certification cards
        const certificationCards = certificationContainer.querySelectorAll('.certification-card');
        certificationCards.forEach(card => {
            const cardId = card.dataset.entryId;

            formData.append(`certification_ids[]`, cardId);
            formData.append(`cert_names[]`, card.querySelector('[name="cert_name"]').value);
            formData.append(`cert_orgs[]`, card.querySelector('[name="cert_org"]').value);
            formData.append(`cert_years[]`, card.querySelector('[name="cert_year"]').value);

            const documentInput = card.querySelector(`[name="certification_doc_${cardId}"]`);
            if (documentInput?.files[0]) {
                formData.append(`certification_doc_${cardId}`, documentInput.files[0]);
            }

            const removeFlag = card.querySelector(`[name="certification_remove_${cardId}"]`);
            if (removeFlag) formData.append(removeFlag.name, removeFlag.value);
        });

        //DEBUGGING -----------------------------------------
        // for (let [key, value] of formData.entries()) {
        //     console.log(key, value);
        // }

        // Add CSRF token
        const csrfToken = document.querySelector('[name="csrfmiddlewaretoken"]')?.value;

        if (csrfToken) formData.append('csrfmiddlewaretoken', csrfToken);

        const response = await Promise.race([
            fetch('/tutor/save-educations/', {
                method: 'POST',
                body: formData,
                headers: {'X-Requested-With': 'XMLHttpRequest'}
            }),
            timeoutPromise
        ]);

        clearTimeout(submitTimeout);

        if (!response.ok) {
            let errorData;
            try {
                errorData = await response.json();
            } catch {
                errorData = {error: 'Invalid server response'};
            }
            throw new Error(errorData.error || 'Failed to save education data');
        }

        const result = await response.json();
        if (result.success) {
            if (result.warnings?.length) {
                result.warnings.forEach(warning => showAlert(warning, 'warning'));
            }
            showAlert('Education and certification data saved successfully!', 'success');
            resetTrackers();
            await loadExistingData();
            // window.scrollTo({top: 0, behavior: 'smooth'});
        }

        return result;
    } catch (error) {
        clearTimeout(submitTimeout);
        console.error("Submission error:", error);
        showAlert(error.message || 'Failed to save education data. Please try again.', 'error');
        return {success: false, error: error.message || 'Failed to save education data'};
    }
}
