import {showAlert, showConfirm, modalManager  } from './utils.js';

const maxEntries = parseInt(document.getElementById('maxEntries').value);

// =============================================
// GLOBAL VARIABLES
// =============================================
const template = document.getElementById('skill-card-template');
const applicantUId = parseInt(document.getElementById('applicantUId').value);
const skillContainer = document.getElementById('skills-container');
const btnAddSkill = document.getElementById('btnAddSkill');

// const maxSkills = document.getElementById('isVIP').value.toLowerCase() === 'true' ? 5 : 3; // Set max skills limit based on VIP status
const validVideoTypes = ['mp4'];
const validCertificateTypes = ['pdf', 'doc', 'docx', 'png', 'jpg', 'jpeg'];
const validThumbnailTypes = ['png', 'jpg', 'jpeg'];
//============================== UPLOAD PROGRESS =====================================
// Progress tracking variables
// const uploadProgressModal = new bootstrap.Modal(document.getElementById('uploadProgressModal'));
// const progressBar = document.getElementById('uploadProgressBar');
// const progressText = document.getElementById('uploadProgressText');
// const cancelUploadBtn = document.getElementById('cancelUploadBtn');
// let uploadController = null;
//===================================================================
// ====== STATE ======
// let hasExistingIntroVideo = false;
let errSkills = [];
let errLevels = [];
let errVideos = [];
let errDuplicates = [];

// ===== FILE STATE TRACKING =====--------------------------------------------------
const trackers = {
    video: {
        existed: [],   // Skills that had videos when loaded
        uploaded: [],   // Brand new video uploads
        changed: [],    // Videos that replaced existing ones
        removed: []     // Videos that were removed
    },
    certificate: {
        existed: [],
        uploaded: [],
        changed: [],
        removed: []
    },
    thumbnail: {
        existed: [],
        uploaded: [],
        changed: [],
        removed: []
    },
    skills: {
        new: [],       // Track completely new skills,
        existed: [],
        removed: []
    },
};


/**
 * Shows all existing skills from the server
 */
async function loadExistingSkills() {
    if (!applicantUId) {
        console.error('No applicantUId found!');
        return;
    }

    const url = `/tutor/get-existed-skills/?applicantUId=${applicantUId}`;
    try {
        const response = await fetch(url);
        if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`);

        const data = await response.json();
        // Process intro video
        // handleVideoIntro(data.video_intro);

        // Clear container safely
        while (skillContainer.firstChild) {
            skillContainer.removeChild(skillContainer.firstChild);
        }

        // handleVideoIntro(data.video_intro);

        // Process skills
        if (data.existed_uSkill_list && Array.isArray(data.existed_uSkill_list)) {
            data.existed_uSkill_list.forEach(uSkill => {
                if (uSkill) updateTracker('skills', 'existed', uSkill.uSkillId);
                if (uSkill.video) updateTracker('video', 'existed', uSkill.uSkillId);
                if (uSkill.certificate) updateTracker('certificate', 'existed', uSkill.uSkillId);
                if (uSkill.thumbnail) updateTracker('thumbnail', 'existed', uSkill.uSkillId);
                addExistedSkillCard(
                    uSkill.uSkillId,
                    uSkill.skill,
                    uSkill.level,
                    uSkill.video,
                    uSkill.certificate,
                    uSkill.thumbnail,
                );
            });
            // console.log('Videos-existed: ', trackers.video.existed);
            // console.log('Certificates-existed: ', trackers.certificate.existed);
            // console.log('Thumbnail-existed: ', trackers.thumbnail.existed);

        } else {
            console.error('Invalid data format:', data);
        }
        if (data.existed_uSkill_list.length === 0) {
            addBlankSkillCard();
        }
    } catch (error) {
        console.error('Error fetching skills:', error);
    }
}

// ====================== EXPORTED FUNCTIONS ======================
// Client-side Step2 Validation

//=================================================================
export function validate_skills() {
    const container = document.getElementById('skills-container');
    const cards = container.querySelectorAll('.skill-card');
    let isValid = true;

    // Reset error tracking
    errSkills = [];
    errLevels = [];
    errVideos = [];
    errDuplicates = [];

    // Validate maximum entries first
    if (cards.length > maxEntries) {
        showAlert(`You can add up to ${maxEntries} skills only.`, 'error');
        return false;
    }

    if (cards.length == 0) {
        showAlert(`Please add at least one skill to proceed.`, 'error');
        return false;
    }

    // First pass: Collect skill IDs and track duplicates
    const skillCounts = new Map();
    cards.forEach(card => {
        const skillSelect = card.querySelector('[name^="skill"]');
        if (skillSelect?.value) {
            const count = skillCounts.get(skillSelect.value) || 0;
            skillCounts.set(skillSelect.value, count + 1);
        }
    });

    // Second pass: Validate each card
    cards.forEach((card, index) => {
        const cardId = card.dataset.cardId;
        const skillSelect = card.querySelector('[name^="skill"]');
        const levelSelect = card.querySelector('[name^="level"]');
        const videoInput = card.querySelector('[name^="skill_video"]');
        const certificateInput = card.querySelector('[name^="certificate"]');
        const thumbnailInput = card.querySelector('[name^="thumbnail"]');

        const cardNumber = index + 1;
        const skillName = skillSelect?.options[skillSelect.selectedIndex]?.text || 'Skill';

        // Clear previous error indicators
        clearFieldErrors(card);
        let cardIsValid = true;

        // 1. Validate Skill (required)
        if (!skillSelect?.value) {
            markFieldInvalid(skillSelect, 'Please select a skill');
            errSkills.push(`Row ${cardNumber}`);
            cardIsValid = false;
        }
        // 2. Check for duplicate skills
        else if (skillCounts.get(skillSelect.value) > 1) {
            markFieldInvalid(skillSelect, 'This skill is already selected');
            errDuplicates.push(`Row ${cardNumber} (${skillName})`);
            cardIsValid = false;
        }

        // 3. Validate Level (required)
        if (!levelSelect?.value) {
            markFieldInvalid(levelSelect, 'Please select a proficiency level');
            errLevels.push(`Row ${cardNumber} (${skillName})`);
            cardIsValid = false;
        }

        // 4. Validate Video (required) - Simplified logic
        const cardIdNum = Number(cardId);
        // const hasExistingVideo = trackers.video.existed.includes(cardIdNum);
        // const hasNewVideo = trackers.video.uploaded.includes(cardIdNum);
        // const videoWasRemoved = trackers.video.removed.includes(cardIdNum);
        const hasExistingVideo = trackers.video.existed.some(id => Number(id) === Number(cardId));
        const hasNewVideo = trackers.video.uploaded.some(id => Number(id) === Number(cardId));
        const videoWasRemoved = trackers.video.removed.some(id => Number(id) === Number(cardId));

        // Case 1: Video existed and wasn't changed
        if (hasExistingVideo && !videoWasRemoved && !hasNewVideo) {
            // Valid - no action needed
        }
        // Case 2: Video was removed without replacement
        else if (videoWasRemoved && !hasNewVideo) {
            markFieldInvalid(videoInput, 'Please upload a demonstration video');
            errVideos.push(`Row ${cardNumber} (${skillName})`);
            cardIsValid = false;
        }
        // Case 3: New video uploaded (either replacement or new upload)
        else if (hasNewVideo) {
            const file = videoInput.files[0];
            const videoValidation = validateFile(file, {
                allowedTypes: validVideoTypes,
                maxSize: 50 * 1024 * 1024 // 50MB
            });

            if (!videoValidation.valid) {
                markFieldInvalid(videoInput, videoValidation.message);
                showAlert(`Unable to process video for "${skillName}": ${videoValidation.message}.`, 'error');
                cardIsValid = false;
            }
        }
        // Case 4: No video at all (new card without upload)
        else {
            markFieldInvalid(videoInput, 'Please upload a demonstration video');
            errVideos.push(`Row ${cardNumber} (${skillName})`);
            cardIsValid = false;
        }

        // 4. Validate Certificate (optional)
        if (certificateInput?.files?.[0]) {
            const file = certificateInput.files[0];
            const certValidation = validateFile(file, {
                allowedTypes: validCertificateTypes,
                maxSize: 10 * 1024 * 1024 // 10MB
            });

            if (!certValidation.valid) {
                markFieldInvalid(certificateInput, certValidation.message);
                showAlert(`Certificate issue detected for "${skillName}": ${certValidation.message}.`, 'error');
                cardIsValid = false;
            } else {
                const action = trackers.certificate.existed.includes(cardIdNum) ? 'changed' : 'uploaded';
                updateTracker('certificate', action, cardId);
            }
        }

        // 5. Validate Thumbnail (optional)
        if (thumbnailInput?.files?.[0]) {
            const file = thumbnailInput.files[0];
            const thumbValidation = validateFile(file, {
                allowedTypes: validThumbnailTypes,
                maxSize: 5 * 1024 * 1024 // 5MB
            });

            if (!thumbValidation.valid) {
                markFieldInvalid(thumbnailInput, thumbValidation.message);
                showAlert(`Thumbnail issue detected for "${skillName}": ${thumbValidation.message}.`, 'error');
                cardIsValid = false;
            } else {
                const action = trackers.thumbnail.existed.includes(cardIdNum) ? 'changed' : 'uploaded';
                updateTracker('thumbnail', action, cardId);
            }
        }

        if (!cardIsValid) {
            isValid = false;
            if (cards.length > 1 && index === 0) {
                card.scrollIntoView({behavior: 'smooth', block: 'center'});
            }
        }
    });

    // Display consolidated error messages
    if (errDuplicates.length > 0) {
        showAlert(`The following skills are duplicated: ${errDuplicates.join(', ')}.`, 'error');
    }
    if (errSkills.length > 0) {
        showAlert(`Please select a skill for: ${errSkills.join(', ')}.`, 'error');
    }
    if (errLevels.length > 0) {
        showAlert(`Please specify a proficiency level for: ${errLevels.join(', ')}.`, 'error');
    }
    if (errVideos.length > 0) {
        showAlert(`Please upload a demonstration video for: ${errVideos.join(', ')}.`, 'error');
    }

    return isValid;
}

// Helper function to mark fields as invalid
function markFieldInvalid(field, message) {
    if (!field) return;

    field.classList.add('is-invalid');

    const errorElement = document.createElement('div');
    errorElement.className = 'invalid-feedback';
    errorElement.textContent = message;

    field.closest('.form-group')?.appendChild(errorElement) ||
    field.parentNode?.appendChild(errorElement);
}

// Helper function to clear field errors
function clearFieldErrors(card) {
    card.querySelectorAll('.is-invalid').forEach(el => el.classList.remove('is-invalid'));
    card.querySelectorAll('.invalid-feedback').forEach(el => el.remove());
}

//===================================================================


export async function submit_skills11() {
    if (!validate_skills()) {
        return {success: false, error: 'Validation failed'};
    }

    const formData = new FormData();

    try {
        // Add tracking data
        formData.append('skills_removed', JSON.stringify(trackers.skills.removed));
        formData.append('skills_new', JSON.stringify(trackers.skills.new));
        formData.append('videos_new', JSON.stringify(trackers.video.uploaded));
        formData.append('videos_changed', JSON.stringify(trackers.video.changed));
        formData.append('videos_removed', JSON.stringify(trackers.video.removed));
        formData.append('certs_new', JSON.stringify(trackers.certificate.uploaded));
        formData.append('certs_changed', JSON.stringify(trackers.certificate.changed));
        formData.append('certs_removed', JSON.stringify(trackers.certificate.removed));
        formData.append('thumbs_new', JSON.stringify(trackers.thumbnail.uploaded));
        formData.append('thumbs_changed', JSON.stringify(trackers.thumbnail.changed));
        formData.append('thumbs_removed', JSON.stringify(trackers.thumbnail.removed));

        // Process skill cards
        const skillCards = document.querySelectorAll('.skill-card');
        skillCards.forEach(card => {
            const cardId = card.dataset.cardId;
            const isNewSkill = trackers.skills.new.includes(cardId);

            // Append skill data
            formData.append(`skill_ids[]`, cardId);
            formData.append(`skills[]`, card.querySelector('[name^="skill"]').value);
            formData.append(`levels[]`, card.querySelector('[name^="level"]').value);

            // Handle files
            const videoInput = card.querySelector(`[name="skill_video_${cardId}"]`);
            if (videoInput?.files[0]) {
                formData.append(`skill_video_${cardId}`, videoInput.files[0]);
            }

            const certInput = card.querySelector(`[name="certificate_${cardId}"]`);
            if (certInput?.files[0]) {
                formData.append(`certificate_${cardId}`, certInput.files[0]);
            }

            const thumbInput = card.querySelector(`[name="thumbnail_${cardId}"]`);
            if (thumbInput?.files[0]) {
                formData.append(`thumbnail_${cardId}`, thumbInput.files[0]);
            }

            // Handle remove flags for existing skills
            if (!isNewSkill) {
                const removeFlag = card.querySelector(`[name="remove_skill_${cardId}"]`);
                if (removeFlag) formData.append(removeFlag.name, removeFlag.value);
            }
        });

        // Add CSRF token
        const csrfToken = document.querySelector('[name="csrfmiddlewaretoken"]')?.value;
        if (csrfToken) formData.append('csrfmiddlewaretoken', csrfToken);

        // Initialize XHR
        const xhr = new XMLHttpRequest();
        xhr.open('POST', '/tutor/save-skills/', true);
        xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');

        // Show modal and reset progress
        uploadProgressModal.show();
        progressBar.style.width = '0%';
        progressText.textContent = 'Preparing upload... 0%';

        // Set up cancel button
        cancelUploadBtn.onclick = () => {
            xhr.abort();
            uploadProgressModal.hide();
            showAlert('Upload cancelled.', 'info');
        };

        return new Promise((resolve, reject) => {
            // Progress tracking
            xhr.upload.onprogress = (event) => {
                if (event.lengthComputable) {
                    const percent = Math.round((event.loaded / event.total) * 100);
                    progressBar.style.width = `${percent}%`;
                    progressBar.setAttribute('aria-valuenow', percent); // Accessibility
                    progressText.textContent = `Uploading: ${percent}% complete (${formatFileSize(event.loaded)} / ${formatFileSize(event.total)})`;
                }
            };

            // Completion
            xhr.onload = () => {
                uploadProgressModal.hide();
                if (xhr.status >= 200 && xhr.status < 300) {
                    try {
                        const result = JSON.parse(xhr.responseText);
                        if (result.success) {
                            // Update skill IDs in the DOM
                            if (result.skill_mapping) {
                                Object.entries(result.skill_mapping).forEach(([frontendId, backendId]) => {
                                    const card = document.querySelector(`.skill-card[data-card-id="${frontendId}"]`);
                                    if (card) {
                                        card.dataset.cardId = backendId;
                                        // Update all input names
                                        ['skill_video', 'certificate', 'thumbnail'].forEach(prefix => {
                                            const input = card.querySelector(`[name^="${prefix}"]`);
                                            if (input) {
                                                input.name = input.name.replace(
                                                    `${prefix}_${frontendId}`,
                                                    `${prefix}_${backendId}`
                                                );
                                            }
                                        });
                                    }
                                });
                            }

                            console.log('Im here! #1');
                            uploadProgressModal.hide();
                            console.log('Im here! #2');
                            // Reset trackers and reload skills
                            resetTrackers();
                            loadExistingSkills(); // Reload to sync with backend
                            // showAlert('Skills data saved successfully!', 'success');
                            resolve(result);
                        } else {
                            showAlert(result.error || 'Failed to save skills data.', 'error');
                            reject(new Error(result.error || 'Failed to save skills data'));
                        }
                    } catch (e) {
                        showAlert('Invalid server response.', 'error');
                        reject(new Error('Invalid server response'));
                    }
                } else {
                    showAlert('Failed to save skills data.', 'error');
                    reject(new Error(`HTTP error: ${xhr.status}`));
                }
            };

            // Error handling
            xhr.onerror = () => {
                uploadProgressModal.hide();
                showAlert('Network error during upload.', 'error');
                reject(new Error('Network error'));
            };

            xhr.onabort = () => {
                uploadProgressModal.hide();
                showAlert('Upload cancelled.', 'info');
                reject(new Error('Upload aborted'));
            };

            // Timeout
            xhr.timeout = 15000;
            xhr.ontimeout = () => {
                uploadProgressModal.hide();
                showAlert('Request timed out.', 'error');
                reject(new Error('Timeout'));
            };

            xhr.send(formData);
        });
    } catch (error) {
        uploadProgressModal.hide();
        console.error('Submission error:', error);
        showAlert(error.message || 'Failed to save skills data. Please try again.', 'error');
        return {success: false, error: error.message || 'Failed to save skills data'};
    }
}
export async function submit_skills_good() {
    if (!validate_skills()) {
        return {success: false, error: 'Validation failed'};
    }

    const formData = new FormData();

    try {
        // Add tracking data
        formData.append('skills_removed', JSON.stringify(trackers.skills.removed));
        formData.append('skills_new', JSON.stringify(trackers.skills.new));
        formData.append('videos_new', JSON.stringify(trackers.video.uploaded));
        formData.append('videos_changed', JSON.stringify(trackers.video.changed));
        formData.append('videos_removed', JSON.stringify(trackers.video.removed));
        formData.append('certs_new', JSON.stringify(trackers.certificate.uploaded));
        formData.append('certs_changed', JSON.stringify(trackers.certificate.changed));
        formData.append('certs_removed', JSON.stringify(trackers.certificate.removed));
        formData.append('thumbs_new', JSON.stringify(trackers.thumbnail.uploaded));
        formData.append('thumbs_changed', JSON.stringify(trackers.thumbnail.changed));
        formData.append('thumbs_removed', JSON.stringify(trackers.thumbnail.removed));

        // Process skill cards
        const skillCards = document.querySelectorAll('.skill-card');
        skillCards.forEach(card => {
            const cardId = card.dataset.cardId;
            const isNewSkill = trackers.skills.new.includes(cardId);

            // Append skill data
            formData.append(`skill_ids[]`, cardId);
            formData.append(`skills[]`, card.querySelector('[name^="skill"]').value);
            formData.append(`levels[]`, card.querySelector('[name^="level"]').value);

            // Handle files
            const videoInput = card.querySelector(`[name="skill_video_${cardId}"]`);
            if (videoInput?.files[0]) {
                formData.append(`skill_video_${cardId}`, videoInput.files[0]);
            }

            const certInput = card.querySelector(`[name="certificate_${cardId}"]`);
            if (certInput?.files[0]) {
                formData.append(`certificate_${cardId}`, certInput.files[0]);
            }

            const thumbInput = card.querySelector(`[name="thumbnail_${cardId}"]`);
            if (thumbInput?.files[0]) {
                formData.append(`thumbnail_${cardId}`, thumbInput.files[0]);
            }

            // Handle remove flags for existing skills
            if (!isNewSkill) {
                const removeFlag = card.querySelector(`[name="remove_skill_${cardId}"]`);
                if (removeFlag) formData.append(removeFlag.name, removeFlag.value);
            }
        });

        // Add CSRF token
        const csrfToken = document.querySelector('[name="csrfmiddlewaretoken"]')?.value;
        if (csrfToken) formData.append('csrfmiddlewaretoken', csrfToken);

        // Initialize XHR
        const xhr = new XMLHttpRequest();
        xhr.open('POST', '/tutor/save-skills/', true);
        xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');

        // Show modal and reset progress
        uploadProgressModal.show();
        progressBar.style.width = '0%';
        progressText.textContent = 'Preparing upload... 0%';

        // Set up cancel button
        cancelUploadBtn.onclick = () => {
            xhr.abort();
            uploadProgressModal.hide();
            showAlert('Upload cancelled.', 'info');
        };

        return new Promise((resolve, reject) => {
            // Progress tracking
            xhr.upload.onprogress = (event) => {
                if (event.lengthComputable) {
                    const percent = Math.round((event.loaded / event.total) * 100);
                    progressBar.style.width = `${percent}%`;
                    progressBar.setAttribute('aria-valuenow', percent); // Accessibility
                    progressText.textContent = `Uploading: ${percent}% complete (${formatFileSize(event.loaded)} / ${formatFileSize(event.total)})`;
                }
            };

            // Completion
            xhr.onload = async () => { // Make this callback async
                if (xhr.status >= 200 && xhr.status < 300) {
                    try {
                        const result = JSON.parse(xhr.responseText);
                        if (result.success) {
                            // Update skill IDs in the DOM
                            if (result.skill_mapping) {
                                Object.entries(result.skill_mapping).forEach(([frontendId, backendId]) => {
                                    const card = document.querySelector(`.skill-card[data-card-id="${frontendId}"]`);
                                    if (card) {
                                        card.dataset.cardId = backendId;
                                        // Update all input names
                                        ['skill_video', 'certificate', 'thumbnail'].forEach(prefix => {
                                            const input = card.querySelector(`[name^="${prefix}"]`);
                                            if (input) {
                                                input.name = input.name.replace(
                                                    `${prefix}_${frontendId}`,
                                                    `${prefix}_${backendId}`
                                                );
                                            }
                                        });
                                    }
                                });
                            }

                            // Reset trackers
                            resetTrackers();

                            // Wait for skills to load before hiding modal
                            try {
                                await loadExistingSkills(); // Wait for this to complete
                                uploadProgressModal.hide();
                                resolve(result);
                            } catch (loadError) {
                                uploadProgressModal.hide();
                                console.error('Error loading skills:', loadError);
                                showAlert('Skills saved but there was an issue refreshing the page.', 'warning');
                                resolve(result); // Still resolve since save was successful
                            }

                        } else {
                            uploadProgressModal.hide();
                            showAlert(result.error || 'Failed to save skills data.', 'error');
                            reject(new Error(result.error || 'Failed to save skills data'));
                        }
                    } catch (e) {
                        uploadProgressModal.hide();
                        showAlert('Invalid server response.', 'error');
                        reject(new Error('Invalid server response'));
                    }
                } else {
                    uploadProgressModal.hide();
                    showAlert('Failed to save skills data.', 'error');
                    reject(new Error(`HTTP error: ${xhr.status}`));
                }
            };

            // Error handling
            xhr.onerror = () => {
                uploadProgressModal.hide();
                showAlert('Network error during upload.', 'error');
                reject(new Error('Network error'));
            };

            xhr.onabort = () => {
                uploadProgressModal.hide();
                showAlert('Upload cancelled.', 'info');
                reject(new Error('Upload aborted'));
            };

            // Timeout
            xhr.timeout = 15000;
            xhr.ontimeout = () => {
                uploadProgressModal.hide();
                showAlert('Request timed out.', 'error');
                reject(new Error('Timeout'));
            };

            xhr.send(formData);
        });
    } catch (error) {
        uploadProgressModal.hide();
        console.error('Submission error:', error);
        showAlert(error.message || 'Failed to save skills data. Please try again.', 'error');
        return {success: false, error: error.message || 'Failed to save skills data'};
    }
}

export async function submit_skills() {
    if (!validate_skills()) {
        return {success: false, error: 'Validation failed'};
    }

    const formData = new FormData();

    try {
        // Add tracking data
        formData.append('skills_removed', JSON.stringify(trackers.skills.removed));
        formData.append('skills_new', JSON.stringify(trackers.skills.new));
        formData.append('videos_new', JSON.stringify(trackers.video.uploaded));
        formData.append('videos_changed', JSON.stringify(trackers.video.changed));
        formData.append('videos_removed', JSON.stringify(trackers.video.removed));
        formData.append('certs_new', JSON.stringify(trackers.certificate.uploaded));
        formData.append('certs_changed', JSON.stringify(trackers.certificate.changed));
        formData.append('certs_removed', JSON.stringify(trackers.certificate.removed));
        formData.append('thumbs_new', JSON.stringify(trackers.thumbnail.uploaded));
        formData.append('thumbs_changed', JSON.stringify(trackers.thumbnail.changed));
        formData.append('thumbs_removed', JSON.stringify(trackers.thumbnail.removed));

        // Process skill cards
        const skillCards = document.querySelectorAll('.skill-card');
        skillCards.forEach(card => {
            const cardId = card.dataset.cardId;
            const isNewSkill = trackers.skills.new.includes(Number(cardId));

            // Append skill data
            formData.append(`skill_ids[]`, cardId);
            formData.append(`skills[]`, card.querySelector('[name^="skill"]').value);
            formData.append(`levels[]`, card.querySelector('[name^="level"]').value);

            // Handle files
            const videoInput = card.querySelector(`[name="skill_video_${cardId}"]`);
            if (videoInput?.files[0]) {
                formData.append(`skill_video_${cardId}`, videoInput.files[0]);
            }

            const certInput = card.querySelector(`[name="certificate_${cardId}"]`);
            if (certInput?.files[0]) {
                formData.append(`certificate_${cardId}`, certInput.files[0]);
            }

            const thumbInput = card.querySelector(`[name="thumbnail_${cardId}"]`);
            if (thumbInput?.files[0]) {
                formData.append(`thumbnail_${cardId}`, thumbInput.files[0]);
            }

            // Handle remove flags for existing skills
            if (!isNewSkill) {
                const removeFlag = card.querySelector(`[name="remove_skill_${cardId}"]`);
                if (removeFlag) formData.append(removeFlag.name, removeFlag.value);
            }
        });

        // Add CSRF token
        const csrfToken = document.querySelector('[name="csrfmiddlewaretoken"]')?.value;
        if (csrfToken) formData.append('csrfmiddlewaretoken', csrfToken);

        // Initialize XHR
        const xhr = new XMLHttpRequest();
        xhr.open('POST', '/tutor/save-skills/', true);
        xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');

        // Show modal
        modalManager.show('Uploading Skills Data');

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
                            // Update skill IDs in the DOM
                            if (result.skill_mapping) {
                                Object.entries(result.skill_mapping).forEach(([frontendId, backendId]) => {
                                    const card = document.querySelector(`.skill-card[data-card-id="${frontendId}"]`);
                                    if (card) {
                                        card.dataset.cardId = backendId;
                                        ['skill_video', 'certificate', 'thumbnail'].forEach(prefix => {
                                            const input = card.querySelector(`[name^="${prefix}"]`);
                                            if (input) {
                                                input.name = input.name.replace(
                                                    `${prefix}_${frontendId}`,
                                                    `${prefix}_${backendId}`
                                                );
                                            }
                                        });
                                    }
                                });
                            }

                            // Reset trackers
                            resetTrackers();

                            // Mark success and wait a moment before hiding
                            modalManager.markSuccess('Upload completed! Finalizing...');

                            // Wait for skills to load
                            try {
                                await loadExistingSkills();
                                // Give a small delay for user to see success message
                                setTimeout(() => modalManager.hide(), 1000);
                                resolve(result);
                            } catch (loadError) {
                                console.error('Error loading skills:', loadError);
                                modalManager.hide();
                                showAlert('Skills saved but there was an issue refreshing the page.', 'warning');
                                resolve(result);
                            }

                        } else {
                            modalManager.markError(result.error || 'Failed to save skills data.');
                            setTimeout(() => modalManager.hide(), 2000);
                            showAlert(result.error || 'Failed to save skills data.', 'error');
                            reject(new Error(result.error || 'Failed to save skills data'));
                        }
                    } catch (e) {
                        modalManager.markError('Invalid server response.');
                        setTimeout(() => modalManager.hide(), 2000);
                        showAlert('Invalid server response.', 'error');
                        reject(new Error('Invalid server response'));
                    }
                } else {
                    modalManager.markError(`Server error: ${xhr.status}`);
                    setTimeout(() => modalManager.hide(), 2000);
                    showAlert('Failed to save skills data.', 'error');
                    reject(new Error(`HTTP error: ${xhr.status}`));
                }
            };

            // Error handling
            xhr.onerror = () => {
                modalManager.markError('Network error during upload.');
                setTimeout(() => modalManager.hide(), 2000);
                showAlert('Network error during upload.', 'error');
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
                setTimeout(() => modalManager.hide(), 2000);
                showAlert('Request timed out.', 'error');
                reject(new Error('Timeout'));
            };

            xhr.send(formData);
        });
    } catch (error) {
        modalManager.hide();
        console.error('Submission error:', error);
        showAlert(error.message || 'Failed to save skills data. Please try again.', 'error');
        return {success: false, error: error.message || 'Failed to save skills data'};
    }
}


// Add this function to handle modal dismissal more reliably
function forceModalHide() {
    const modalElement = document.getElementById('uploadProgressModal');
    if (modalElement) {
        // Remove backdrop
        const backdrops = document.querySelectorAll('.modal-backdrop');
        backdrops.forEach(backdrop => backdrop.remove());

        // Remove modal-open class from body
        document.body.classList.remove('modal-open');

        // Reset body style
        document.body.style = '';

        // Hide modal
        modalElement.style.display = 'none';
        modalElement.classList.remove('show');
    }
}
// Reset trackers after successful submission
function resetTrackers() {
    // existedSkills = [];

    // Reset file state trackers
    Object.keys(trackers).forEach(type => {
        Object.keys(trackers[type]).forEach(action => {
            trackers[type][action] = [];
        });
    });
}

// Call this after successful submission
// =============================================
// MAIN FUNCTIONS
// =============================================
function createExistingFileDisplay(type, inputElement, labelElement, card, isIntroVideo = false) {
    const container = inputElement.parentNode;
    const uSkillId = card.dataset.cardId;
    const removeFlagName = isIntroVideo
        ? 'remove_video_intro'
        : `${type === 'video' ? 'remove_skill_video_' : 'remove_certificate_'}${uSkillId}`;

    const displayClass = type === 'video' ? 'video-display' : 'cert-display';

    // Remove any previous display
    container.querySelector(`.${displayClass}`)?.remove();

    // --- Create display preview ---
    const displayDiv = document.createElement('div');
    displayDiv.className = `d-flex align-items-center bg-light rounded p-2 ${displayClass}`;

    const icon = document.createElement('i');
    icon.className = type === 'video'
        ? 'bi bi-file-earmark-play-fill text-primary fs-5 me-2'
        : 'bi bi-file-earmark-text-fill text-info fs-5 me-2';

    const label = document.createElement('span');
    label.className = 'small';
    // label.textContent = type === 'video' ? 'Video uploaded' : 'Certificate uploaded';
    if (type === 'video') {
        label.textContent = 'Video uploaded';
    } else if (type === 'certificate') {
        label.textContent = 'Certificate uploaded';
    } else if (type === 'thumbnail') {
        label.textContent = 'Thumbnail uploaded';
    }
    const btnGroup = document.createElement('div');
    btnGroup.className = 'btn-group ms-auto';

    // --- EDIT / CHANGE BUTTON ---
    const changeBtn = document.createElement('button');
    changeBtn.type = 'button';
    changeBtn.className = 'btn btn-sm btn-outline-primary';
    changeBtn.innerHTML = '<i class="bi bi-pencil-fill"></i>';
    changeBtn.setAttribute('data-bs-toggle', 'tooltip');
    changeBtn.setAttribute('title', 'Change file');

    changeBtn.onclick = () => {
        // Clear any previous file
        inputElement.value = '';

        // For existing skills, mark as changed
        const cardId = Number(card.dataset.cardId);
        if (trackers.skills.existed.includes(cardId)) {
            updateTracker(type, 'changed', cardId);
        }

        inputElement.click();
        inputElement.onchange = () => {
            if (!inputElement.files.length) return;
            displayDiv.remove();
            handleFileUploadForCard(type, inputElement, labelElement, card);
        };
    };


    // changeBtn.onclick = () => {
    //     // Track removal of the current file before user picks new one
    //
    //     // Trigger input click directly to show file picker
    //     inputElement.click();
    //
    //     // Handle change via input event
    //     inputElement.onchange = () => {
    //         if (!inputElement.files.length) return;
    //
    //         // Remove the old file display and process as new upload
    //         displayDiv.remove();
    //         updateTracker(type, 'changed', uSkillId);
    //         // UPDATE CODE!!!!!!!! ----------------------------------------
    //         let removeInputPrefix;
    //         if (type === 'video') {
    //             removeInputPrefix = 'remove_skill_video_';
    //         } else if (type === 'certificate') {
    //             removeInputPrefix = 'remove_certificate_';
    //         } else if (type === 'thumbnail') {
    //             removeInputPrefix = 'remove_thumbnail_';
    //         }
    //         // UPDATE CODE!!!!!!!! ----------------------------------------
    //
    //         handleFileUploadForCard(type, inputElement, labelElement, card, {
    //             uSkillId,
    //             // removeInputPrefix: type === 'video' ? 'remove_skill_video_' : 'remove_certificate_'
    //             removeInputPrefix
    //         });
    //     };
    // };

    // --- DELETE / REMOVE BUTTON ---
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

        updateTracker(type, 'removed', uSkillId);

        // Show input and label again
        displayDiv.remove();
        inputElement.style.display = 'block';
        inputElement.value = '';
        labelElement.style.display = 'block';
    };

    // Append buttons
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

// Add this to your skill select change handler
function onSkillSelectChange(selectElement, card) {
    const cardId = card.dataset.cardId;
    const selectedSkillId = selectElement.value;

    // Check for duplicates
    const allSkillSelects = document.querySelectorAll('.skill-card [name^="skill"]');
    let isDuplicate = false;

    allSkillSelects.forEach(otherSelect => {
        if (otherSelect !== selectElement &&
            otherSelect.value === selectedSkillId) {
            isDuplicate = true;
        }
    });

    if (isDuplicate) {
        markFieldInvalid(selectElement, 'This skill is already selected');
        // Optional: Reset the selection
        selectElement.value = '';
    } else {
        clearFieldErrors(card);
    }
}

// ===================================
// MAIN FUNCTIONS - REFACTORED (DRY)
// ===================================

/**
 * Creates a new skill card with common setup
 * @param {string} cardId - Unique ID for the card
 * @param {Object} options - Configuration options
 * @param {boolean} options.isExisting - Whether this is an existing skill
 * @param {string|null} options.skillId - Skill ID for existing cards
 * @param {string|null} options.levelId - Level ID for existing cards
 * @param {string|null} options.video - Video URL for existing cards
 * @param {string|null} options.certificate - Certificate URL for existing cards
 * @returns {HTMLElement|null} The created card element
 */
function createSkillCard_main(cardId, options = {}) {
    if (!template) {
        console.error('Template not found!');
        return null;
    }

    // Clone the template
    const newCard = template.content.cloneNode(true);
    const card = newCard.querySelector('.skill-card') || document.createElement('div');
    card.className = 'skill-card border rounded p-3 mb-3 bg-white shadow-sm';
    card.dataset.cardId = cardId;

    // Set skill and level values if provided
    if (options.skillId || options.levelId) {
        const skillSelect = card.querySelector('[name="skill"]');
        const levelSelect = card.querySelector('[name="level"]');
        if (skillSelect) skillSelect.value = options.skillId || '';
        if (levelSelect) levelSelect.value = options.levelId || '';
    }

    // Initialize Choices.js
    initSelectsForCard(card);

    // Track the skill
    if (options.isExisting) {
        // trackers.skills.existed.push(cardId);
        updateTracker('skills', 'existed', cardId);
    } else {
        // trackers.skills.new.push(cardId);
        updateTracker('skills', 'new', cardId);
    }

    return card;
}

function createSkillCard(cardId, options = {}) {
    console.log('createSkillCard called!!!');
    if (!template) {
        console.error('Template not found!');
        return null;
    }

    const newCard = template.content.cloneNode(true);
    const card = newCard.querySelector('.skill-card') || document.createElement('div');
    card.className = 'skill-card border rounded p-3 mb-3 bg-white shadow-sm';
    card.dataset.cardId = cardId;

    if (options.skillId || options.levelId) {
        const skillSelect = card.querySelector('[name="skill"]');
        const levelSelect = card.querySelector('[name="level"]');
        if (skillSelect) skillSelect.value = options.skillId || '';
        if (levelSelect) levelSelect.value = options.levelId || '';
    }

    initSelectsForCard(card);

    // Convert to number for tracking
    const numericId = Number(cardId);
    if (options.isExisting) {
        updateTracker('skills', 'existed', numericId);
    } else {
        updateTracker('skills', 'new', numericId);
    }

    return card;
}


/**
 * Adds an existing skill card with all its data
 * @param {string} uSkillId - Unique skill ID
 * @param {string} skillId - Skill ID
 * @param {string} levelId - Level ID
 * @param {string|null} video - Video URL if exists
 * @param {string|null} certificate - Certificate URL if exists
 */
function addExistedSkillCard(uSkillId, skillId, levelId, video, certificate, videoThumbnail) {
    // Convert ID to number for consistent tracking
    const numericId = Number(uSkillId);
    // console.log('Adding existing skill with ID:', numericId, 'Type:', typeof numericId);

    const card = createSkillCard(uSkillId.toString(), {  // Keep string ID for DOM
        isExisting: true,
        skillId,
        levelId
    });

    if (!card) return;

    skillContainer.appendChild(card);

    // Display existing files if present
    const videoInput = card.querySelector('[name^="skill_video"]');
    const certInput = card.querySelector('[name^="certificate"]');
    const thumbnailInput = card.querySelector('[name^="thumbnail"]');
    const videoLabel = card.querySelector('.label_skill_video');
    const certLabel = card.querySelector('.label_skill_certificate');
    const thumbnailLabel = card.querySelector('.label_skill_thumbnail');

    if (video && videoInput && videoLabel) {
        createExistingFileDisplay('video', videoInput, videoLabel, card);
        updateTracker('video', 'existed', numericId);
    }

    if (certificate && certInput && certLabel) {
        createExistingFileDisplay('certificate', certInput, certLabel, card);
        updateTracker('certificate', 'existed', numericId);
    }
    if (videoThumbnail && thumbnailInput && thumbnailLabel) {
        createExistingFileDisplay('thumbnail', thumbnailInput, thumbnailLabel, card);
        updateTracker('thumbnail', 'existed', numericId);
    }

    // Setup file inputs and remove button
    setupFileInputs(card, uSkillId.toString()); // Keep string ID for DOM attributes
    setupRemoveButton(card, numericId); // Use numeric ID for tracking

    initTooltips();
}


/**
 * Adds a blank skill card for new skill entry
 * @returns {string|null} The ID of the newly created card
 */
function addBlankSkillCard11() {
    console.log('Adding blank card');
    if (checkSkillLimit()) return null;

    const cardId = Date.now().toString();
    const card = createSkillCard(cardId);

    if (!card) return null;

    skillContainer.appendChild(card);

    // Setup file inputs and remove button
    setupFileInputs(card, cardId);
    setupRemoveButton(card, cardId);

    // initTooltips();

    return cardId;
}

function addBlankSkillCard() {
    console.log('addBlankSkillCard called');
    if (checkSkillLimit()) {
        console.log('Skill limit reached, aborting card creation');
        return null;
    }

    const cardId = Date.now().toString();
    console.log(`Generating card with ID ${cardId}`);
    const card = createSkillCard(cardId);

    if (!card) {
        console.error('Failed to create skill card');
        return null;
    }

    // Log container state before append
    const currentCards = skillContainer.querySelectorAll('.skill-card').length;
    console.log(`Current skill cards in container: ${currentCards}`);

    // Ensure cardId doesn't already exist
    if (skillContainer.querySelector(`.skill-card[data-card-id="${cardId}"]`)) {
        console.warn(`Card with ID ${cardId} already exists, skipping append`);
        return null;
    }

    console.log(`Appending card with ID ${cardId} to container`);
    skillContainer.appendChild(card);

    // Verify append result
    const newCardCount = skillContainer.querySelectorAll('.skill-card').length;
    console.log(`New skill card count after append: ${newCardCount}`);
    if (newCardCount !== currentCards + 1) {
        console.error(`Unexpected card count! Expected ${currentCards + 1}, got ${newCardCount}`);
    }

    // Setup file inputs and remove button
    setupFileInputs(card, cardId);
    setupRemoveButton(card, cardId);

    console.log(`Initializing tooltips for card ${cardId}`);
    initTooltips();
    console.log(`Card ${cardId} added successfully`);
    return cardId;
}

/**
 * Initializes Choices.js for select elements in a card
 * @param {HTMLElement} card - The card element
 */
function initSelectsForCard(card) {
    if (typeof Choices !== 'undefined') {
        const skillSelect = card.querySelector('[name="skill"]');
        const levelSelect = card.querySelector('[name="level"]');

        const choicesOptions = {
            searchEnabled: true,
            removeItemButton: true,
            shouldSort: false,
            allowHTML: true,
            classNames: {
                containerOuter: 'choices',
                containerInner: 'choices__inner bg-light',
                listDropdown: 'choices__list--dropdown'
            }
        };

        if (skillSelect && !skillSelect.hasAttribute('data-choicejs')) {
            new Choices(skillSelect, choicesOptions);
            skillSelect.setAttribute('data-choicejs', 'true');
        }

        if (levelSelect && !levelSelect.hasAttribute('data-choicejs')) {
            new Choices(levelSelect, choicesOptions);
            levelSelect.setAttribute('data-choicejs', 'true');
        }
    }
}

// =======================
// FILE UPLOAD MODULES
// =======================
// Update handleFileUploadForCard to properly track changes
function handleFileUploadForCard(fileType, fileInput, fileLabel, cardElement, options = {}) {
    if (!fileInput.files || fileInput.files.length === 0) return;

    const file = fileInput.files[0];
    const fileName = file.name;
    const container = fileInput.parentNode;
    const cardId = cardElement.dataset.cardId;
    const numericId = Number(cardId);

    // Determine the correct action
    let action;
    if (trackers.skills.existed.includes(numericId)) {
        if (trackers[fileType].existed.includes(numericId)) {
            action = 'changed'; // Changing existing file
        } else {
            action = 'uploaded'; // Adding new file to existing skill
        }
    } else {
        action = 'uploaded'; // New skill
    }

    updateTracker(fileType, action, numericId);

    // ✅ Defensive: check if tracker exists
    const tracker = trackers?.[fileType];
    if (!tracker) {
        console.warn(`Unknown file type tracker: ${fileType}`);
        return;
    }

    const uSkillId = options.uSkillId || cardElement.dataset.cardId;

    // Determine if this is a new skill
    const isNewSkill = options.isNew !== undefined ? options.isNew : trackers.skills.new.includes(Number(uSkillId));

    const iconClass = fileType === 'video' ? 'bi bi-file-earmark-play-fill' : 'bi bi-file-earmark-text-fill';

    let removeInputPrefix;
    if (fileType === 'video') {
        removeInputPrefix = 'remove_skill_video_';
    } else if (fileType === 'certificate') {
        removeInputPrefix = 'remove_certificate_';
    } else if (fileType === 'thumbnail') {
        removeInputPrefix = 'remove_thumbnail_';
    }
    const removeFlagName = `${removeInputPrefix}${uSkillId}`;

    // --- Remove old preview ---
    container.querySelector('.file-display')?.remove();

    // --- Create new display preview ---
    const displayDiv = document.createElement('div');
    displayDiv.className = 'd-flex align-items-center bg-light rounded p-2 file-display';

    const icon = document.createElement('i');
    icon.className = `${iconClass} text-success fs-5 me-2`;

    const nameSpan = document.createElement('span');
    nameSpan.className = 'small text-truncate me-3';
    nameSpan.style.maxWidth = '150px';
    nameSpan.textContent = fileName;

    const removeBtn = document.createElement('button');
    removeBtn.type = 'button';
    removeBtn.className = 'btn btn-sm btn-outline-danger mx-auto';
    removeBtn.innerHTML = '<i class="bi bi-trash-fill"></i>';
    removeBtn.setAttribute('data-bs-toggle', 'tooltip');
    removeBtn.setAttribute('title', 'Remove file');

    removeBtn.onclick = () => {
        displayDiv.remove();
        fileInput.style.display = 'd-none';
        fileInput.value = '';
        fileLabel.style.display = 'block';

        tracker.uploaded = tracker.uploaded.filter(id => id !== uSkillId);
        // console.log(`${fileType}-uploaded: `, tracker.uploaded);

        let removeFlag = cardElement.querySelector(`input[name="${removeFlagName}"]`);
        if (!removeFlag) {
            removeFlag = document.createElement('input');
            removeFlag.type = 'hidden';
            removeFlag.name = removeFlagName;
            removeFlag.value = 'true';
            cardElement.appendChild(removeFlag);
        }
    };

    displayDiv.appendChild(icon);
    displayDiv.appendChild(nameSpan);
    displayDiv.appendChild(removeBtn);

    fileLabel.style.display = 'none';
    fileInput.style.display = 'none';
    container.insertBefore(displayDiv, fileInput.nextSibling);

    // Remove previous remove flag if re-uploading
    cardElement.querySelector(`input[name="${removeFlagName}"]`)?.remove();

    initTooltips();
}


// Main file handler
function handleFileUpload(input, options = {}) {
    const files = input.files;
    const container = document.getElementById(options.previewContainerId || 'uploadedFilesContainer');
    container.innerHTML = ''; // Clear existing previews

    const allowedExtensions = options.allowedExtensions || ['pdf', 'mp4'];
    const validFiles = [];

    Array.from(files).forEach((file, index) => {
        const ext = file.name.split('.').pop().toLowerCase();
        if (!allowedExtensions.includes(ext)) {
            showAlert(`The selected file type "${ext}" is not supported.`, 'error');
            return;
        }

        validFiles.push(file);
        renderFilePreview(file, index, container);
    });

    // Attach event listeners to delete buttons
    container.querySelectorAll('.btn-remove-file').forEach(btn => {
        btn.addEventListener('click', function () {
            const fileIndex = parseInt(this.dataset.index, 10);
            container.querySelector(`[data-file-index="${fileIndex}"]`)?.remove();
            // Mark the file for deletion or handle accordingly
            if (typeof options.onRemove === 'function') {
                options.onRemove(fileIndex);
            }
        });
    });

    if (typeof options.onValidFiles === 'function') {
        options.onValidFiles(validFiles);
    }
}

// ======================= ===========================================================
// HELPER FUNCTIONS
// ======================= ===========================================================
// Validate file type
function validateFileType_main(file, allowedExtensions) {
    if (!file || !file.name) return false;

    const parts = file.name.split('.');
    if (parts.length < 2) return false;

    const extension = parts.pop().toLowerCase();
    return allowedExtensions.includes(extension);
}

//====================================================================================================
// Helper function to validate files with multiple criteria
function validateFile(file, options) {
    const result = {valid: true, message: ''};
    const fileExt = file.name.split('.').pop().toLowerCase();

    // Validate file type by extension
    if (options.allowedTypes && !options.allowedTypes.includes(fileExt)) {
        result.valid = false;
        result.message = `Invalid file type (.${fileExt}). Allowed: ${options.allowedTypes.map(ext => `.${ext}`).join(', ')}`;
        return result;
    }

    // Validate file size
    if (options.maxSize && file.size > options.maxSize) {
        result.valid = false;
        const maxSizeMB = options.maxSize / (1024 * 1024);
        result.message = `File too large (${(file.size / (1024 * 1024)).toFixed(1)}MB). Maximum: ${maxSizeMB}MB`;
        return result;
    }

    // Additional validations can be added here (duration, dimensions, etc.)
    // Validate video duration (if video and duration checks are needed)
    if (file.type.startsWith('video/') && options.minDuration !== undefined) {
        // Note: Actual duration validation would need to be done after file is loaded
        // This would require a more complex async validation
        result.message = 'Duration validation would require file loading';
    }

    // Validate image dimensions (if image and dimension checks are needed)
    if (file.type.startsWith('image/') && options.minDimensions) {
        // Note: Actual dimension validation would need to be done after image is loaded
        result.message = 'Dimension validation would require image loading';
    }

    return result;
}

// Validate file type by extension
function validateFileType(file, allowedExtensions) {
    if (!file || !file.name) return {valid: false, message: 'No file selected'};

    const parts = file.name.split('.');
    if (parts.length < 2) return {valid: false, message: 'File has no extension'};

    const extension = parts.pop().toLowerCase();
    const isValid = allowedExtensions.includes(extension);

    return {
        valid: isValid,
        message: isValid ? '' : `Invalid file type (.${extension}). Allowed: ${allowedExtensions.map(ext => `.${ext}`).join(', ')}`
    };
}

// Validate file size
function validateFileSize(file, maxSizeBytes) {
    if (!file || !file.size) return {valid: false, message: 'No file selected'};

    const maxSizeMB = maxSizeBytes / (1024 * 1024);
    const fileSizeMB = file.size / (1024 * 1024);
    const isValid = file.size <= maxSizeBytes;

    return {
        valid: isValid,
        message: isValid ? '' : `File too large (${fileSizeMB.toFixed(1)}MB). Maximum: ${maxSizeMB}MB`
    };
}

// Validate video duration (async - requires file loading)
function validateVideoDuration(file, minDuration, maxDuration) {
    return new Promise((resolve) => {
        if (!file || !file.type.startsWith('video/')) {
            resolve({valid: false, message: 'Not a video file'});
            return;
        }

        const video = document.createElement('video');
        video.preload = 'metadata';

        video.onloadedmetadata = () => {
            window.URL.revokeObjectURL(video.src);
            const duration = video.duration;

            let isValid = true;
            let message = '';

            if (minDuration !== undefined && duration < minDuration) {
                isValid = false;
                message = `Video too short (${duration.toFixed(1)}s). Minimum: ${minDuration}s`;
            } else if (maxDuration !== undefined && duration > maxDuration) {
                isValid = false;
                message = `Video too long (${duration.toFixed(1)}s). Maximum: ${maxDuration}s`;
            }

            resolve({valid: isValid, message});
        };

        video.onerror = () => {
            resolve({valid: false, message: 'Could not load video for duration validation'});
        };

        video.src = URL.createObjectURL(file);
    });
}

// Validate image dimensions (async - requires image loading)
function validateImageDimensions(file, minWidth, minHeight) {
    return new Promise((resolve) => {
        if (!file || !file.type.startsWith('image/')) {
            resolve({valid: false, message: 'Not an image file'});
            return;
        }

        const img = new Image();
        img.onload = () => {
            window.URL.revokeObjectURL(img.src);
            let isValid = true;
            let message = '';

            if (minWidth && img.width < minWidth) {
                isValid = false;
                message = `Image too narrow (${img.width}px). Minimum width: ${minWidth}px`;
            } else if (minHeight && img.height < minHeight) {
                isValid = false;
                message = `Image too short (${img.height}px). Minimum height: ${minHeight}px`;
            }

            resolve({valid: isValid, message});
        };

        img.onerror = () => {
            resolve({valid: false, message: 'Could not load image for dimension validation'});
        };

        img.src = URL.createObjectURL(file);
    });
}

//====================================================================================================

/**
 * Checks if skill limit has been reached
 */
function checkSkillLimit() {
    const alertLimitMessage = document.querySelector('#skillLimitAlert');
    // const btnAddSkill = document.getElementById('btnAddSkill');
    if (skillContainer.querySelectorAll('.skill-card').length >= maxEntries) {
        if (alertLimitMessage) alertLimitMessage.classList.remove('d-none');
        showAlert(`You can add up to ${maxEntries} skills only.`, 'error');
        btnAddSkill.disabled = true;
        return true; // means limit reached
    } else {
        if (alertLimitMessage) alertLimitMessage.classList.add('d-none');
        btnAddSkill.disabled = false;
        return false; // means we can add more skills yet!
    }
}

// Utility to format file size
function formatFileSize(bytes) {
    const sizes = ['Bytes', 'KB', 'MB', 'GB'];
    if (bytes === 0) return '0 Byte';
    const i = parseInt(Math.floor(Math.log(bytes) / Math.log(1024)), 10);
    return `${(bytes / Math.pow(1024, i)).toFixed(1)} ${sizes[i]}`;
}

// Utility to get file type icon based on extension
function getFileTypeIcon(extension) {
    switch (extension.toLowerCase()) {
        case 'pdf':
            return '📄'; // can replace with <i class="fas fa-file-pdf"></i>
        case 'mp4':
            return '🎥'; // can replace with <i class="fas fa-file-video"></i>
        default:
            return '📁';
    }
}

// Render a file block
function renderFilePreview(file, index, container) {
    const ext = file.name.split('.').pop();
    const fileDiv = document.createElement('div');
    fileDiv.className = 'uploaded-file d-flex align-items-center justify-content-between mb-2';
    fileDiv.setAttribute('data-file-index', index);

    fileDiv.innerHTML = `
        <div class="file-info d-flex align-items-center gap-2">
            <span class="file-icon">${getFileTypeIcon(ext)}</span>
            <span class="file-name">${file.name}</span>
            <small class="file-size text-muted">(${formatFileSize(file.size)})</small>
        </div>
        <div class="file-actions">
            <button type="button" class="btn btn-sm btn-outline-danger btn-remove-file" data-index="${index}">
                <i class="fas fa-trash"></i>
            </button>
        </div>
    `;

    container.appendChild(fileDiv);
}

function updateTracker_main(type, action, id, logger = false) {
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

// Update the tracker function to ensure consistent ID types
function updateTracker(type, action, id, logger = false) {
    // Convert ID to number for consistency
    const numId = Number(id);

    // First remove the ID from any other actions in the same type
    Object.keys(trackers[type]).forEach(key => {
        if (key !== action) {
            trackers[type][key] = trackers[type][key].filter(item => Number(item) !== numId);
        }
    });

    // Then add to the specified action if not already present
    if (!trackers[type][action].includes(numId)) {
        trackers[type][action].push(numId);
    }

    if (logger) console.log(`${type} - ${action}: `, numId, trackers[type][action]);
}

// ============================
// INITIALIZATION
// ============================
// Initialize select2/choices.js
export function initSelects() {
    if (typeof Choices !== 'undefined') {
        document.querySelectorAll('.js-choice:not([data-choicejs])').forEach(select => {
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

/**
 * Initializes tooltips
 */
export function initTooltips() {
    if (typeof bootstrap !== 'undefined') {
        document.querySelectorAll('[data-bs-toggle="tooltip"]').forEach(el => {
            // Dispose if already has a tooltip instance
            const tooltipInstance = bootstrap.Tooltip.getInstance(el);
            if (tooltipInstance) tooltipInstance.dispose();

            new bootstrap.Tooltip(el);
        });
    }
}

// ============================
// EVENT LISTENERS
// ============================
// --------------------------- Add Blank skill card ---------------------------

function addSkillCardHandler() {
    console.log('Handler started');
    this.disabled = true;
    addBlankSkillCard();
    setTimeout(() => {
        this.disabled = false;
    }, 500);
}

// ============================
// INITIALIZATION
// ============================
document.addEventListener('DOMContentLoaded', function () {


    try {
        loadExistingSkills();
        initSelects();
        initTooltips();
        // Add the listener here to ensure the button exists
        if (btnAddSkill) {
            btnAddSkill.addEventListener('click', addSkillCardHandler);
        }
    } catch (e) {
        console.error('Initialization error:', e);
    }
    try {
        initSelects();
    } catch (e) {
        console.error(e);
    }
    try {
        initTooltips();
    } catch (e) {
        console.error(e);
    }
});


// =============================
// SUPPORTING FUNCTIONS
// =============================

/**
 * Sets up file inputs for a skill card
 * @param {HTMLElement} card - The card element
 * @param {string} cardId - The card's unique ID
 */
function setupFileInputs(card, cardId) {
    const videoInput = card.querySelector('[name^="skill_video"]');
    const certInput = card.querySelector('[name^="certificate"]');
    const thumbnailInput = card.querySelector('[name^="thumbnail"]');
    const videoLabel = card.querySelector('.label_skill_video');
    const certLabel = card.querySelector('.label_skill_certificate');
    const thumbnailLabel = card.querySelector('.label_skill_thumbnail');

    if (videoInput) {
        videoInput.name = `skill_video_${cardId}`;
        videoInput.classList.add('skill_video_input');
    }

    if (certInput) {
        certInput.name = `certificate_${cardId}`;
        certInput.classList.add('certificate_input');
    }
    if (thumbnailInput) {
        thumbnailInput.name = `thumbnail_${cardId}`;
        thumbnailInput.classList.add('thumbnail_input');
    }

    if (videoInput && videoLabel) {
        videoLabel.addEventListener('click', () => videoInput.click());
        videoInput.addEventListener('change', () => {
            handleFileUploadForCard('video', videoInput, videoLabel, card, {
                uSkillId: cardId,
                isNew: trackers.skills.new.includes(cardId)
            });
        });
    }

    if (certInput && certLabel) {
        certLabel.addEventListener('click', () => certInput.click());
        certInput.addEventListener('change', () => {
            handleFileUploadForCard('certificate', certInput, certLabel, card, {
                uSkillId: cardId,
                isNew: trackers.skills.new.includes(cardId)
            });
        });
    }
    if (thumbnailInput && thumbnailLabel) {
        thumbnailLabel.addEventListener('click', () => thumbnailInput.click());
        thumbnailInput.addEventListener('change', () => {
            handleFileUploadForCard('thumbnail', thumbnailInput, thumbnailLabel, card, {
                uSkillId: cardId,
                isNew: trackers.skills.new.includes(cardId)
            });
        });
    }
}

/**
 * Sets up the remove button for a skill card
 * @param {HTMLElement} card - The card element
 * @param {string} cardId - The card's unique ID
 */
function setupRemoveButton(card, cardId) {
    const removeBtn = card.querySelector('.remove-skill');
    if (!removeBtn) return;

    const numericId = Number(cardId);

    removeBtn.addEventListener('click', async function () {
        // if (!confirm('Are you sure you want to remove this skill?')) return;

        try {
            // Use await with showConfirm
            const isConfirmed = await showConfirm(`Are you sure you want to remove this skill?`, {
                type: 'danger',
                confirmText: 'Yes, remove',
                cancelText: 'Keep it'
            });

            if (!isConfirmed) return;


            if (trackers.skills.existed.includes(numericId)) {
                updateTracker('video', 'removed', numericId);
                updateTracker('certificate', 'removed', numericId);
                updateTracker('thumbnail', 'removed', numericId);
                updateTracker('skills', 'removed', numericId);
            } else {
                trackers.skills.new = trackers.skills.new.filter(id => id !== numericId);
            }

            card.remove();
            checkSkillLimit();
        } catch (error) {
            console.error('Error in removal process:', error);
        }
    });
}

// --------------------------------- ARCHIVED --------------------------------
function handleVideoIntro(videoIntroUrl) {
    const input = document.querySelector('[name="video_intro"]');
    const label = document.querySelector('.label_skill_video');
    const container = document.getElementById('video_intro_container');

    if (!input || !label || !container) return;

    // Initialize tracker
    trackers.introVideo = {
        existed: !!videoIntroUrl,
        uploaded: false,
        removed: false
    };

    // Clear any existing display first
    const existingDisplay = container.querySelector('.intro-video-display');
    if (existingDisplay) {
        container.removeChild(existingDisplay);
    }

    // Show existing file if any
    if (videoIntroUrl) {
        createVideoIntroDisplay(input, label, container, videoIntroUrl, true);
    }

    input.addEventListener('change', () => {
        if (input.files && input.files[0]) {
            // New file uploaded
            trackers.introVideo.uploaded = true;
            trackers.introVideo.removed = false;

            // Create display for new file
            createVideoIntroDisplay(input, label, container, input.files[0].name, false);

            // Remove any "remove" flag
            const removeFlag = container.querySelector('input[name="remove_video_intro"]');
            if (removeFlag) {
                container.removeChild(removeFlag);
            }
        }
    });
}

function createVideoIntroDisplay(input, label, container, fileInfo, isExisting) {
    // Remove any existing display first
    const existingDisplay = container.querySelector('.intro-video-display');
    if (existingDisplay) {
        container.removeChild(existingDisplay);
    }

    // Create new display
    const displayDiv = document.createElement('div');
    displayDiv.className = ' align-items-center bg-light rounded p-2 intro-video-display mb-2 col-12';

    const icon = document.createElement('i');
    icon.className = isExisting
        ? 'bi bi-file-earmark-play-fill text-primary fs-5 me-2'
        : 'bi bi-file-earmark-play-fill text-success fs-5 me-2';

    const textSpan = document.createElement('span');
    textSpan.className = 'small me-3';
    textSpan.textContent = isExisting ? 'Video uploaded' : fileInfo;

    const btnGroup = document.createElement('div');
    btnGroup.className = 'btn-group ms-auto';

    // Change button
    const changeBtn = document.createElement('button');
    changeBtn.type = 'button';
    changeBtn.className = 'btn btn-sm btn-outline-primary';
    changeBtn.innerHTML = '<i class="bi bi-pencil-fill"></i>';
    changeBtn.setAttribute('data-bs-toggle', 'tooltip');
    changeBtn.setAttribute('title', 'Change video');

    changeBtn.addEventListener('click', () => {
        container.removeChild(displayDiv);
        input.style.display = 'none';
        label.style.display = 'block';
        input.click();
    });

    // Remove button
    const removeBtn = document.createElement('button');
    removeBtn.type = 'button';
    removeBtn.className = 'btn btn-sm btn-outline-danger';
    removeBtn.innerHTML = '<i class="bi bi-trash-fill"></i>';
    removeBtn.setAttribute('data-bs-toggle', 'tooltip');
    removeBtn.setAttribute('title', 'Remove video');

    removeBtn.addEventListener('click', () => {
        container.removeChild(displayDiv);
        input.value = '';
        input.style.display = 'none';
        label.style.display = 'block';

        if (trackers.introVideo.existed) {
            trackers.introVideo.existed = false;
            trackers.introVideo.removed = true;
            const removeFlag = document.createElement('input');
            removeFlag.type = 'hidden';
            removeFlag.name = 'remove_video_intro';
            removeFlag.value = 'true';
            container.appendChild(removeFlag);
        }
        trackers.introVideo.uploaded = false;
    });

    btnGroup.appendChild(changeBtn);
    btnGroup.appendChild(removeBtn);

    displayDiv.appendChild(icon);
    displayDiv.appendChild(textSpan);
    displayDiv.appendChild(btnGroup);

    // Find the correct position to insert (after the label's parent div)
    const labelParent = label.parentElement;
    container.insertBefore(displayDiv, labelParent.nextSibling);

    label.style.display = 'none';
    input.style.display = 'none';

    initTooltips();
}

function appendHiddenInput(parent, name, value) {
    const input = document.createElement('input');
    input.type = 'hidden';
    input.name = name;
    input.value = value;
    parent.appendChild(input);
}

export async function submit_skills_MAIN() {
    if (!validate_skills()) {
        // showAlert('Please correct the errors in the form before submitting.', 'error');
        return {success: false, error: 'Validation failed'};
    }

    // console.log('Pre-submit trackers:', {
    //     skills: trackers.skills,
    //     videos: trackers.video,
    //     certs: trackers.certificate,
    //     thumbs: trackers.thumbnail
    // });

    const formData = new FormData();
    let submitTimeout;

    try {
        // Set timeout
        const timeoutPromise = new Promise((_, reject) => {
            submitTimeout = setTimeout(() => reject(new Error('Request timed out')), 15000);
        });

        // Add tracking data
        formData.append('skills_removed', JSON.stringify(trackers.skills.removed));
        formData.append('skills_new', JSON.stringify(trackers.skills.new));

        formData.append('videos_new', JSON.stringify(trackers.video.uploaded));
        formData.append('videos_changed', JSON.stringify(trackers.video.changed));
        formData.append('videos_removed', JSON.stringify(trackers.video.removed));

        formData.append('certs_new', JSON.stringify(trackers.certificate.uploaded));
        formData.append('certs_changed', JSON.stringify(trackers.certificate.changed));
        formData.append('certs_removed', JSON.stringify(trackers.certificate.removed));

        formData.append('thumbs_new', JSON.stringify(trackers.thumbnail.uploaded));
        formData.append('thumbs_changed', JSON.stringify(trackers.thumbnail.changed));
        formData.append('thumbs_removed', JSON.stringify(trackers.thumbnail.removed));


        // Process skill cards
        const skillCards = document.querySelectorAll('.skill-card');
        skillCards.forEach(card => {
            const cardId = card.dataset.cardId;
            const isNewSkill = trackers.skills.new.includes(cardId);

            // Append skill data
            formData.append(`skill_ids[]`, cardId);
            formData.append(`skills[]`, card.querySelector('[name^="skill"]').value);
            formData.append(`levels[]`, card.querySelector('[name^="level"]').value);

            // Handle files
            const videoInput = card.querySelector(`[name="skill_video_${cardId}"]`);
            if (videoInput?.files[0]) {
                formData.append(`skill_video_${cardId}`, videoInput.files[0]);
            }

            const certInput = card.querySelector(`[name="certificate_${cardId}"]`);
            if (certInput?.files[0]) {
                formData.append(`certificate_${cardId}`, certInput.files[0]);
            }

            const thumbInput = card.querySelector(`[name="thumbnail_${cardId}"]`);
            if (thumbInput?.files[0]) {
                formData.append(`thumbnail_${cardId}`, thumbInput.files[0]);
            }

            // Handle remove flags for existing skills
            if (!isNewSkill) {
                const removeFlag = card.querySelector(`[name="remove_skill_${cardId}"]`);
                if (removeFlag) formData.append(removeFlag.name, removeFlag.value);
            }
        });

        // Debug form data - log all entries
        // console.log('FormData entries:');
        // for (let [key, value] of formData.entries()) {
        //     if (value instanceof File) {
        //         console.log(key, value.name, value.size, value.type);
        //     } else {
        //         console.log(key, value);
        //     }
        // }

        // Add CSRF token
        const csrfToken = document.querySelector('[name="csrfmiddlewaretoken"]')?.value;
        if (csrfToken) formData.append('csrfmiddlewaretoken', csrfToken);

        const response = await Promise.race([
            fetch('/tutor/save-skills/', {
                method: 'POST',
                body: formData,
                headers: {
                    'X-Requested-With': 'XMLHttpRequest',
                    // Don't set Content-Type - let browser set it with boundary
                }
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
            throw new Error(errorData.error || 'Failed to save skill data');
        }

        const result = await response.json();
        // if (result.success) {
        //     if (result.warnings?.length) {
        //         result.warnings.forEach(warning => showAlert(warning, 'warning'));
        //     }
        //     showAlert('skills data saved successfully!', 'success');
        //     resetTrackers();
        //     await loadExistingSkills();
        // }
        // Update your submit_skills success handler
        if (result.success) {
            // Update skill IDs in the DOM
            if (result.skill_mapping) {
                Object.entries(result.skill_mapping).forEach(([frontendId, backendId]) => {
                    const card = document.querySelector(`.skill-card[data-card-id="${frontendId}"]`);
                    if (card) {
                        card.dataset.cardId = backendId;
                        // Update all input names
                        ['skill_video', 'certificate', 'thumbnail'].forEach(prefix => {
                            const input = card.querySelector(`[name^="${prefix}"]`);
                            if (input) {
                                input.name = input.name.replace(
                                    `${prefix}_${frontendId}`,
                                    `${prefix}_${backendId}`
                                );
                            }
                        });
                    }
                });
            }

            // Reset trackers with new backend IDs
            resetTrackers();
            await loadExistingSkills(); // Reload to get proper backend IDs
        }


        return result;
    } catch (error) {
        clearTimeout(submitTimeout);
        console.error("Submission error:", error);
        showAlert(error.message || 'Failed to save skills data. Please try again.', 'error');
        return {success: false, error: error.message || 'Failed to save skills data'};
    }
}

// Composite file validator that uses the above functions
async function validateFile_composite(file, options = {}) {
    // Validate required fields
    if (!file) return {valid: false, message: 'No file selected'};

    // Validate file type if needed
    if (options.allowedTypes) {
        const typeValidation = validateFileType(file, options.allowedTypes);
        if (!typeValidation.valid) return typeValidation;
    }

    // Validate file size if needed
    if (options.maxSize) {
        const sizeValidation = validateFileSize(file, options.maxSize);
        if (!sizeValidation.valid) return sizeValidation;
    }

    // Validate video duration if needed
    if (file.type.startsWith('video/') && (options.minDuration || options.maxDuration)) {
        const durationValidation = await validateVideoDuration(
            file,
            options.minDuration,
            options.maxDuration
        );
        if (!durationValidation.valid) return durationValidation;
    }

    // Validate image dimensions if needed
    if (file.type.startsWith('image/') && (options.minWidth || options.minHeight)) {
        const dimensionValidation = await validateImageDimensions(
            file,
            options.minWidth,
            options.minHeight
        );
        if (!dimensionValidation.valid) return dimensionValidation;
    }

    return {valid: true, message: ''};
}
