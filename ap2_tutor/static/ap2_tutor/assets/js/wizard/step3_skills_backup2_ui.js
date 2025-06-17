// =============================================
// GLOBAL VARIABLES
// =============================================
const reviewContainer = document.getElementById('review-skills-container');
const reviewTemplate = document.getElementById('review-row-template');
const template = document.getElementById('skill-row-template');
const applicantUId = parseInt(document.getElementById('applicantUId').value);
const alertLimitMessage = document.querySelector('#skillLimitAlert');
const container = document.getElementById('skills-container');
// Set max skills limit based on VIP status
const maxSkills = parseInt(document.getElementById('isVIP').value.toLowerCase()) === 'true' ? 5 : 3;
const validVideoTypes = ['mp4'];
const validCertificateTypes = ['pdf', 'doc', 'docx', 'png', 'jpg', 'jpeg'];

let hasExistingVideo = false;
let errSkills = [];
let errLevels = [];
let removedSkillIds = []; // Track removed skill IDs


// ====================== EXPORTED FUNCTIONS ======================
// Client-side Step3 Validation
export function validateStep3() {
    const container = document.getElementById('skills-container');
    const rows = container.querySelectorAll('.skill-row');
    const videoIntroInput = document.querySelector('[name="video_intro"]');
    let isValid = true;

    // Reset error tracking
    errSkills = [];
    errLevels = [];

    // Check max skills
    if (rows.length > maxSkills) {
        showBootstrapAlert(`Maximum ${maxSkills} skills allowed`, 'danger', 5000);
        return false;
    }

    // Validate each row
    rows.forEach((row, index) => {
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

        // File type validation
        if (skillVideo?.files[0] && !validateFileType(skillVideo.files[0], validVideoTypes)) {
            showBootstrapAlert(`Invalid video format for row ${rowNumber}. Only ${validVideoTypes.join(', ')} are allowed.`, 'danger', 5000);
            isValid = false;
        }
        if (certificate?.files[0] && !validateFileType(certificate.files[0], validCertificateTypes)) {
            showBootstrapAlert(`Invalid certificate format for row ${rowNumber}`, 'danger', 5000);
            isValid = false;
        }
    });

    if (errSkills.length > 0) {
        showBootstrapAlert(`Please select a skill for: ${errSkills.join(', ')}`, 'danger', 5000);
    }

    if (errLevels.length > 0) {
        showBootstrapAlert(`Please select a level for: ${errLevels.join(', ')}`, 'danger', 5000);
    }

    // Validate video intro
    if (!hasExistingVideo && !videoIntroInput?.files?.[0]) {
        showBootstrapAlert('Introduction video is required', 'danger', 5000);
        isValid = false;
    } else if (videoIntroInput?.files?.[0] && !validateFileType(videoIntroInput.files[0], validVideoTypes)) {
        showBootstrapAlert(`Invalid video format. Only ${validVideoTypes.join(', ')} are allowed.`, 'danger', 5000);
        isValid = false;
    }
    return isValid;
}

export async function submitStep3() {
    const container = document.getElementById('skills-container');
    if (!container) return {success: false, error: 'Form elements not found'};

    const formData = new FormData();
    const rows = Array.from(container.querySelectorAll('.skill-row'));
    let submitTimeout;

    try {
        // Set timeout
        const timeoutPromise = new Promise((_, reject) => {
            submitTimeout = setTimeout(() => reject(new Error('Request timed out')), 15000);
        });

        // Add removed skills
        removedSkillIds.forEach(id => formData.append('removed_skills', id));

        // Process each row
        rows.forEach((row, index) => {
            const skill = row.querySelector('[name^="skill"]');
            const level = row.querySelector('[name^="level"]');
            const skillVideo = row.querySelector('[name^="skill_video"]');
            const certificate = row.querySelector('[name^="certificate"]');
            const existingVideo = row.querySelector('input[name^="existing_video"]');
            const existingCertificate = row.querySelector('input[name^="existing_certificate"]');

            if (!skill || !level) {
                throw new Error(`Missing required fields in row ${index + 1}`);
            }

            // Append skill data with index
            formData.append(`skills[]`, skill.value);
            formData.append(`levels[]`, level.value);

            // Handle video - include existing if no new file uploaded
            if (skillVideo?.files[0]) {
                formData.append(`skill_videos_${index}`, skillVideo.files[0]);
            } else if (existingVideo) {
                formData.append(`existing_videos_${index}`, existingVideo.value);
            }

            // Handle certificate - include existing if no new file uploaded
            if (certificate?.files[0]) {
                formData.append(`certificates_${index}`, certificate.files[0]);
            } else if (existingCertificate) {
                formData.append(`existing_certificates_${index}`, existingCertificate.value);
            }
        });

        // Handle video intro
        const videoIntroInput = document.querySelector('[name="video_intro"]');
        if (videoIntroInput?.files[0]) {
            formData.append('video_intro', videoIntroInput.files[0]);
        } else {
            const existingInput = document.querySelector('input[name="existing_video_intro"]');
            if (existingInput) formData.append('existing_video_intro', existingInput.value);
        }

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
        removedSkillIds = [];
        return await response.json();

    } catch (error) {
        clearTimeout(submitTimeout);
        console.error("Submission error:", error);
        return {success: false, error: error.message || 'Failed to save skills'};
    }
}

// --------------------------- Add Blank skill row ---------------------------
document.getElementById('btnAddSkill').addEventListener('click', function () {
    if (checkSkillLimit()) return;
    else addBlankSkillRow();
});

function addBlankSkillRow1() {
    const newRow = template.content.cloneNode(true);
    const rowId = Date.now();

    // Update IDs and names with unique IDs
    newRow.querySelectorAll('[id], [name]').forEach(el => {
        if (el.id.startsWith('template_')) {
            el.id = el.id.replace('template_', '') + '_' + rowId;
            // console.log('rowId: ', rowId);
        }
        if (el.name) {
            el.name = `${el.name}_${rowId}`;
        }
    });

    // Update label 'for' attributes
    const videoLabel = newRow.querySelector('.label_skill_video');
    const videoInput = newRow.querySelector('[name^="skill_video"]');
    if (videoLabel && videoInput) videoLabel.htmlFor = videoInput.id;

    const certLabel = newRow.querySelector('.label_skill_certificate');
    const certInput = newRow.querySelector('[name^="certificate"]');
    if (certLabel && certInput) certLabel.htmlFor = certInput.id;

    // Add file change handlers
    videoInput?.addEventListener('change', handleVideoUpload);
    certInput?.addEventListener('change', handleCertificateUpload);

    // Add remove handler
    newRow.querySelector('.remove-skill')?.addEventListener('click', function () {
        if (!confirm('Are you sure you want to remove this skill?')) return;

        // Dispose of any tooltips before removal
        const tooltip = bootstrap.Tooltip.getInstance(this);
        if (tooltip) tooltip.dispose();

        this.closest('.skill-row').remove();
        checkSkillLimit();
    });

    container.appendChild(newRow);
    initSelects();
    initTooltips();
}

function addBlankSkillRow2() {
    const newRow = template.content.cloneNode(true);
    const rowId = Date.now();

    // Update IDs and names with unique IDs
    // newRow.querySelectorAll('[id], [name]').forEach(el => {
    //     if (el.id.startsWith('template_')) {
    //         el.id = el.id.replace('template_', '') + '_' + rowId;
    //     }
    //     if (el.name) {
    //         el.name = el.name.replace('template_', '') + '_' + rowId;
    //     }
    // });


    newRow.querySelectorAll('[id], [name]').forEach(el => {
        if (el.id && el.id.includes('template_')) {
            el.id = el.id.replace('template_', '') + '_' + rowId;
        }
        if (el.name && el.name.includes('template_')) {
            el.name = el.name.replace('template_', '') + '_' + rowId;
        }
    });


    // Get elements specific to this row
    const videoInput = newRow.querySelector('[name^="skill_video"]');
    const videoLabel = newRow.querySelector('.label_skill_video');
    const certInput = newRow.querySelector('[name^="certificate"]');
    const certLabel = newRow.querySelector('.label_skill_certificate');

    // Update label 'for' attributes
    if (videoLabel && videoInput) videoLabel.htmlFor = videoInput.id;
    if (certLabel && certInput) certLabel.htmlFor = certInput.id;

    // Add file change handlers with proper scoping
    if (videoInput) {
        videoInput.addEventListener('change', () => {
            handleVideoUpload(videoInput, videoLabel, newRow.querySelector('.skill-row'));
        });
    }

    if (certInput) {
        certInput.addEventListener('change', () => {
            handleCertificateUpload(certInput, certLabel, newRow.querySelector('.skill-row'));
        });
    }

    // Add remove handler
    newRow.querySelector('.remove-skill')?.addEventListener('click', function () {
        if (!confirm('Are you sure you want to remove this skill?')) return;
        this.closest('.skill-row').remove();
        checkSkillLimit();
    });

    container.appendChild(newRow);
    initSelects();
    initTooltips();
}
function addBlankSkillRow() {
    const newRow = template.content.cloneNode(true);
    const rowId = Date.now();
    const rowElement = newRow.querySelector('.skill-row');

    // Update IDs and names with proper scoping
    newRow.querySelectorAll('[id], [name]').forEach(el => {
        if (el.id) el.id = el.id.replace('template_', '') + '_' + rowId;
        if (el.name) el.name = el.name.replace('template_', '') + '_' + rowId;
    });

    // Get elements within this specific row
    const videoInput = newRow.querySelector('[name^="skill_video"]');
    const videoLabel = newRow.querySelector('.label_skill_video');
    const certInput = newRow.querySelector('[name^="certificate"]');
    const certLabel = newRow.querySelector('.label_skill_certificate');

    // Update label associations
    if (videoLabel && videoInput) videoLabel.htmlFor = videoInput.id;
    if (certLabel && certInput) certLabel.htmlFor = certInput.id;

    // Add properly scoped event listeners
    if (videoInput) {
        videoInput.addEventListener('change', function() {
            handleVideoUpload(this, videoLabel, rowElement);
        });
    }

    if (certInput) {
        certInput.addEventListener('change', function() {
            handleCertificateUpload(this, certLabel, rowElement);
        });
    }

    // Remove handler with tooltip cleanup
    newRow.querySelector('.remove-skill')?.addEventListener('click', function() {
        if (!confirm('Are you sure you want to remove this skill?')) return;

        // Proper tooltip disposal
        const tooltip = bootstrap.Tooltip.getInstance(this);
        if (tooltip) tooltip.dispose();

        this.closest('.skill-row').remove();
        checkSkillLimit();
    });

    container.appendChild(newRow);
    initSelects();
    initTooltips();
}
// ---------------------------------------------------------------------------
// =============================================
// FILE UPLOAD MODULES
// =============================================

/**
 * Handles video upload display and management
 * @param {HTMLInputElement} videoInput - The file input element
 * @param {HTMLLabelElement} videoLabel - The upload button/label
 * @param {HTMLElement} row - The containing row element
 * @param {boolean} [isIntroVideo=false] - Whether this is the intro video
 */
function handleVideoUpload(videoInput, videoLabel, row, isIntroVideo = false) {
    if (!videoInput.files || videoInput.files.length === 0) return;

    const file = videoInput.files[0];
    const fileName = file.name;
    const container = videoInput.parentNode;
    const removeFlagName = isIntroVideo ? 'remove_video_intro' : 'remove_skill_video';

    // Clear any existing display
    const existingDisplay = container.querySelector('.video-display');
    if (existingDisplay) existingDisplay.remove();

    // Create new display element
    const displayDiv = document.createElement('div');
    displayDiv.className = 'd-flex align-items-center bg-light rounded p-2 video-display';

    const icon = document.createElement('i');
    icon.className = 'bi bi-file-earmark-play-fill text-success fs-5 me-2';

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
        videoInput.style.display = 'block';
        videoInput.value = '';
        videoLabel.style.display = 'block';
        row.querySelector(`input[name="${removeFlagName}"]`)?.remove();
    };

    displayDiv.appendChild(icon);
    displayDiv.appendChild(nameSpan);
    displayDiv.appendChild(removeBtn);

    // Update UI
    videoLabel.style.display = 'none';
    videoInput.style.display = 'none';
    container.insertBefore(displayDiv, videoInput.nextSibling);

    // Remove any existing removal flag
    row.querySelector(`input[name="${removeFlagName}"]`)?.remove();
    initTooltips();
}

/**
 * Handles certificate upload display and management
 * @param {HTMLInputElement} certInput - The file input element
 * @param {HTMLLabelElement} certLabel - The upload button/label
 * @param {HTMLElement} row - The containing row element
 */
function handleCertificateUpload(certInput, certLabel, row) {
    if (!certInput.files || certInput.files.length === 0) return;

    const file = certInput.files[0];
    const fileName = file.name;
    const container = certInput.parentNode;

    // Clear any existing display
    const existingDisplay = container.querySelector('.cert-display');
    if (existingDisplay) existingDisplay.remove();

    // Create new display element
    const displayDiv = document.createElement('div');
    displayDiv.className = 'd-flex align-items-center bg-light rounded p-2 cert-display';

    const icon = document.createElement('i');
    icon.className = 'bi bi-file-earmark-text-fill text-info fs-5 me-2';

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
        certInput.style.display = 'block';
        certInput.value = '';
        certLabel.style.display = 'block';
        row.querySelector('input[name="remove_certificate"]')?.remove();
    };

    displayDiv.appendChild(icon);
    displayDiv.appendChild(nameSpan);
    displayDiv.appendChild(removeBtn);

    // Update UI
    certLabel.style.display = 'none';
    certInput.style.display = 'none';
    container.insertBefore(displayDiv, certInput.nextSibling);

    // Remove any existing removal flag
    row.querySelector('input[name="remove_certificate"]')?.remove();
    initTooltips();
}

/**
 * Creates display for existing uploaded files
 * @param {string} type - 'video' or 'certificate'
 * @param {HTMLInputElement} inputElement - The file input element
 * @param {HTMLLabelElement} labelElement - The upload button/label
 * @param {HTMLElement} row - The containing row element
 * @param {boolean} [isIntroVideo=false] - Whether this is the intro video
 */
function createExistingFileDisplay(type, inputElement, labelElement, row, isIntroVideo = false) {
    const container = inputElement.parentNode;
    const removeFlagName = isIntroVideo ? 'remove_video_intro' :
        type === 'video' ? 'remove_skill_video' : 'remove_certificate';
    const displayClass = type === 'video' ? 'video-display' : 'cert-display';

    // Clear any existing display
    const existingDisplay = container.querySelector(`.${displayClass}`);
    if (existingDisplay) existingDisplay.remove();

    const displayDiv = document.createElement('div');
    displayDiv.className = `d-flex align-items-center bg-light rounded p-2 ${displayClass}`;

    const icon = document.createElement('i');
    icon.className = type === 'video' ?
        'bi bi-file-earmark-play-fill text-primary fs-5 me-2' :
        'bi bi-file-earmark-text-fill text-info fs-5 me-2';

    const text = document.createElement('span');
    text.className = 'small';
    text.textContent = type === 'video' ? 'Video uploaded' : 'Certificate uploaded';

    const btnGroup = document.createElement('div');
    btnGroup.className = 'btn-group ms-auto';

    const changeBtn = document.createElement('button');
    changeBtn.type = 'button';
    changeBtn.className = 'btn btn-sm btn-outline-primary';
    changeBtn.innerHTML = '<i class="bi bi-pencil-fill"></i>';
    changeBtn.setAttribute('data-bs-toggle', 'tooltip');
    changeBtn.setAttribute('title', 'Change file');
    changeBtn.onclick = () => {
        displayDiv.replaceWith(inputElement);
        inputElement.style.display = 'block';
        labelElement.style.display = 'block';
        row.querySelector(`input[name="${removeFlagName}"]`)?.remove();
    };

    const removeBtn = document.createElement('button');
    removeBtn.type = 'button';
    removeBtn.className = 'btn btn-sm btn-outline-danger';
    removeBtn.innerHTML = '<i class="bi bi-trash-fill"></i>';
    removeBtn.setAttribute('data-bs-toggle', 'tooltip');
    removeBtn.setAttribute('title', 'Remove file');
    removeBtn.onclick = () => {
        const removeFlag = document.createElement('input');
        removeFlag.type = 'hidden';
        removeFlag.name = removeFlagName;
        removeFlag.value = 'true';
        row.appendChild(removeFlag);

        displayDiv.replaceWith(inputElement);
        inputElement.style.display = 'block';
        inputElement.value = '';
        labelElement.style.display = 'block';
    };

    btnGroup.appendChild(changeBtn);
    btnGroup.appendChild(removeBtn);

    displayDiv.appendChild(icon);
    displayDiv.appendChild(text);
    displayDiv.appendChild(btnGroup);

    // Add to DOM
    container.insertBefore(displayDiv, inputElement);
    inputElement.style.display = 'none';
    labelElement.style.display = 'none';

    return displayDiv;
}

// =============================================
// MAIN FUNCTIONS
// =============================================

/**
 * Handles the introduction video section
 * @param {string|null} video_intro - The existing video path if available
 */
function handleVideoIntro(video_intro) {
    const videoIntroInput = document.querySelector('[name="video_intro"]');
    const videoIntroLabel = document.querySelector('label[for="applicant_video_intro"]');

    if (!videoIntroInput || !videoIntroLabel) return;

    // Handle existing video
    if (video_intro) {
        createExistingFileDisplay(
            'video',
            videoIntroInput,
            videoIntroLabel,
            videoIntroInput.closest('#video_intro_container'),
            true
        );

        // Add hidden field for existing video
        const hiddenInput = document.createElement('input');
        hiddenInput.type = 'hidden';
        hiddenInput.name = 'existing_video_intro';
        hiddenInput.value = video_intro;
        videoIntroInput.parentNode.appendChild(hiddenInput);
    }

    // Handle new uploads
    videoIntroInput.addEventListener('change', () => {
        handleVideoUpload(
            videoIntroInput,
            videoIntroLabel,
            videoIntroInput.closest('#video_intro_container'),
            true
        );
    });
}

/**
 * Adds a new skill row with proper file handling
 * @param {string} uSkillId - The unique skill ID
 * @param {string} skillId - The skill ID
 * @param {string} levelId - The level ID
 * @param {string|null} video - Existing video path if available
 * @param {string|null} certificate - Existing certificate path if available
 * @param {string} status - Skill status
 */
function addExistedSkillRow(uSkillId, skillId, levelId, video, certificate, status) {
    if (!template) {
        console.error('Template not found!');
        return;
    }

    const newRow = template.content.cloneNode(true);
    container.appendChild(newRow);
    const addedRow = container.lastElementChild;

    // Set skill and level values
    const skillSelect = addedRow.querySelector('[name="skill"]');
    if (skillSelect) skillSelect.value = skillId;

    const levelSelect = addedRow.querySelector('[name="level"]');
    if (levelSelect) levelSelect.value = levelId;

    // Initialize Choices.js
    if (typeof Choices !== 'undefined') {
        if (skillSelect) new Choices(skillSelect, {searchEnabled: true, removeItemButton: true, shouldSort: false});
        if (levelSelect) new Choices(levelSelect, {searchEnabled: true, removeItemButton: true, shouldSort: false});
    }

    // Get file elements
    const videoInput = addedRow.querySelector('[name="skill_video"]');
    const videoLabel = addedRow.querySelector('.label_skill_video');
    const certInput = addedRow.querySelector('[name="certificate"]');
    const certLabel = addedRow.querySelector('.label_skill_certificate');

    // Handle existing video
    if (video && videoInput && videoLabel) {
        createExistingFileDisplay('video', videoInput, videoLabel, addedRow);
    }

    // Handle existing certificate
    if (certificate && certInput && certLabel) {
        createExistingFileDisplay('certificate', certInput, certLabel, addedRow);
    }

    // Set up event listeners for new uploads
    if (videoInput && videoLabel) {
        videoInput.addEventListener('change', () => {
            handleVideoUpload(videoInput, videoLabel, addedRow);
        });
    }

    if (certInput && certLabel) {
        certInput.addEventListener('change', () => {
            handleCertificateUpload(certInput, certLabel, addedRow);
        });
    }

    // Remove skill handler
    addedRow.querySelector('.remove-skill')?.addEventListener('click', function () {
        if (!confirm('Are you sure you want to remove this skill?')) return;
        if (uSkillId) removedSkillIds.push(uSkillId);
        this.closest('.skill-row').remove();
        checkSkillLimit();
    });

    initTooltips();
}


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

        // Clear container safely
        while (container.firstChild) {
            container.removeChild(container.firstChild);
        }

        handleVideoIntro(data.video_intro);

        // Process skills
        if (data.existed_uSkill_list && Array.isArray(data.existed_uSkill_list)) {
            data.existed_uSkill_list.forEach(uSkill => {
                console.log('Processing skill:', uSkill);
                addExistedSkillRow(
                    uSkill.uSkillId,
                    uSkill.skill,
                    uSkill.level,
                    uSkill.video,
                    uSkill.certificate,
                    uSkill.status
                );
            });
        } else {
            console.error('Invalid data format:', data);
        }
    } catch (error) {
        console.error('Error fetching skills:', error);
    }
}

// =============================================
// INITIALIZATION
// =============================================
// Initialize select2/choices.js
function initSelects() {
    if (typeof Choices !== 'undefined') {
        document.querySelectorAll('.js-choice:not([data-choicejs])').forEach(select => {
            new Choices(select, {
                searchEnabled: true,
                removeItemButton: true,
                classNames: {
                    containerInner: 'choices__inner bg-transparent',
                    listDropdown: 'choices__list--dropdown'
                },
                shouldSort: false
            });
            select.setAttribute('data-choicejs', 'true');
        });
    }
}

/**
 * Initializes tooltips
 */
function initTooltips1() {
    if (typeof bootstrap !== 'undefined') {
        // Clean up existing tooltips first
        document.querySelectorAll('[data-bs-toggle="tooltip"]').forEach(el => {
            const instance = bootstrap.Tooltip.getInstance(el);
            if (instance) instance.dispose();
        });

        // Initialize new tooltips
        document.querySelectorAll('[data-bs-toggle="tooltip"]').forEach(el => {
            new bootstrap.Tooltip(el);
        });
    }
}

function initTooltips() {
    if (typeof bootstrap === 'undefined') return;

    // First dispose all existing tooltips
    document.querySelectorAll('[data-bs-toggle="tooltip"]').forEach(el => {
        const instance = bootstrap.Tooltip.getInstance(el);
        if (instance) instance.dispose();
    });

    // Initialize new ones
    document.querySelectorAll('[data-bs-toggle="tooltip"]').forEach(el => {
        new bootstrap.Tooltip(el, {
            trigger: 'hover focus'
        });
    });
}

// Add this to your DOMContentLoaded handler
document.addEventListener('DOMContentLoaded', function() {
    // Initialize MutationObserver to clean up tooltips when elements are removed
    const observer = new MutationObserver(function(mutations) {
        mutations.forEach(function(mutation) {
            mutation.removedNodes.forEach(function(removedNode) {
                if (removedNode.nodeType === 1) { // Element node
                    const tooltips = removedNode.querySelectorAll('[data-bs-toggle="tooltip"]');
                    tooltips.forEach(el => {
                        const instance = bootstrap.Tooltip.getInstance(el);
                        if (instance) instance.dispose();
                    });
                }
            });
        });
    });

    observer.observe(container, { childList: true, subtree: true });
});

/**
 * Checks if skill limit has been reached
 */
function checkSkillLimit() {
    const btnAddSkill = document.getElementById('btnAddSkill');
    console.log('Im here!!!');
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

// =============================================
// HELPER FUNCTIONS
// =============================================
// Validate file type
function validateFileType(file, allowedExtensions) {
    if (!file || !file.name) return false;
    const extension = file.name.split('.').pop().toLowerCase();
    return allowedExtensions.includes(extension);
}

// ====================== Initialize on DOM ready ======================
document.addEventListener('DOMContentLoaded', function () {
    // handleVideoIntro();

    // Add this to your initialization
    container.addEventListener('change', function (e) {
        if (e.target.matches('[name^="skill_video"]')) {
            const row = e.target.closest('.skill-row');
            const label = row.querySelector('.label_skill_video');
            handleVideoUpload(e.target, label, row);
        }
        if (e.target.matches('[name^="certificate"]')) {
            const row = e.target.closest('.skill-row');
            const label = row.querySelector('.label_skill_certificate');
            handleCertificateUpload(e.target, label, row);
        }
    });

    container.addEventListener('click', function (e) {
        if (e.target.closest('.remove-skill')) {
            if (!confirm('Are you sure you want to remove this skill?')) return;
            const tooltip = bootstrap.Tooltip.getInstance(e.target);
            if (tooltip) tooltip.dispose();
            e.target.closest('.skill-row').remove();
            checkSkillLimit();
        }
    });


    showAllExistedSkills();
    addBlankSkillRow();
    initSelects();
    initTooltips();
});


// --------------------------- Show existed skill rows + intro video ---------------------------

function handleCertificateUpload_1(e) {
    const input = e.target;
    const row = input.closest('.skill-row');
    const label = row.querySelector('.label_skill_certificate');

    if (input.files.length > 0) {
        const fileName = input.files[0].name;
        const displayDiv = document.createElement('div');
        displayDiv.className = 'd-flex align-items-center gap-2 cert-display';

        const removeBtn = document.createElement('button');
        removeBtn.type = 'button';
        removeBtn.className = 'btn btn-sm btn-outline-danger ms-2';
        removeBtn.innerHTML = '<i class="far fa-trash-alt"></i> Remove';
        removeBtn.onclick = () => {
            displayDiv.replaceWith(input);
            input.style.display = 'block';
            input.value = '';
            label?.classList.remove('d-none');
        };

        displayDiv.innerHTML = `<span class="text-success small">${fileName}</span>`;
        displayDiv.appendChild(removeBtn);

        label?.classList.add('d-none');
        input.style.display = 'none';
        input.parentNode.insertBefore(displayDiv, input.nextSibling);
    }
}

function addExistedSkillRow_1(uSkillId, skillId, levelId, video, certificate, status) {
    console.log('Adding row with:', {uSkillId, skillId, levelId, video, certificate, status});

    if (!template) {
        console.error('Template not found!');
        return;
    }

    const newRow = template.content.cloneNode(true);
    container.appendChild(newRow);
    const addedRow = container.lastElementChild;

    // Generate unique IDs for this row
    const rowId = Date.now();
    addedRow.querySelectorAll('[id^="template_"]').forEach(el => {
        el.id = el.id.replace('template_', '') + '_' + rowId;
    });

    // Update label 'for' attributes to match new IDs
    const videoLabel = addedRow.querySelector('.label_skill_video');
    const videoInput = addedRow.querySelector('[name="skill_video"]');
    if (videoLabel && videoInput) {
        videoLabel.htmlFor = videoInput.id;
    }

    const certLabel = addedRow.querySelector('.label_skill_certificate');
    const certInput = addedRow.querySelector('[name="certificate"]');
    if (certLabel && certInput) {
        certLabel.htmlFor = certInput.id;
    }

    // Set skill and level values
    const skillSelect = addedRow.querySelector('[name="skill"]');
    if (skillSelect) skillSelect.value = skillId;

    const levelSelect = addedRow.querySelector('[name="level"]');
    if (levelSelect) levelSelect.value = levelId;

    // Initialize Choices.js
    if (typeof Choices !== 'undefined') {
        if (skillSelect) new Choices(skillSelect, {searchEnabled: true, removeItemButton: true, shouldSort: false});
        if (levelSelect) new Choices(levelSelect, {searchEnabled: true, removeItemButton: true, shouldSort: false});
    }

    // Handle video input
    if (video) {
        // Hide upload button and show file info
        videoLabel?.classList.add('d-none');

        const videoDisplay = document.createElement('div');
        videoDisplay.className = 'd-flex align-items-center gap-2';

        const videoInfo = document.createElement('span');
        videoInfo.className = 'text-secondary small';
        videoInfo.textContent = "Video Uploaded";

        const btnChange = document.createElement('button');
        btnChange.type = 'button';
        btnChange.className = 'btn btn-sm btn-outline-success ms-2 px-2';
        btnChange.innerHTML = '<i class="far fa-edit"></i> Change';
        btnChange.onclick = (e) => {
            // This ensures we're only working with elements in this row
            const row = e.target.closest('.skill-row');
            const rowVideoInput = row.querySelector('[name="skill_video"]');
            const rowVideoLabel = row.querySelector('.label_skill_video');
            const rowVideoDisplay = row.querySelector('.video-display');

            if (rowVideoDisplay) {
                rowVideoDisplay.replaceWith(rowVideoInput);
            }
            rowVideoInput.style.display = 'block';
            rowVideoLabel?.classList.remove('d-none');
        };

        videoDisplay.appendChild(videoInfo);
        videoDisplay.appendChild(btnChange);
        videoDisplay.classList.add('video-display');
        videoInput.parentNode.insertBefore(videoDisplay, videoInput);
        videoInput.style.display = 'none';
    }

    // Handle certificate input
    if (certificate) {
        // Hide upload button and show file info
        certLabel?.classList.add('d-none');

        const certDisplay = document.createElement('div');
        certDisplay.className = 'd-flex align-items-center gap-2';

        const certInfo = document.createElement('span');
        certInfo.className = 'text-secondary small';
        certInfo.textContent = "Certificate Uploaded";

        const btnChange = document.createElement('button');
        btnChange.type = 'button';
        btnChange.className = 'btn btn-sm btn-outline-success ms-2';
        btnChange.innerHTML = '<i class="far fa-edit"></i> Change';
        btnChange.onclick = (e) => {
            const row = e.target.closest('.skill-row');
            const rowCertInput = row.querySelector('[name="certificate"]');
            const rowCertLabel = row.querySelector('.label_skill_certificate');
            const rowCertDisplay = row.querySelector('.cert-display');

            if (rowCertDisplay) {
                rowCertDisplay.replaceWith(rowCertInput);
            }
            rowCertInput.style.display = 'block';
            rowCertLabel?.classList.remove('d-none');
        };

        certDisplay.appendChild(certInfo);
        certDisplay.appendChild(btnChange);
        certDisplay.classList.add('cert-display');
        certInput.parentNode.insertBefore(certDisplay, certInput);
        certInput.style.display = 'none';
    }

    // Handle new file uploads - scoped to this row
    videoInput?.addEventListener('change', function () {
        const row = this.closest('.skill-row');
        const rowVideoLabel = row.querySelector('.label_skill_video');

        if (this.files.length > 0) {
            const fileName = this.files[0].name;
            const displayDiv = document.createElement('div');
            displayDiv.className = 'd-flex align-items-center gap-2 video-display';

            const removeBtn = document.createElement('button');
            removeBtn.type = 'button';
            // removeBtn.className = 'btn btn-sm btn-outline-danger ms-2';
            removeBtn.className = 'btn btn-sm btn-danger-soft btn-round mb-0';
            // removeBtn.innerHTML = '<i class="far fa-trash-alt"></i> Remove';
            removeBtn.innerHTML = '<i class="fas fa-fw fa-times"></i>';

            removeBtn.onclick = () => {
                displayDiv.replaceWith(this);
                this.style.display = 'block';
                this.value = '';
                rowVideoLabel?.classList.remove('d-none');
            };

            displayDiv.innerHTML = `<span class="text-success small">${fileName}</span>`;
            displayDiv.appendChild(removeBtn);

            rowVideoLabel?.classList.add('d-none');
            this.style.display = 'none';
            this.parentNode.insertBefore(displayDiv, this.nextSibling);
        }
    });

    certInput?.addEventListener('change', function () {
        const row = this.closest('.skill-row');
        const rowCertLabel = row.querySelector('.label_skill_certificate');

        if (this.files.length > 0) {
            const fileName = this.files[0].name;
            const displayDiv = document.createElement('div');
            displayDiv.className = 'd-flex align-items-center gap-2 cert-display';

            const removeBtn = document.createElement('button');
            removeBtn.type = 'button';
            removeBtn.className = 'btn btn-sm btn-outline-danger ms-2';
            removeBtn.innerHTML = '<i class="far fa-trash-alt"></i> Remove';
            removeBtn.onclick = () => {
                displayDiv.replaceWith(this);
                this.style.display = 'block';
                this.value = '';
                rowCertLabel?.classList.remove('d-none');
            };

            displayDiv.innerHTML = `<span class="text-success small">${fileName}</span>`;
            displayDiv.appendChild(removeBtn);

            rowCertLabel?.classList.add('d-none');
            this.style.display = 'none';
            this.parentNode.insertBefore(displayDiv, this.nextSibling);
        }
    });

    // Remove skill handler
    addedRow.querySelector('.remove-skill')?.addEventListener('click', function () {
        if (!confirm('Are you sure you want to remove this skill?')) return;
        if (uSkillId) removedSkillIds.push(uSkillId);
        this.closest('.skill-row').remove();
        checkSkillLimit();
    });

    initTooltips();
    // checkSkillLimit();
}

// Initialize video intro display
function handleVideoIntro_MAIN(video_intro) {
    const videoIntroInput = document.querySelector('[name="video_intro"]');
    const videoIntroLabel = document.querySelector('label[for="applicant_video_intro"]');
    if (videoIntroInput && video_intro) {
        hasExistingVideo = true;
        const existingVideoDisplay = document.createElement('div');
        existingVideoDisplay.className = 'd-flex align-items-center gap-2 mb-2';

        const videoInfo = document.createElement('span');
        videoInfo.className = 'text-secondary small';
        // videoInfo.textContent = `Video Exists: ${video_intro.split('/').pop()}`;
        videoInfo.textContent = `Video uploaded`;

        const btnChange = document.createElement('button');
        btnChange.type = 'button';
        btnChange.className = 'btn btn-sm btn-outline-success ms-2';
        btnChange.innerHTML = '<i class="far fa-edit"></i> Change';
        btnChange.onclick = () => {
            existingVideoDisplay.replaceWith(videoIntroInput);
            videoIntroInput.style.display = 'block';
            videoIntroLabel?.classList.remove('d-none');
        };

        existingVideoDisplay.appendChild(videoInfo);
        existingVideoDisplay.appendChild(btnChange);
        videoIntroInput.parentNode.insertBefore(existingVideoDisplay, videoIntroInput);
        videoIntroInput.style.display = 'none';
        videoIntroLabel?.classList.add('d-none');


        // Optional: Add a hidden field to track existing video ------------- CHECK !!!!------------------------
        const hiddenInput = document.createElement('input');
        hiddenInput.type = 'hidden';
        hiddenInput.name = 'existing_video_intro';
        hiddenInput.value = video_intro;
        videoIntroInput.parentNode.appendChild(hiddenInput);
        //-------------------------------------------------------------------------------------------

    }
    // Handle new video intro uploads
    videoIntroInput?.addEventListener('change', function () {
        if (this.files.length > 0) {
            const fileName = this.files[0].name;
            const displayDiv = document.createElement('div');
            displayDiv.className = 'd-flex align-items-center gap-2 mb-2';

            const removeBtn = document.createElement('button');
            removeBtn.type = 'button';
            removeBtn.className = 'btn btn-sm btn-outline-danger ms-2';
            removeBtn.innerHTML = '<i class="far fa-trash-alt"></i> Remove';
            removeBtn.onclick = () => {
                displayDiv.replaceWith(this);
                this.style.display = 'block';
                this.value = '';
                videoIntroLabel?.classList.remove('d-none');
            };

            displayDiv.innerHTML = `<span class="text-success small">${fileName}</span>`;
            displayDiv.appendChild(removeBtn);

            videoIntroLabel?.classList.add('d-none');
            this.style.display = 'none';
            this.parentNode.insertBefore(displayDiv, this.nextSibling);
        }
    });
}

// Extract file upload handlers into separate functions
function handleVideoUpload_1(e) {
    const input = e.target;
    const row = input.closest('.skill-row');
    const label = row.querySelector('.label_skill_video');

    if (input.files.length > 0) {
        const fileName = input.files[0].name;
        const displayDiv = document.createElement('div');
        displayDiv.className = 'd-flex align-items-center gap-2 video-display';

        const removeBtn = document.createElement('button');
        removeBtn.type = 'button';
        removeBtn.className = 'btn btn-sm btn-outline-danger ms-2';
        removeBtn.innerHTML = '<i class="far fa-trash-alt"></i> Remove';
        removeBtn.onclick = () => {
            displayDiv.replaceWith(input);
            input.style.display = 'block';
            input.value = '';
            label?.classList.remove('d-none');
        };

        displayDiv.innerHTML = `<span class="text-success small">${fileName}</span>`;
        displayDiv.appendChild(removeBtn);

        label?.classList.add('d-none');
        input.style.display = 'none';
        input.parentNode.insertBefore(displayDiv, input.nextSibling);
    }
}

function addBlankSkillRow1_moreSimple() {
    const newRow = template.content.cloneNode(true);
    const rowId = Date.now();

    // Update names with unique IDs
    newRow.querySelectorAll('[name]').forEach(el => {
        const originalName = el.name;
        el.name = `${originalName}_${rowId}`;
        el.id = `id_${originalName}_${rowId}`;
    });

    // Add remove handler
    newRow.querySelector('.remove-skill').addEventListener('click', function () {
        this.closest('.skill-row').remove();
        initTooltips();
        checkSkillLimit();
    });

    container.appendChild(newRow);
    initSelects();
    initTooltips();
}


//----------------------------------------------------------------------------------------------
// ======================== Generate Review-Step 5 Skills Table ========================
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

// ---------------------------------------------------------------------------

function addExistedSkillRow_1(uSkillId, skillId, levelId, video, certificate, status) {
    console.log('Adding row with:', {uSkillId, skillId, levelId, video, certificate, status});

    if (!template) {
        console.error('Template not found!');
        return;
    }

    const newRow = template.content.cloneNode(true);
    container.appendChild(newRow);
    const addedRow = container.lastElementChild;

    // Generate unique IDs for this row
    const rowId = Date.now();
    addedRow.querySelectorAll('[id^="template_"]').forEach(el => {
        el.id = el.id.replace('template_', '') + '_' + rowId;
    });

    // Update label 'for' attributes to match new IDs
    const videoLabel = addedRow.querySelector('.label_skill_video');
    const videoInput = addedRow.querySelector('[name="skill_video"]');
    if (videoLabel && videoInput) {
        videoLabel.htmlFor = videoInput.id;
    }

    const certLabel = addedRow.querySelector('.label_skill_certificate');
    const certInput = addedRow.querySelector('[name="certificate"]');
    if (certLabel && certInput) {
        certLabel.htmlFor = certInput.id;
    }

    // Set skill and level values
    const skillSelect = addedRow.querySelector('[name="skill"]');
    if (skillSelect) skillSelect.value = skillId;

    const levelSelect = addedRow.querySelector('[name="level"]');
    if (levelSelect) levelSelect.value = levelId;

    // Initialize Choices.js
    if (typeof Choices !== 'undefined') {
        if (skillSelect) new Choices(skillSelect, {searchEnabled: true, removeItemButton: true, shouldSort: false});
        if (levelSelect) new Choices(levelSelect, {searchEnabled: true, removeItemButton: true, shouldSort: false});
    }

    // Handle video input
    if (video) {
        // Hide upload button and show file info
        videoLabel?.classList.add('d-none');

        const videoDisplay = document.createElement('div');
        videoDisplay.className = 'd-flex align-items-center gap-2';

        const videoInfo = document.createElement('span');
        videoInfo.className = 'text-secondary small';
        videoInfo.textContent = "Video Uploaded";

        const btnChange = document.createElement('button');
        btnChange.type = 'button';
        btnChange.className = 'btn btn-sm btn-outline-success ms-2 px-2';
        btnChange.innerHTML = '<i class="far fa-edit"></i> Change';
        btnChange.onclick = (e) => {
            // This ensures we're only working with elements in this row
            const row = e.target.closest('.skill-row');
            const rowVideoInput = row.querySelector('[name="skill_video"]');
            const rowVideoLabel = row.querySelector('.label_skill_video');
            const rowVideoDisplay = row.querySelector('.video-display');

            if (rowVideoDisplay) {
                rowVideoDisplay.replaceWith(rowVideoInput);
            }
            rowVideoInput.style.display = 'block';
            rowVideoLabel?.classList.remove('d-none');
        };

        videoDisplay.appendChild(videoInfo);
        videoDisplay.appendChild(btnChange);
        videoDisplay.classList.add('video-display');
        videoInput.parentNode.insertBefore(videoDisplay, videoInput);
        videoInput.style.display = 'none';
    }

    // Handle certificate input
    if (certificate) {
        // Hide upload button and show file info
        certLabel?.classList.add('d-none');

        const certDisplay = document.createElement('div');
        certDisplay.className = 'd-flex align-items-center gap-2';

        const certInfo = document.createElement('span');
        certInfo.className = 'text-secondary small';
        certInfo.textContent = "Certificate Uploaded";

        const btnChange = document.createElement('button');
        btnChange.type = 'button';
        btnChange.className = 'btn btn-sm btn-outline-success ms-2';
        btnChange.innerHTML = '<i class="far fa-edit"></i> Change';
        btnChange.onclick = (e) => {
            const row = e.target.closest('.skill-row');
            const rowCertInput = row.querySelector('[name="certificate"]');
            const rowCertLabel = row.querySelector('.label_skill_certificate');
            const rowCertDisplay = row.querySelector('.cert-display');

            if (rowCertDisplay) {
                rowCertDisplay.replaceWith(rowCertInput);
            }
            rowCertInput.style.display = 'block';
            rowCertLabel?.classList.remove('d-none');
        };

        certDisplay.appendChild(certInfo);
        certDisplay.appendChild(btnChange);
        certDisplay.classList.add('cert-display');
        certInput.parentNode.insertBefore(certDisplay, certInput);
        certInput.style.display = 'none';
    }

    // Handle new file uploads - scoped to this row
    videoInput?.addEventListener('change', function () {
        const row = this.closest('.skill-row');
        const rowVideoLabel = row.querySelector('.label_skill_video');

        if (this.files.length > 0) {
            const fileName = this.files[0].name;
            const displayDiv = document.createElement('div');
            displayDiv.className = 'd-flex align-items-center gap-2 video-display';

            const removeBtn = document.createElement('button');
            removeBtn.type = 'button';
            // removeBtn.className = 'btn btn-sm btn-outline-danger ms-2';
            removeBtn.className = 'btn btn-sm btn-danger-soft btn-round mb-0';
            // removeBtn.innerHTML = '<i class="far fa-trash-alt"></i> Remove';
            removeBtn.innerHTML = '<i class="fas fa-fw fa-times"></i>';

            removeBtn.onclick = () => {
                displayDiv.replaceWith(this);
                this.style.display = 'block';
                this.value = '';
                rowVideoLabel?.classList.remove('d-none');
            };

            displayDiv.innerHTML = `<span class="text-success small">${fileName}</span>`;
            displayDiv.appendChild(removeBtn);

            rowVideoLabel?.classList.add('d-none');
            this.style.display = 'none';
            this.parentNode.insertBefore(displayDiv, this.nextSibling);
        }
    });

    certInput?.addEventListener('change', function () {
        const row = this.closest('.skill-row');
        const rowCertLabel = row.querySelector('.label_skill_certificate');

        if (this.files.length > 0) {
            const fileName = this.files[0].name;
            const displayDiv = document.createElement('div');
            displayDiv.className = 'd-flex align-items-center gap-2 cert-display';

            const removeBtn = document.createElement('button');
            removeBtn.type = 'button';
            removeBtn.className = 'btn btn-sm btn-outline-danger ms-2';
            removeBtn.innerHTML = '<i class="far fa-trash-alt"></i> Remove';
            removeBtn.onclick = () => {
                displayDiv.replaceWith(this);
                this.style.display = 'block';
                this.value = '';
                rowCertLabel?.classList.remove('d-none');
            };

            displayDiv.innerHTML = `<span class="text-success small">${fileName}</span>`;
            displayDiv.appendChild(removeBtn);

            rowCertLabel?.classList.add('d-none');
            this.style.display = 'none';
            this.parentNode.insertBefore(displayDiv, this.nextSibling);
        }
    });

    // Remove skill handler
    addedRow.querySelector('.remove-skill')?.addEventListener('click', function () {
        if (!confirm('Are you sure you want to remove this skill?')) return;
        if (uSkillId) removedSkillIds.push(uSkillId);
        this.closest('.skill-row').remove();
        checkSkillLimit();
    });

    initTooltips();
    // checkSkillLimit();
}

// Initialize video intro display
function handleVideoIntro_MAIN(video_intro) {
    const videoIntroInput = document.querySelector('[name="video_intro"]');
    const videoIntroLabel = document.querySelector('label[for="applicant_video_intro"]');
    if (videoIntroInput && video_intro) {
        hasExistingVideo = true;
        const existingVideoDisplay = document.createElement('div');
        existingVideoDisplay.className = 'd-flex align-items-center gap-2 mb-2';

        const videoInfo = document.createElement('span');
        videoInfo.className = 'text-secondary small';
        // videoInfo.textContent = `Video Exists: ${video_intro.split('/').pop()}`;
        videoInfo.textContent = `Video uploaded`;

        const btnChange = document.createElement('button');
        btnChange.type = 'button';
        btnChange.className = 'btn btn-sm btn-outline-success ms-2';
        btnChange.innerHTML = '<i class="far fa-edit"></i> Change';
        btnChange.onclick = () => {
            existingVideoDisplay.replaceWith(videoIntroInput);
            videoIntroInput.style.display = 'block';
            videoIntroLabel?.classList.remove('d-none');
        };

        existingVideoDisplay.appendChild(videoInfo);
        existingVideoDisplay.appendChild(btnChange);
        videoIntroInput.parentNode.insertBefore(existingVideoDisplay, videoIntroInput);
        videoIntroInput.style.display = 'none';
        videoIntroLabel?.classList.add('d-none');


        // Optional: Add a hidden field to track existing video ------------- CHECK !!!!------------------------
        const hiddenInput = document.createElement('input');
        hiddenInput.type = 'hidden';
        hiddenInput.name = 'existing_video_intro';
        hiddenInput.value = video_intro;
        videoIntroInput.parentNode.appendChild(hiddenInput);
        //-------------------------------------------------------------------------------------------

    }
    // Handle new video intro uploads
    videoIntroInput?.addEventListener('change', function () {
        if (this.files.length > 0) {
            const fileName = this.files[0].name;
            const displayDiv = document.createElement('div');
            displayDiv.className = 'd-flex align-items-center gap-2 mb-2';

            const removeBtn = document.createElement('button');
            removeBtn.type = 'button';
            removeBtn.className = 'btn btn-sm btn-outline-danger ms-2';
            removeBtn.innerHTML = '<i class="far fa-trash-alt"></i> Remove';
            removeBtn.onclick = () => {
                displayDiv.replaceWith(this);
                this.style.display = 'block';
                this.value = '';
                videoIntroLabel?.classList.remove('d-none');
            };

            displayDiv.innerHTML = `<span class="text-success small">${fileName}</span>`;
            displayDiv.appendChild(removeBtn);

            videoIntroLabel?.classList.add('d-none');
            this.style.display = 'none';
            this.parentNode.insertBefore(displayDiv, this.nextSibling);
        }
    });
}

// --------------------------- Show existed skill rows + intro video ---------------------------

function handleCertificateUpload_1(e) {
    const input = e.target;
    const row = input.closest('.skill-row');
    const label = row.querySelector('.label_skill_certificate');

    if (input.files.length > 0) {
        const fileName = input.files[0].name;
        const displayDiv = document.createElement('div');
        displayDiv.className = 'd-flex align-items-center gap-2 cert-display';

        const removeBtn = document.createElement('button');
        removeBtn.type = 'button';
        removeBtn.className = 'btn btn-sm btn-outline-danger ms-2';
        removeBtn.innerHTML = '<i class="far fa-trash-alt"></i> Remove';
        removeBtn.onclick = () => {
            displayDiv.replaceWith(input);
            input.style.display = 'block';
            input.value = '';
            label?.classList.remove('d-none');
        };

        displayDiv.innerHTML = `<span class="text-success small">${fileName}</span>`;
        displayDiv.appendChild(removeBtn);

        label?.classList.add('d-none');
        input.style.display = 'none';
        input.parentNode.insertBefore(displayDiv, input.nextSibling);
    }
}

//----------------------------------------------------------------------------------------------
