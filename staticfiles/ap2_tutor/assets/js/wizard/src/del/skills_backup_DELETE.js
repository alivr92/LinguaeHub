import {showBootstrapAlert2} from '/static/assets/js/avr.js';
const maxEntries = parseInt(document.getElementById('maxEntries').value);
console.log('maxEntries: ', maxEntries);

// =============================================
// GLOBAL VARIABLES
// =============================================
const template = document.getElementById('skill-card-template');
const applicantUId = parseInt(document.getElementById('applicantUId').value);
const container = document.getElementById('skills-container');
// const maxSkills = document.getElementById('isVIP').value.toLowerCase() === 'true' ? 5 : 3; // Set max skills limit based on VIP status
const validVideoTypes = ['mp4'];
const validCertificateTypes = ['pdf', 'doc', 'docx', 'png', 'jpg', 'jpeg'];
const validThumbnailTypes = ['png', 'jpg', 'jpeg'];
//============================== UPLOAD PROGRESS =====================================
// Progress tracking variables
const uploadProgressModal = new bootstrap.Modal(document.getElementById('uploadProgressModal'));
const progressBar = document.getElementById('uploadProgressBar');
const progressText = document.getElementById('uploadProgressText');
const cancelUploadBtn = document.getElementById('cancelUploadBtn');
let uploadController = null;
//===================================================================
// ====== STATE ======
// let hasExistingIntroVideo = false;
let errSkills = [];
let errLevels = [];
let errVideos = [];

let removedSkillIds = [];    // Track completely removed skills

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
        existed: [],
        removed: [],
        new: []       // Track completely new skills
    },
    // introVideo: {
    //     existed: false,
    //     uploaded: false,
    //     removed: false
    // }
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
        // console.log('Received data:', data);
        // Process intro video
        // handleVideoIntro(data.video_intro);

        // Clear container safely
        while (container.firstChild) {
            container.removeChild(container.firstChild);
        }

        // handleVideoIntro(data.video_intro);

        // Process skills
        if (data.existed_uSkill_list && Array.isArray(data.existed_uSkill_list)) {
            data.existed_uSkill_list.forEach(uSkill => {
                // console.log('Processing skill:', uSkill);
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
            console.log('Videos-existed: ', trackers.video.existed);
            console.log('Certificates-existed: ', trackers.certificate.existed);
            console.log('Thumbnail-existed: ', trackers.thumbnail.existed);

        } else {
            console.error('Invalid data format:', data);
        }
    } catch (error) {
        console.error('Error fetching skills:', error);
    }
}

// ====================== EXPORTED FUNCTIONS ======================
// Client-side Step2 Validation
export function validate_skills_main() {
    console.log(`validate_skills-trackers: `, trackers);

    const container = document.getElementById('skills-container');
    const cards = container.querySelectorAll('.skill-card');
    // const videoIntroInput = document.querySelector('[name="video_intro"]');
    let isValid = true;

    // Reset error tracking
    errSkills = [];
    errLevels = [];
    errVideos = [];

    if (cards.length > maxEntries) {
        showBootstrapAlert2(`Maximum ${maxEntries} skills allowed`, 'danger', 5000);
        return false;
    }

    cards.forEach((card, index) => {
        const cardId = card.dataset.cardId;
        const skill = card.querySelector('[name^="skill"]');
        const level = card.querySelector('[name^="level"]');
        const skillVideo = card.querySelector('[name^="skill_video"]');
        const certificate = card.querySelector('[name^="certificate"]');
        const thumbnail = card.querySelector('[name^="thumbnail"]');

        const skillName = skill?.options[skill.selectedIndex]?.text || 'Unknown Skill';
        const cardNumber = index + 1;

        // Required fields
        if (!skill?.value) {
            errSkills.push(`Row ${cardNumber}`);
            isValid = false;
        }
        if (!level?.value) {
            errLevels.push(`Row ${cardNumber} (${skillName})`);
            isValid = false;
        }


        const isExisted = trackers.video.existed.includes(cardId);
        const isNew = trackers.video.uploaded.includes(cardId);
        const isRemoved = trackers.video.removed.includes(cardId);
        const isChanged = trackers.video.changed.includes(cardId);
        // if video is existed from before we don't need to validate it
        if (isExisted && !isRemoved && !isNew) {
            //don't check for validation
        }
        if (isExisted && isRemoved) {
            // notify user to upload a new one (because video is required!)
            isValid = false;
        }
        if (isExisted && isRemoved && isNew) {
            // check for validation uploaded files
        }
        if (!isExisted && isNew) {
            // check for validation uploaded files
        }


        if (!isExisted && isNew && isRemoved) {
            const file = skillVideo?.files?.[0];
            if (!file) {
                errVideos.push(`Row ${cardNumber} (${skillName})`);
                showBootstrapAlert2('video is required for each skill', 'danger', 5000);
                isValid = false;
            } else {
                // if(validateFileType(file, validVideoTypes));
                // validateFileSize(file, allowedExtensions);
                // validateVideoDuration(file, allowedExtensions);
                console.log('validateFileType ...  ');
                isValid = false;

                // if (!videoValidation) {
                //     showBootstrapAlert2(`Invalid video format or file size for skill ${cardNumber}. Allowed: ${validVideoTypes.join(', ')}`, 'danger', 5000);
                //     isValid = false;
                // }
            }
        }

        // skillVideo check
        // if (!skillVideo?.files?.[0]) {
        //     errVideos.push(`Row ${cardNumber} (${skillName})`);
        //     showBootstrapAlert2('video is required for each skill', 'danger', 5000);
        //     isValid = false;
        // }
        // // Video file validation
        // if (skillVideo?.files[0]) {
        //     if (!validateFileType(file, validVideoTypes)) {
        //         showBootstrapAlert2(`Invalid video format for skill ${cardNumber}. Allowed: ${validVideoTypes.join(', ')}`, 'danger', 5000);
        //         isValid = false;
        //     }
        //     if (!validateFile(file, {maxSize: 50,})) {
        //         const isExisted = trackers.video.existed.includes(cardId);
        //         // const action = isExisted ? 'changed' : 'uploaded';
        //         // updateTracker('video', action, cardId);
        //     }
        // }


        // Certificate file validation
        if (certificate?.files[0]) {
            const file = certificate.files[0];
            if (!validateFileType(file, validCertificateTypes)) {
                showBootstrapAlert2(`Invalid certificate format for row ${cardNumber}. Allowed: ${validCertificateTypes.join(', ')}`, 'danger', 5000);
                isValid = false;
            } else {
                const isExisted = trackers.certificate.existed.includes(cardId);
                const action = isExisted ? 'changed' : 'uploaded';
                updateTracker('certificate', action, cardId);
            }
        }
        // Thumbnail file validation
        if (thumbnail?.files[0]) {
            const file = thumbnail.files[0];
            if (!validateFileType(file, validThumbnailTypes)) {
                showBootstrapAlert2(`Invalid thumbnail format for row ${cardNumber}. Allowed: ${validThumbnailTypes.join(', ')}`, 'danger', 5000);
                isValid = false;
            } else {
                const isExisted = trackers.thumbnail.existed.includes(cardId);
                const action = isExisted ? 'changed' : 'uploaded';
                updateTracker('thumbnail', action, cardId);
            }
        }
    });

    // Display collected skill/level errors
    if (errSkills.length > 0) {
        showBootstrapAlert2(`Please choose a skill for: ${errSkills.join(', ')}`, 'danger', 5000);
    }
    if (errLevels.length > 0) {
        showBootstrapAlert2(`Please select a level for: ${errLevels.join(', ')}`, 'danger', 5000);
    }
    if (errVideos.length > 0) {
        showBootstrapAlert2(`Please upload proper video for: ${errVideos.join(', ')}`, 'danger', 5000);
    }


    // // Intro video check
    // if (!hasExistingIntroVideo && !videoIntroInput?.files?.[0]) {
    //     showBootstrapAlert2('Introduction video is required', 'danger', 5000);
    //     isValid = false;
    // } else if (videoIntroInput?.files?.[0] && !validateFileType(videoIntroInput.files[0], validVideoTypes)) {
    //     showBootstrapAlert2(`Invalid intro video format. Allowed: ${validVideoTypes.join(', ')}`, 'danger', 5000);
    //     isValid = false;
    // }
    //
    // // Additional validation for intro video
    // if (!trackers.introVideo.existed && !trackers.introVideo.uploaded) {
    //     showBootstrapAlert2('Introduction video is required', 'danger', 5000);
    //     isValid = false;
    // } else if (videoIntroInput?.files?.[0] && !validateFileType(videoIntroInput.files[0], validVideoTypes)) {
    //     showBootstrapAlert2(`Invalid intro video format. Allowed: ${validVideoTypes.join(', ')}`, 'danger', 5000);
    //     isValid = false;
    // }

    return isValid;
}

//=================================================================
// Validation works well
export function validate_skills() {
    console.log('Validating skills - Current trackers state:', trackers);

    const container = document.getElementById('skills-container');
    const cards = container.querySelectorAll('.skill-card');
    let isValid = true;

    // Reset error tracking
    errSkills = [];
    errLevels = [];
    errVideos = [];

    // Validate maximum entries first
    if (cards.length > maxEntries) {
        showBootstrapAlert2(`Maximum ${maxEntries} skills allowed`, 'danger', 5000);
        return false;
    }

    // Validate each card
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

        // Required field validation
        let cardIsValid = true;

        // 1. Validate Skill (required)
        if (!skillSelect?.value) {
            markFieldInvalid(skillSelect, 'Please select a skill');
            errSkills.push(`Row ${cardNumber}`);
            cardIsValid = false;
        }

        // 2. Validate Level (required)
        if (!levelSelect?.value) {
            markFieldInvalid(levelSelect, 'Please select a proficiency level');
            errLevels.push(`Row ${cardNumber} (${skillName})`);
            cardIsValid = false;
        }

        // 3. Validate Video (required) - Simplified logic
        const cardIdNum = Number(cardId);
        const hasExistingVideo = trackers.video.existed.includes(cardIdNum);
        const hasNewVideo = trackers.video.uploaded.includes(cardIdNum);
        const videoWasRemoved = trackers.video.removed.includes(cardIdNum);

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
                showBootstrapAlert2(`Video error for ${skillName}: ${videoValidation.message}`, 'danger', 5000);
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
                showBootstrapAlert2(`Certificate error for ${skillName}: ${certValidation.message}`, 'danger', 5000);
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
                showBootstrapAlert2(`Thumbnail error for ${skillName}: ${thumbValidation.message}`, 'danger', 5000);
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
    if (errSkills.length > 0) {
        showBootstrapAlert2(`Skill required for: ${errSkills.join(', ')}`, 'danger', 5000);
    }
    if (errLevels.length > 0) {
        showBootstrapAlert2(`Proficiency level required for: ${errLevels.join(', ')}`, 'danger', 5000);
    }
    if (errVideos.length > 0) {
        showBootstrapAlert2(`Demonstration video required for: ${errVideos.join(', ')}`, 'danger', 5000);
    }

    return isValid;
}

//--------------------------------------------------------------

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

export async function submit_skills() {
    if (!validate_skills()) {
        showBootstrapAlert2('Please correct the errors in the form before submitting.', 'danger', 5000);
        return {success: false, error: 'Validation failed'};
    }
    const formData = new FormData();
    const container = document.getElementById('skills-container');
    if (!container) return {success: false, error: 'Form elements not found'};

    const cards = Array.from(container.querySelectorAll('.skill-card'));
    let submitTimeout;

    try {
        // Set timeout
        const timeoutPromise = new Promise((_, reject) => {
            submitTimeout = setTimeout(() => reject(new Error('Request timed out')), 15000);
        });

        console.log('PRE-SUBMIT TRACKERS-1:', trackers);

        // Add tracking data
        formData.append('videos_new', JSON.stringify(trackers.video.uploaded));
        formData.append('videos_changed', JSON.stringify(trackers.video.changed));
        formData.append('videos_removed', JSON.stringify(trackers.video.removed));

        formData.append('certs_new', JSON.stringify(trackers.certificate.uploaded));
        formData.append('certs_changed', JSON.stringify(trackers.certificate.changed));
        formData.append('certs_removed', JSON.stringify(trackers.certificate.removed));

        formData.append('thumbs_new', JSON.stringify(trackers.thumbnail.uploaded));
        formData.append('thumbs_changed', JSON.stringify(trackers.thumbnail.changed));
        formData.append('thumbs_removed', JSON.stringify(trackers.thumbnail.removed));

        formData.append('skills_removed', JSON.stringify(removedSkillIds));
        formData.append('skills_new', JSON.stringify(trackers.skills.new));

        // Add intro video action
        // formData.append('intro_video_action',
        //     trackers.introVideo.uploaded ? 'uploaded' :
        //         trackers.introVideo.removed ? 'removed' : 'unchanged');

        // Process each card
        cards.forEach((card, index) => {
            const cardId = card.dataset.cardId;
            const isNewSkill = trackers.skills.new.includes(cardId);
            const skill = card.querySelector('[name^="skill"]');
            const level = card.querySelector('[name^="level"]');
            const skillVideo = card.querySelector('[name^="skill_video"]');
            const certificate = card.querySelector('[name^="certificate"]');
            const thumbnail = card.querySelector('[name^="thumbnail"]');

            if (!skill || !level || !skillVideo) {
                throw new Error(`Missing required fields in row ${index + 1}`);
            }

            // Append skill data
            formData.append(`skills[]`, skill.value);
            formData.append(`levels[]`, level.value);
            formData.append(`skill_ids[]`, cardId);

            // Handle files based on tracker state
            if (skillVideo?.files[0]) {
                formData.append(`skill_videos_${cardId}`, skillVideo.files[0]);
            }
            if (certificate?.files[0]) {
                formData.append(`certificates_${cardId}`, certificate.files[0]);
            }
            if (thumbnail?.files[0]) {
                formData.append(`thumbnails_${cardId}`, thumbnail.files[0]);
            }


            // Handle files for new skills
            if (isNewSkill) {
                const skillVideo = card.querySelector('[name^="skill_video"]');
                const certificate = card.querySelector('[name^="certificate"]');
                const thumbnail = card.querySelector('[name^="thumbnail"]');

                if (skillVideo?.files[0]) {
                    formData.append(`new_skill_videos_${cardId}`, skillVideo.files[0]);
                }
                if (certificate?.files[0]) {
                    formData.append(`new_skill_certs_${cardId}`, certificate.files[0]);
                }
                if (thumbnail?.files[0]) {
                    formData.append(`new_skill_thumbs_${cardId}`, thumbnail.files[0]);
                }
            }

        });

        console.log('PRE-SUBMIT TRACKERS-2:', trackers);

        //------------------------------------------------------------------------------------------
        // Handle intro video
        // const videoIntroInput = document.querySelector('[name="video_intro"]');
        // if (videoIntroInput?.files[0]) {
        //     formData.append('video_intro', videoIntroInput.files[0]);
        // } else if (trackers.introVideo.existed && !trackers.introVideo.removed) {
        //     const existingInput = document.querySelector('input[name="existing_video_intro"]');
        //     if (existingInput) formData.append('existing_video_intro', existingInput.value);
        // }

        // Add intro video tracking
        // formData.append('intro_video_status',
        //     trackers.introVideo.uploaded ? 'uploaded' :
        //         trackers.introVideo.removed ? 'removed' : 'unchanged');
        //------------------------------------------------------------------------------------------

        // Add CSRF token
        const csrfToken = document.querySelector('[name=csrfmiddlewaretoken]')?.value;
        if (csrfToken) formData.append('csrfmiddlewaretoken', csrfToken);

        const response = await Promise.race([
            fetch('/tutor/save-skills/', {
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
            throw new Error(errorData.error || 'Failed to save skills!');
        }

        // Only reset trackers after successful submission
        const result = await response.json();
        if (result.success) {
            showBootstrapAlert2('Your skills saved successfully!', 'success', 5000);
            resetTrackers();
            await loadExistingSkills(); // Refresh the display with new data
        }

        return result;

    } catch (error) {
        clearTimeout(submitTimeout);
        console.error("Submission error:", error);
        return {success: false, error: error.message || 'Failed to save skills'};
    }
}

// Modified submit_skills function with progress tracking
export async function submit_skills2() {
    const formData = new FormData();
    const container = document.getElementById('skills-container');
    if (!container) return {success: false, error: 'Form elements not found'};

    const cards = Array.from(container.querySelectorAll('.skill-card'));

    try {
        // Show progress modal
        uploadProgressModal.show();
        progressBar.style.width = '0%';
        progressText.textContent = 'Preparing upload...';

        // Create new AbortController for this upload
        uploadController = new AbortController();

        // Setup cancel button
        cancelUploadBtn.onclick = () => {
            if (uploadController) {
                uploadController.abort();
            }
            uploadProgressModal.hide();
            showBootstrapAlert2('Upload cancelled', 'warning', 3000);
            return {success: false, error: 'Upload cancelled'};
        };

        console.log('PRE-SUBMIT TRACKERS:', {
            video: trackers.video,
            certificate: trackers.certificate,
            thumbnail: trackers.thumbnail,
            skills: trackers.skills
        });

        // Add tracking data
        formData.append('videos_new', JSON.stringify(trackers.video.uploaded));
        formData.append('videos_changed', JSON.stringify(trackers.video.changed));
        formData.append('videos_removed', JSON.stringify(trackers.video.removed));

        formData.append('certs_new', JSON.stringify(trackers.certificate.uploaded));
        formData.append('certs_changed', JSON.stringify(trackers.certificate.changed));
        formData.append('certs_removed', JSON.stringify(trackers.certificate.removed));

        formData.append('thumbs_new', JSON.stringify(trackers.thumbnail.uploaded));
        formData.append('thumbs_changed', JSON.stringify(trackers.thumbnail.changed));
        formData.append('thumbs_removed', JSON.stringify(trackers.thumbnail.removed));

        formData.append('skills_removed', JSON.stringify(removedSkillIds));
        formData.append('skills_new', JSON.stringify(trackers.skills.new));

        // Process each card
        cards.forEach((card, index) => {
            const cardId = card.dataset.cardId;
            const isNewSkill = trackers.skills.new.includes(cardId);
            const skill = card.querySelector('[name^="skill"]');
            const level = card.querySelector('[name^="level"]');
            const skillVideo = card.querySelector('[name^="skill_video"]');
            const certificate = card.querySelector('[name^="certificate"]');
            const thumbnail = card.querySelector('[name^="thumbnail"]');

            if (!skill || !level) {
                throw new Error(`Missing required fields in row ${index + 1}`);
            }

            // Append skill data
            formData.append(`skills[]`, skill.value);
            formData.append(`levels[]`, level.value);
            formData.append(`skill_ids[]`, cardId);

            // Handle files based on tracker state
            if (skillVideo?.files[0]) {
                formData.append(`skill_videos_${cardId}`, skillVideo.files[0]);
            }
            if (certificate?.files[0]) {
                formData.append(`certificates_${cardId}`, certificate.files[0]);
            }
            if (thumbnail?.files[0]) {
                formData.append(`thumbnails_${cardId}`, thumbnail.files[0]);
            }

            // Handle files for new skills
            if (isNewSkill) {
                if (skillVideo?.files[0]) {
                    formData.append(`new_skill_videos_${cardId}`, skillVideo.files[0]);
                }
                if (certificate?.files[0]) {
                    formData.append(`new_skill_certs_${cardId}`, certificate.files[0]);
                }
                if (thumbnail?.files[0]) {
                    formData.append(`new_skill_thumbs_${cardId}`, thumbnail.files[0]);
                }
            }
        });

        // Add CSRF token
        const csrfToken = document.querySelector('[name=csrfmiddlewaretoken]')?.value;
        if (csrfToken) formData.append('csrfmiddlewaretoken', csrfToken);

        const xhr = new XMLHttpRequest();

        // Set up progress tracking
        xhr.upload.addEventListener('progress', (event) => {
            if (event.lengthComputable) {
                const percentComplete = Math.round((event.loaded * 100) / event.total);
                progressBar.style.width = `${percentComplete}%`;
                progressText.textContent = `Uploading... ${percentComplete}%`;

                if (percentComplete === 100) {
                    progressText.textContent = 'Processing files...';
                }
            }
        });

        const response = await new Promise((resolve, reject) => {
            xhr.onreadystatechange = () => {
                if (xhr.readyState === 4) {
                    if (xhr.status === 200) {
                        try {
                            resolve(JSON.parse(xhr.responseText));
                        } catch (e) {
                            reject(new Error('Invalid server response'));
                        }
                    } else {
                        reject(new Error(xhr.statusText || 'Request failed'));
                    }
                }
            };

            xhr.onerror = () => reject(new Error('Network error'));
            xhr.ontimeout = () => reject(new Error('Request timed out'));
            xhr.open('POST', '/tutor/save-skills/', true);
            xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
            xhr.timeout = 60000; // 60 seconds timeout
            xhr.send(formData);
        });

        uploadProgressModal.hide();

        if (response.success) {
            resetTrackers();
            loadExistingSkills();
            showBootstrapAlert2('Skills saved successfully!', 'success', 5000);
        }

        return response;

    } catch (error) {
        uploadProgressModal.hide();
        if (error.name === 'AbortError') {
            console.log('Upload cancelled by user');
            return {success: false, error: 'Upload cancelled'};
        }
        console.error("Submission error:", error);
        return {success: false, error: error.message || 'Failed to save skills'};
    } finally {
        uploadController = null;
    }
}

export async function submit_skills3() {
    const formData = new FormData();
    const container = document.getElementById('skills-container');
    if (!container) return {success: false, error: 'Form elements not found'};

    const cards = Array.from(container.querySelectorAll('.skill-card'));
    let submitTimeout;
    let showModal = false;

    // Check if we have any files to upload (new or changed)
    const hasFilesToUpload = cards.some(card => {
        const cardId = card.dataset.cardId;
        return (
            trackers.video.uploaded.includes(Number(cardId)) ||
            trackers.video.changed.includes(Number(cardId)) ||
            trackers.certificate.uploaded.includes(Number(cardId)) ||
            trackers.certificate.changed.includes(Number(cardId)) ||
            trackers.thumbnail.uploaded.includes(Number(cardId)) ||
            trackers.thumbnail.changed.includes(Number(cardId))
        );
    });

    try {
        // Only show modal if we actually have files to upload
        if (hasFilesToUpload) {
            uploadProgressModal.show();
            progressBar.style.width = '0%';
            progressText.textContent = 'Preparing upload...';
            showModal = true;
        }

        // Create new AbortController for this upload
        uploadController = new AbortController();

        // Setup cancel button
        cancelUploadBtn.onclick = () => {
            if (uploadController) {
                uploadController.abort();
            }
            uploadProgressModal.hide();
            showBootstrapAlert2('Upload cancelled', 'warning', 3000);
            return {success: false, error: 'Upload cancelled'};
        };

        console.log('PRE-SUBMIT TRACKERS:', trackers);

        // Add tracking data
        formData.append('videos_new', JSON.stringify(trackers.video.uploaded));
        formData.append('videos_changed', JSON.stringify(trackers.video.changed));
        formData.append('videos_removed', JSON.stringify(trackers.video.removed));

        formData.append('certs_new', JSON.stringify(trackers.certificate.uploaded));
        formData.append('certs_changed', JSON.stringify(trackers.certificate.changed));
        formData.append('certs_removed', JSON.stringify(trackers.certificate.removed));

        formData.append('thumbs_new', JSON.stringify(trackers.thumbnail.uploaded));
        formData.append('thumbs_changed', JSON.stringify(trackers.thumbnail.changed));
        formData.append('thumbs_removed', JSON.stringify(trackers.thumbnail.removed));

        formData.append('skills_removed', JSON.stringify(removedSkillIds));
        formData.append('skills_new', JSON.stringify(trackers.skills.new));

        // Process each card
        cards.forEach((card, index) => {
            const cardId = card.dataset.cardId;
            const isNewSkill = trackers.skills.new.includes(cardId);
            const skill = card.querySelector('[name^="skill"]');
            const level = card.querySelector('[name^="level"]');
            const skillVideo = card.querySelector('[name^="skill_video"]');
            const certificate = card.querySelector('[name^="certificate"]');
            const thumbnail = card.querySelector('[name^="thumbnail"]');

            if (!skill || !level) {
                throw new Error(`Missing required fields in row ${index + 1}`);
            }

            // Append skill data
            formData.append(`skills[]`, skill.value);
            formData.append(`levels[]`, level.value);
            formData.append(`skill_ids[]`, cardId);

            // Handle files based on tracker state
            if (skillVideo?.files[0]) {
                formData.append(`skill_videos_${cardId}`, skillVideo.files[0]);
            }
            if (certificate?.files[0]) {
                formData.append(`certificates_${cardId}`, certificate.files[0]);
            }
            if (thumbnail?.files[0]) {
                formData.append(`thumbnails_${cardId}`, thumbnail.files[0]);
            }

            // Handle files for new skills
            if (isNewSkill) {
                if (skillVideo?.files[0]) {
                    formData.append(`new_skill_videos_${cardId}`, skillVideo.files[0]);
                }
                if (certificate?.files[0]) {
                    formData.append(`new_skill_certs_${cardId}`, certificate.files[0]);
                }
                if (thumbnail?.files[0]) {
                    formData.append(`new_skill_thumbs_${cardId}`, thumbnail.files[0]);
                }
            }
        });

        // Add CSRF token
        const csrfToken = document.querySelector('[name=csrfmiddlewaretoken]')?.value;
        if (csrfToken) formData.append('csrfmiddlewaretoken', csrfToken);

        // Set timeout
        const timeoutPromise = new Promise((_, reject) => {
            submitTimeout = setTimeout(() => reject(new Error('Request timed out')), 60000);
        });

        const response = await Promise.race([
            fetch('/tutor/save-skills/', {
                method: 'POST',
                body: formData,
                headers: {'X-Requested-With': 'XMLHttpRequest'},
                signal: uploadController?.signal
            }),
            timeoutPromise
        ]);

        clearTimeout(submitTimeout);

        if (!response.ok) {
            const errorData = await response.json();
            throw new Error(errorData.error || 'Failed to save skills');
        }

        const result = await response.json();

        if (showModal) {
            uploadProgressModal.hide();
        }

        if (result.success) {
            resetTrackers();
            loadExistingSkills();
            showBootstrapAlert2('Skills saved successfully!', 'success', 5000);
        } else {
            showBootstrapAlert2(result.error || 'Failed to save skills', 'danger', 5000);
        }

        return result;

    } catch (error) {
        if (showModal) {
            uploadProgressModal.hide();
        }

        if (error.name === 'AbortError') {
            console.log('Upload cancelled by user');
            showBootstrapAlert2('Upload cancelled', 'warning', 3000);
            return {success: false, error: 'Upload cancelled'};
        }

        console.error("Submission error:", error);
        showBootstrapAlert2(error.message || 'Failed to save skills', 'danger', 5000);
        return {success: false, error: error.message || 'Failed to save skills'};
    } finally {
        uploadController = null;
        clearTimeout(submitTimeout);
    }
}

// Reset trackers after successful submission
function resetTrackers() {
    removedSkillIds = [];
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
function appendHiddenInput(parent, name, value) {
    const input = document.createElement('input');
    input.type = 'hidden';
    input.name = name;
    input.value = value;
    parent.appendChild(input);
}

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
        // Track removal of the current file before user picks new one

        // Trigger input click directly to show file picker
        inputElement.click();

        // Handle change via input event
        inputElement.onchange = () => {
            if (!inputElement.files.length) return;

            // Remove the old file display and process as new upload
            displayDiv.remove();
            updateTracker(type, 'changed', uSkillId);
            // UPDATE CODE!!!!!!!! ----------------------------------------
            let removeInputPrefix;
            if (type === 'video') {
                removeInputPrefix = 'remove_skill_video_';
            } else if (type === 'certificate') {
                removeInputPrefix = 'remove_certificate_';
            } else if (type === 'thumbnail') {
                removeInputPrefix = 'remove_thumbnail_';
            }
            // UPDATE CODE!!!!!!!! ----------------------------------------

            handleFileUploadForCard(type, inputElement, labelElement, card, {
                uSkillId,
                // removeInputPrefix: type === 'video' ? 'remove_skill_video_' : 'remove_certificate_'
                removeInputPrefix
            });
        };
    };

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
function createSkillCard(cardId, options = {}) {
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
        trackers.skills.existed.push(cardId);
    } else {
        trackers.skills.new.push(cardId);
    }

    return card;
}

// UPDATE CODE !!!!!!!!!!!!!!!!-----------------------------------
/**
 * Adds an existing skill card with all its data
 * @param {string} uSkillId - Unique skill ID
 * @param {string} skillId - Skill ID
 * @param {string} levelId - Level ID
 * @param {string|null} video - Video URL if exists
 * @param {string|null} certificate - Certificate URL if exists
 */
function addExistedSkillCard(uSkillId, skillId, levelId, video, certificate, videoThumbnail) {
    const card = createSkillCard(uSkillId, {
        isExisting: true,
        skillId,
        levelId
    });

    if (!card) return;

    container.appendChild(card);

    // Display existing files if present
    const videoInput = card.querySelector('[name^="skill_video"]');
    const certInput = card.querySelector('[name^="certificate"]');
    const thumbnailInput = card.querySelector('[name^="thumbnail"]');
    const videoLabel = card.querySelector('.label_skill_video');
    const certLabel = card.querySelector('.label_skill_certificate');
    const thumbnailLabel = card.querySelector('.label_skill_thumbnail');

    if (video && videoInput && videoLabel) {
        createExistingFileDisplay('video', videoInput, videoLabel, card);
        updateTracker('video', 'existed', uSkillId);
    }

    if (certificate && certInput && certLabel) {
        createExistingFileDisplay('certificate', certInput, certLabel, card);
        updateTracker('certificate', 'existed', uSkillId);
    }
    if (videoThumbnail && thumbnailInput && thumbnailLabel) {
        createExistingFileDisplay('thumbnail', thumbnailInput, thumbnailLabel, card);
        updateTracker('thumbnail', 'existed', uSkillId);
    }

    // Setup file inputs and remove button
    setupFileInputs(card, uSkillId);
    setupRemoveButton(card, uSkillId);

    initTooltips();
}

/**
 * Adds a blank skill card for new skill entry
 * @returns {string|null} The ID of the newly created card
 */
function addBlankSkillCard() {
    if (checkSkillLimit()) return null;

    const cardId = Date.now().toString();
    const card = createSkillCard(cardId);

    if (!card) return null;

    container.appendChild(card);

    // Setup file inputs and remove button
    setupFileInputs(card, cardId);
    setupRemoveButton(card, cardId);

    initTooltips();

    // console.log('New skill added with ID:', cardId);
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
// Modified handleFileUploadForCard to prevent duplicate updates
function handleFileUploadForCard_new(fileType, fileInput, fileLabel, cardElement, options = {}) {

    const file = fileInput.files[0];
    const uSkillId = options.uSkillId || cardElement.dataset.cardId;
    const isNewSkill = options.isNew !== undefined ? options.isNew : trackers.skills.new.includes(uSkillId);

    // Determine the correct action
    const action = isNewSkill ? 'uploaded' :
        trackers[fileType].existed.includes(Number(uSkillId)) ? 'changed' : 'uploaded';

    // Update tracker only once
    updateTracker(fileType, action, uSkillId);

    // Rest of your file display handling code remains the same...
    // [Keep all the existing display creation and event handling code]
}

function handleFileUploadForCard(fileType, fileInput, fileLabel, cardElement, options = {}) {
    if (!fileInput.files || fileInput.files.length === 0) return;

    // ✅ Defensive: check if tracker exists
    const tracker = trackers?.[fileType];
    if (!tracker) {
        console.warn(`Unknown file type tracker: ${fileType}`);
        return;
    }

    const file = fileInput.files[0];
    const fileName = file.name;
    const container = fileInput.parentNode;
    const uSkillId = options.uSkillId || cardElement.dataset.cardId;

    // Determine if this is a new skill
    const isNewSkill = options.isNew !== undefined ? options.isNew : trackers.skills.new.includes(uSkillId);

    // For new skills, always mark as uploaded
    const action = isNewSkill ? 'uploaded' :
        trackers[fileType].existed.includes(Number(uSkillId)) ? 'changed' : 'uploaded';

    // updateTracker(fileType, action, uSkillId, true);
    const iconClass = fileType === 'video' ? 'bi bi-file-earmark-play-fill' : 'bi bi-file-earmark-text-fill';
    // UPDATE CODE!!!!!!!! ----------------------------------------
    // Define removeInputPrefix based on fileType
    // const removeInputPrefix = fileType === 'video'
    //     ? 'remove_skill_video_'
    //     : 'remove_certificate_';

    let removeInputPrefix;
    if (fileType === 'video') {
        removeInputPrefix = 'remove_skill_video_';
    } else if (fileType === 'certificate') {
        removeInputPrefix = 'remove_certificate_';
    } else if (fileType === 'thumbnail') {
        removeInputPrefix = 'remove_thumbnail_';
    }
    // UPDATE CODE!!!!!!!! ----------------------------------------
    const removeFlagName = `${removeInputPrefix}${uSkillId}`;

    updateTracker(fileType, action, uSkillId, true);
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
        console.log(`${fileType}-uploaded: `, tracker.uploaded);

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
            showBootstrapAlert2(`Unsupported file type: ${ext}`, 'danger', 4000);
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

//====================================================================================================

/**
 * Checks if skill limit has been reached
 */
function checkSkillLimit() {
    const alertLimitMessage = document.querySelector('#skillLimitAlert');
    const btnAddSkill = document.getElementById('btnAddSkill');
    if (container.querySelectorAll('.skill-card').length >= maxEntries) {
        if (alertLimitMessage) alertLimitMessage.classList.remove('d-none');
        showBootstrapAlert2(`Maximum ${maxEntries} skills allowed`, 'danger', 5000);
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

function updateTracker_main(type, action, id, logger = true) {
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
function updateTracker(type, action, id, logger = true) {
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

    if (logger) {
        console.log(`Tracker updated - ${type}.${action}:`, numId, trackers[type][action]);
    }
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
document.getElementById('btnAddSkill').addEventListener('click', function () {
    addBlankSkillCard();
});
// --------------------------- Add Blank skill card ---------------------------
// ============================
// INITIALIZATION
// ============================
document.addEventListener('DOMContentLoaded', function () {
    try {
        loadExistingSkills();
        initSelects();
        initTooltips();
    } catch (e) {
        console.error('Initialization error:', e);
    }
    try {
        addBlankSkillCard();
    } catch (e) {
        console.error(e);
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
        videoInput.name = `skill_videos_${cardId}`;
        videoInput.classList.add('skill_video_input');
    }

    if (certInput) {
        certInput.name = `certificates_${cardId}`;
        certInput.classList.add('certificate_input');
    }
    if (thumbnailInput) {
        thumbnailInput.name = `thumbnails_${cardId}`;
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

    removeBtn.addEventListener('click', function () {
        if (!confirm('Are you sure you want to remove this skill?')) return;

        // Handle tracking based on whether this is an existing or new skill
        if (trackers.skills.existed.includes(cardId)) {
            // Existing skill - mark for removal
            updateTracker('video', 'removed', cardId, true);
            updateTracker('certificate', 'removed', cardId, true);
            updateTracker('thumbnail', 'removed', cardId, true);
            updateTracker('skills', 'removed', cardId, true);
            removedSkillIds.push(cardId);
        } else {
            // New skill - just remove from new skills tracker
            trackers.skills.new = trackers.skills.new.filter(id => id !== cardId);
        }

        card.remove();
        checkSkillLimit();
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
