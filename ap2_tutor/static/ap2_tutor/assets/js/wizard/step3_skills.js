// =============================================
// GLOBAL VARIABLES
// =============================================
const template = document.getElementById('skill-row-template');
const applicantUId = parseInt(document.getElementById('applicantUId').value);
const alertLimitMessage = document.querySelector('#skillLimitAlert');
const container = document.getElementById('skills-container');
const maxSkills = document.getElementById('isVIP').value.toLowerCase() === 'true' ? 5 : 3; // Set max skills limit based on VIP status
console.log('maxSkills: ', maxSkills);
const validVideoTypes = ['mp4'];
const validCertificateTypes = ['pdf', 'doc', 'docx', 'png', 'jpg', 'jpeg'];

// ====== STATE ======
let hasExistingIntroVideo = false;
let errSkills = [];
let errLevels = [];

let removedSkillIds = [];    // Track completely removed skills

// ===== FILE STATE TRACKING =====--------------------------------------------------
let existedSkills = [];
// let existedVideos = [];      // Skills that had videos when loaded
// let existedCertificates = []; // Skills that had certificates when loaded

// ====== FILE TRACKING ======
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
    skills: {
        existed: [],
        removed: [],
        new: []       // Track completely new skills
    },
    introVideo: {
        existed: false,
        uploaded: false,
        removed: false
    }
};

// ====================== EXPORTED FUNCTIONS ======================
// Client-side Step3 Validation
export function validateStep3() {
    console.log(`validate3-trackers: `, trackers);

    const container = document.getElementById('skills-container');
    const rows = container.querySelectorAll('.skill-row');
    const videoIntroInput = document.querySelector('[name="video_intro"]');
    let isValid = true;

    // Reset error tracking
    errSkills = [];
    errLevels = [];

    if (rows.length > maxSkills) {
        showBootstrapAlert(`Maximum ${maxSkills} skills allowed`, 'danger', 5000);
        return false;
    }

    rows.forEach((row, index) => {
        const rowId = row.dataset.rowId;
        const skill = row.querySelector('[name^="skill"]');
        const level = row.querySelector('[name^="level"]');
        const skillVideo = row.querySelector('[name^="skill_video"]');
        const certificate = row.querySelector('[name^="certificate"]');

        const skillName = skill?.options[skill.selectedIndex]?.text || 'Unknown Skill';
        const rowNumber = index + 1;

        // Required fields
        if (!skill?.value) {
            errSkills.push(`Row ${rowNumber}`);
            isValid = false;
        }
        if (!level?.value) {
            errLevels.push(`Row ${rowNumber} (${skillName})`);
            isValid = false;
        }

        // Video file validation
        if (skillVideo?.files[0]) {
            const file = skillVideo.files[0];
            if (!validateFileType(file, validVideoTypes)) {
                showBootstrapAlert(`Invalid video format for row ${rowNumber}. Allowed: ${validVideoTypes.join(', ')}`, 'danger', 5000);
                isValid = false;
            } else {
                const isExisted = trackers.video.existed.includes(rowId);
                const action = isExisted ? 'changed' : 'uploaded';
                updateTracker('video', action, rowId, true);
            }
        }

        // Certificate file validation
        if (certificate?.files[0]) {
            const file = certificate.files[0];
            if (!validateFileType(file, validCertificateTypes)) {
                showBootstrapAlert(`Invalid certificate format for row ${rowNumber}. Allowed: ${validCertificateTypes.join(', ')}`, 'danger', 5000);
                isValid = false;
            } else {
                const isExisted = trackers.certificate.existed.includes(rowId);
                const action = isExisted ? 'changed' : 'uploaded';
                updateTracker('certificate', action, rowId, true);
            }
        }
    });

    // Display collected skill/level errors
    if (errSkills.length > 0) {
        showBootstrapAlert(`Please select a skill for: ${errSkills.join(', ')}`, 'danger', 5000);
    }
    if (errLevels.length > 0) {
        showBootstrapAlert(`Please select a level for: ${errLevels.join(', ')}`, 'danger', 5000);
    }

    // Intro video check
    // if (!hasExistingIntroVideo && !videoIntroInput?.files?.[0]) {
    //     showBootstrapAlert('Introduction video is required', 'danger', 5000);
    //     isValid = false;
    // } else if (videoIntroInput?.files?.[0] && !validateFileType(videoIntroInput.files[0], validVideoTypes)) {
    //     showBootstrapAlert(`Invalid intro video format. Allowed: ${validVideoTypes.join(', ')}`, 'danger', 5000);
    //     isValid = false;
    // }

    // Additional validation for intro video
    if (!trackers.introVideo.existed && !trackers.introVideo.uploaded) {
        showBootstrapAlert('Introduction video is required', 'danger', 5000);
        isValid = false;
    } else if (videoIntroInput?.files?.[0] && !validateFileType(videoIntroInput.files[0], validVideoTypes)) {
        showBootstrapAlert(`Invalid intro video format. Allowed: ${validVideoTypes.join(', ')}`, 'danger', 5000);
        isValid = false;
    }

    return isValid;
}


export async function submitStep3() {
    const formData = new FormData();
    const container = document.getElementById('skills-container');
    if (!container) return {success: false, error: 'Form elements not found'};

    const rows = Array.from(container.querySelectorAll('.skill-row'));
    let submitTimeout;

    try {
        // Set timeout
        const timeoutPromise = new Promise((_, reject) => {
            submitTimeout = setTimeout(() => reject(new Error('Request timed out')), 15000);
        });

        console.log('PRE-SUBMIT TRACKERS:', {
            video: trackers.video,
            certificate: trackers.certificate,
            skills: trackers.skills,
            introVideo: trackers.introVideo
        });

        // Add tracking data
        formData.append('videos_new', JSON.stringify(trackers.video.uploaded));
        formData.append('videos_changed', JSON.stringify(trackers.video.changed));
        formData.append('videos_removed', JSON.stringify(trackers.video.removed));
        formData.append('certs_new', JSON.stringify(trackers.certificate.uploaded));
        formData.append('certs_changed', JSON.stringify(trackers.certificate.changed));
        formData.append('certs_removed', JSON.stringify(trackers.certificate.removed));
        formData.append('skills_removed', JSON.stringify(removedSkillIds));
        formData.append('skills_new', JSON.stringify(trackers.skills.new));

        // Add intro video action
        formData.append('intro_video_action',
            trackers.introVideo.uploaded ? 'uploaded' :
                trackers.introVideo.removed ? 'removed' : 'unchanged');

        // Process each row
        rows.forEach((row, index) => {
            const rowId = row.dataset.rowId;
            const isNewSkill = trackers.skills.new.includes(rowId);
            const skill = row.querySelector('[name^="skill"]');
            const level = row.querySelector('[name^="level"]');
            const skillVideo = row.querySelector('[name^="skill_video"]');
            const certificate = row.querySelector('[name^="certificate"]');

            if (!skill || !level) {
                throw new Error(`Missing required fields in row ${index + 1}`);
            }

            // Append skill data
            formData.append(`skills[]`, skill.value);
            formData.append(`levels[]`, level.value);
            formData.append(`skill_ids[]`, rowId);

            // Handle files based on tracker state
            if (skillVideo?.files[0]) {
                formData.append(`skill_videos_${rowId}`, skillVideo.files[0]);
            }
            if (certificate?.files[0]) {
                formData.append(`certificates_${rowId}`, certificate.files[0]);
            }


            // Handle files for new skills
            if (isNewSkill) {
                const skillVideo = row.querySelector('[name^="skill_video"]');
                const certificate = row.querySelector('[name^="certificate"]');

                if (skillVideo?.files[0]) {
                    formData.append(`new_skill_videos_${rowId}`, skillVideo.files[0]);
                }
                if (certificate?.files[0]) {
                    formData.append(`new_skill_certs_${rowId}`, certificate.files[0]);
                }
            }

        });

        //------------------------------------------------------------------------------------------
        // Handle intro video
        const videoIntroInput = document.querySelector('[name="video_intro"]');
        if (videoIntroInput?.files[0]) {
            formData.append('video_intro', videoIntroInput.files[0]);
        } else if (trackers.introVideo.existed && !trackers.introVideo.removed) {
            const existingInput = document.querySelector('input[name="existing_video_intro"]');
            if (existingInput) formData.append('existing_video_intro', existingInput.value);
        }

        // Add intro video tracking
        formData.append('intro_video_status',
            trackers.introVideo.uploaded ? 'uploaded' :
                trackers.introVideo.removed ? 'removed' : 'unchanged');
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
            const errorData = await response.json();
            throw new Error(errorData.error || 'Failed to save skills');
        }

        // Only reset trackers after successful submission
        const result = await response.json();
        if (result.success) {
            resetTrackers();
            showAllExistedSkills(); // Refresh the display with new data
        }

        return result;

    } catch (error) {
        clearTimeout(submitTimeout);
        console.error("Submission error:", error);
        return {success: false, error: error.message || 'Failed to save skills'};
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

// --------------------------- Add Blank skill row ---------------------------
document.getElementById('btnAddSkill').addEventListener('click', function () {
    if (checkSkillLimit()) return;
    else addBlankSkillRow();
});


// ---------------------------------------------------------------------------
//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
// =============================================
// MAIN FUNCTIONS
// =============================================
function addExistedSkillRow(uSkillId, skillId, levelId, video, certificate, status) {
    if (!template) {
        console.error('Template not found!');
        return;
    }

    const newRow = template.content.cloneNode(true);
    container.appendChild(newRow);
    const addedRow = container.lastElementChild;
    addedRow.classList.add('skill-row');
    addedRow.dataset.rowId = uSkillId;

    // Track this as an existing skill
    trackers.skills.existed.push(uSkillId);

    // Set skill and level values
    const skillSelect = addedRow.querySelector('[name="skill"]');
    const levelSelect = addedRow.querySelector('[name="level"]');
    if (skillSelect) skillSelect.value = skillId;
    if (levelSelect) levelSelect.value = levelId;

    // Initialize Choices.js
    if (typeof Choices !== 'undefined') {
        if (skillSelect) new Choices(skillSelect, {searchEnabled: true, removeItemButton: true, shouldSort: false});
        if (levelSelect) new Choices(levelSelect, {searchEnabled: true, removeItemButton: true, shouldSort: false});
    }

    // Set up file inputs (naming, class, click-to-upload)
    // setupFileInputs(addedRow, uSkillId);
    setupFileInputs(addedRow, uSkillId, uSkillId);


    // Display existing files if present
    const videoInput = addedRow.querySelector('[name^="skill_video"]');
    const certInput = addedRow.querySelector('[name^="certificate"]');
    const videoLabel = addedRow.querySelector('.label_skill_video');
    const certLabel = addedRow.querySelector('.label_skill_certificate');

    if (video && videoInput && videoLabel) {
        createExistingFileDisplay('video', videoInput, videoLabel, addedRow);
    }

    if (certificate && certInput && certLabel) {
        createExistingFileDisplay('certificate', certInput, certLabel, addedRow);
    }

    // Remove button logic
    setupRemoveButton(addedRow, uSkillId);
    // addedRow.querySelector('.remove-skill')?.addEventListener('click', function () {
    //     if (!confirm('Are you sure you want to remove this skill?')) return;
    //     if (uSkillId) removedSkillIds.push(uSkillId);
    //     this.closest('.skill-row').remove();
    //     checkSkillLimit();
    // });

    initTooltips();
}

function setupRemoveButton(row, rowId) {
    console.log('setupRemoveButton');
    row.querySelector('.remove-skill')?.addEventListener('click', function () {
        console.log('setupRemoveButton CLICKED!');

        if (!confirm('Are you sure you want to remove this skill?')) return;

        // If this is an existing skill (not new), add to removed skills
        //Note 1: all files (video/cert) which relates to this row should be mark to delete from storage
        //Note 2: We don't need to track if a rowId was not belong to any existed skill!
        if (trackers.skills.existed.includes(rowId)) {
            updateTracker('video', 'removed', rowId, true);
            updateTracker('certificate', 'removed', rowId, true);
            updateTracker('skills', 'removed', rowId, true);
            removedSkillIds.push(rowId);
        }
        //---------------------------------------------------------------------------------------------

        // If this is a new skill, remove from new skills tracker
        trackers.skills.new = trackers.skills.new.filter(id => id !== rowId);

        // Remove from all file trackers
        // ['video', 'certificate'].forEach(type => {
        //     ['existed', 'uploaded', 'changed'].forEach(action => {
        //         trackers[type][action] = trackers[type][action].filter(id => id !== rowId);
        //     });
        // });
        //---------------------------------------------------------------------------------------------

        this.closest('.skill-row').remove();
        checkSkillLimit();
    });
}


function appendHiddenInput(parent, name, value) {
    const input = document.createElement('input');
    input.type = 'hidden';
    input.name = name;
    input.value = value;
    parent.appendChild(input);
}

function createExistingFileDisplay(type, inputElement, labelElement, row, isIntroVideo = false) {
    const container = inputElement.parentNode;
    const uSkillId = row.dataset.rowId;
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
    label.textContent = type === 'video' ? 'Video uploaded' : 'Certificate uploaded';

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
            handleFileUploadForRow(type, inputElement, labelElement, row, {
                uSkillId,
                removeInputPrefix: type === 'video' ? 'remove_skill_video_' : 'remove_certificate_'
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
        row.appendChild(removeFlag);

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

//--------------================================================================================================
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
    displayDiv.className = 'd-flex align-items-center bg-light rounded p-2 intro-video-display mb-2 col-12';

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
    changeBtn.className = 'btn btn-sm btn-outline-primary me-1';
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

//--------------================================================================================================

function addBlankSkillRow() {
    const newRow = template.content.cloneNode(true);
    const rowId = Date.now().toString(); // Ensure string ID for consistency

    const row = createSkillRow(rowId, newRow);
    setupFileInputs(row, rowId);
    setupRemoveButton(row, rowId);
    container.appendChild(row);

    // Track this as a new skill
    trackers.skills.new.push(rowId);
    console.log('New skill added with ID:', rowId);

    initSelects();
    initTooltips();
    return rowId; // Return the new row ID

}

function createSkillRow(rowId, templateClone) {
    const row = document.createElement('tr');
    row.className = 'skill-row';
    row.innerHTML = templateClone.querySelector('tr').innerHTML;
    row.dataset.rowId = rowId;
    return row;
}

function setupFileInputs(row, rowId, uSkillId = null) {
    const videoInput = row.querySelector('[name^="skill_video"]');
    const certInput = row.querySelector('[name^="certificate"]');
    const videoLabel = row.querySelector('.label_skill_video');
    const certLabel = row.querySelector('.label_skill_certificate');

    if (videoInput) {
        videoInput.name = `skill_videos_${rowId}`;
        videoInput.classList.add('skill_video_input');
    }

    if (certInput) {
        certInput.name = `certificates_${rowId}`;
        certInput.classList.add('certificate_input');
    }

    if (videoInput && videoLabel) {
        videoLabel.addEventListener('click', () => videoInput.click());
        videoInput.addEventListener('change', () => {
            // For new skills, always mark as uploaded
            const isNewSkill = trackers.skills.new.includes(rowId);
            handleFileUploadForRow('video', videoInput, videoLabel, row, {
                uSkillId: rowId,
                isNew: isNewSkill
            });
        });
    }

    if (certInput && certLabel) {
        certLabel.addEventListener('click', () => certInput.click());
        certInput.addEventListener('change', () => {
            // For new skills, always mark as uploaded
            const isNewSkill = trackers.skills.new.includes(rowId);
            handleFileUploadForRow('certificate', certInput, certLabel, row, {
                uSkillId: rowId,
                isNew: isNewSkill
            });
        });
    }
}

// =============================================
// FILE UPLOAD MODULES
// =============================================

function handleFileUploadForRow(fileType, fileInput, fileLabel, rowElement, options = {}) {
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
    const uSkillId = options.uSkillId || rowElement.dataset.rowId;

    // Determine if this is a new skill
    const isNewSkill = options.isNew !== undefined ? options.isNew : trackers.skills.new.includes(uSkillId);

    // For new skills, always mark as uploaded
    const action = isNewSkill ? 'uploaded' :
        trackers[fileType].existed.includes(uSkillId) ? 'changed' : 'uploaded';


    // Determine the action based on tracker state
    // if (isNewSkill) {
    //     action = 'uploaded'; // Always 'uploaded' for new skills
    // } else {
    //     const hadFile = trackers[fileType].existed.includes(uSkillId);
    //     action = hadFile ? 'changed' : 'uploaded';
    // }

    updateTracker(fileType, action, uSkillId, true);


    const iconClass = fileType === 'video' ? 'bi bi-file-earmark-play-fill' : 'bi bi-file-earmark-text-fill';
    // Define removeInputPrefix based on fileType
    const removeInputPrefix = fileType === 'video'
        ? 'remove_skill_video_'
        : 'remove_certificate_';

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

        let removeFlag = rowElement.querySelector(`input[name="${removeFlagName}"]`);
        if (!removeFlag) {
            removeFlag = document.createElement('input');
            removeFlag.type = 'hidden';
            removeFlag.name = removeFlagName;
            removeFlag.value = 'true';
            rowElement.appendChild(removeFlag);
        }
    };

    displayDiv.appendChild(icon);
    displayDiv.appendChild(nameSpan);
    displayDiv.appendChild(removeBtn);

    fileLabel.style.display = 'none';
    fileInput.style.display = 'none';
    container.insertBefore(displayDiv, fileInput.nextSibling);

    // Remove previous remove flag if re-uploading
    rowElement.querySelector(`input[name="${removeFlagName}"]`)?.remove();

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
            showBootstrapAlert(`Unsupported file type: ${ext}`, 'danger', 4000);
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

//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

/**
 * Shows all existing skills from the server
 */
async function showAllExistedSkills() {
    if (!applicantUId) {
        console.error('No applicantUId found!');
        return;
    }

    const url = `/tutor/get-existed-skills/?applicantUId=${applicantUId}`;
    try {
        const response = await fetch(url);
        if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`);

        const data = await response.json();
        console.log('Received data:', data);
        // Process intro video
        handleVideoIntro(data.video_intro);

        // Clear container safely
        while (container.firstChild) {
            container.removeChild(container.firstChild);
        }

        // handleVideoIntro(data.video_intro);

        // Process skills
        if (data.existed_uSkill_list && Array.isArray(data.existed_uSkill_list)) {
            data.existed_uSkill_list.forEach(uSkill => {
                console.log('Processing skill:', uSkill);
                if (uSkill) updateTracker('skills', 'existed', uSkill.uSkillId);
                if (uSkill.video) updateTracker('video', 'existed', uSkill.uSkillId);
                if (uSkill.certificate) updateTracker('certificate', 'existed', uSkill.uSkillId);
                addExistedSkillRow(
                    uSkill.uSkillId,
                    uSkill.skill,
                    uSkill.level,
                    uSkill.video,
                    uSkill.certificate,
                    uSkill.status
                );
            });
            // console.log('existedVideos: ', existedVideos);
            console.log('Videos-existed: ', trackers.video.existed);
            console.log('Certificates-existed: ', trackers.certificate.existed);
        } else {
            console.error('Invalid data format:', data);
        }
    } catch (error) {
        console.error('Error fetching skills:', error);
    }
}

// ==========================================================================================
// HELPER FUNCTIONS
// ==========================================================================================
// Validate file type
function validateFileType(file, allowedExtensions) {
    if (!file || !file.name) return false;

    const parts = file.name.split('.');
    if (parts.length < 2) return false;

    const extension = parts.pop().toLowerCase();
    return allowedExtensions.includes(extension);
}

/**
 * Checks if skill limit has been reached
 */
function checkSkillLimit() {
    const btnAddSkill = document.getElementById('btnAddSkill');
    if (container.querySelectorAll('.skill-row').length >= maxSkills) {
        if (alertLimitMessage) alertLimitMessage.classList.remove('d-none');
        showBootstrapAlert(`Maximum ${maxSkills} skills allowed`, 'danger', 5000);
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

// Optional: Dynamic update helper
function updateTracker_MAIN(type, action, id, logger = false) {
    const tracker = trackers?.[type]?.[action];
    if (!tracker) {
        console.warn(`Unknown tracker type or action: ${type} - ${action}`);
        return;
    }
    if (!tracker.includes(id)) tracker.push(id);
    if (logger) console.log(`${type} - ${action}: `, trackers[type][action]);
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

// =============================================
// INITIALIZATION
// =============================================
// Initialize select2/choices.js
function initSelects() {
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
function initTooltips() {
    if (typeof bootstrap !== 'undefined') {
        document.querySelectorAll('[data-bs-toggle="tooltip"]').forEach(el => {
            // Dispose if already has a tooltip instance
            const tooltipInstance = bootstrap.Tooltip.getInstance(el);
            if (tooltipInstance) tooltipInstance.dispose();

            new bootstrap.Tooltip(el);
        });
    }
}

// --------- Initialize on DOM ready
document.addEventListener('DOMContentLoaded', function () {
    try {
        showAllExistedSkills();
    } catch (e) {
        console.error(e);
    }
    try {
        addBlankSkillRow();
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


// ======================== Generate Review-Step 5 Skills Table ========================
const reviewContainer = document.getElementById('review-skills-container');
const reviewTemplate = document.getElementById('review-row-template');

function generateReviewStepSkills() {
    const reviewContainer = document.getElementById('skillReviewContainer');
    if (!reviewContainer) {
        console.warn('Review container not found');
        return;
    }

    // Clear previous content
    reviewContainer.innerHTML = '';

    const rows = container.querySelectorAll('.skill-row');
    if (!rows.length) {
        console.warn('No skill rows found');
        return;
    }

    rows.forEach(row => {
        const skillSelect = row.querySelector('[name^="skill"]');
        const levelSelect = row.querySelector('[name^="level"]');
        const videoInput = row.querySelector('[name^="skill_video"]');
        const certificateInput = row.querySelector('[name^="certificate"]');

        if (!skillSelect || !levelSelect) {
            console.warn('Required select elements not found');
            return;
        }

        const skillName = skillSelect.options[skillSelect.selectedIndex]?.text || 'Not selected';
        const levelName = levelSelect.options[levelSelect.selectedIndex]?.text || 'Not selected';
        const videoFile = videoInput?.files[0]?.name || 'No file';
        const certFile = certificateInput?.files[0]?.name || 'No file';

        // Clone and populate a row using reviewTemplate
        const reviewTemplate = document.getElementById('reviewTemplate');
        if (!reviewTemplate) {
            console.warn('Review template not found');
            return;
        }

        const newRow = reviewTemplate.content.cloneNode(true);
        const addedRow = newRow.querySelector('.review-row');

        if (addedRow) {
            const skillNameEl = addedRow.querySelector('.review-skill-name');
            const levelNameEl = addedRow.querySelector('.review-level-name');
            const videoFileEl = addedRow.querySelector('.review-video-file');
            const certFileEl = addedRow.querySelector('.review-cert-file');

            if (skillNameEl) skillNameEl.textContent = skillName;
            if (levelNameEl) levelNameEl.textContent = levelName;
            if (videoFileEl && videoFile !== 'No file') videoFileEl.textContent = `Video: ${videoFile}`;
            if (certFileEl && certFile !== 'No file') certFileEl.textContent = `Certificate: ${certFile}`;

            reviewContainer.appendChild(addedRow);
        }
    });
}

container.addEventListener('change', function () {
    // generateReviewStepSkills();
});
// ---------------------------------- ARCHIVED (MAIN) ----------------------------------

//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^