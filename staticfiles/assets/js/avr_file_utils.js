import {showBootstrapAlert2} from "./avr.js";
const validVideoTypes = ['mp4'];
const validCertificateTypes = ['pdf', 'doc', 'docx', 'png', 'jpg', 'jpeg'];

// ==========================================================================================
// HELPER FUNCTIONS
// ==========================================================================================
// Validate file type

export function validateFileType(file, allowedExtensions) {
    if (!file || !file.name) return false;

    const parts = file.name.split('.');
    if (parts.length < 2) return false;

    const extension = parts.pop().toLowerCase();
    return allowedExtensions.includes(extension);
}

/**
 * Checks if skill limit has been reached
 */
export function checkSkillLimit() {
    const btnAddSkill = document.getElementById('btnAddSkill');
    if (container.querySelectorAll('.skill-card').length >= maxSkills) {
        if (alertLimitMessage) alertLimitMessage.classList.remove('d-none');
        showBootstrapAlert2(`Maximum ${maxSkills} skills allowed`, 'danger', 5000);
        btnAddSkill.disabled = true;
        return true; // means limit reached
    } else {
        if (alertLimitMessage) alertLimitMessage.classList.add('d-none');
        btnAddSkill.disabled = false;
        return false; // means we can add more skills yet!
    }
}

// Utility to format file size
export function formatFileSize(bytes) {
    const sizes = ['Bytes', 'KB', 'MB', 'GB'];
    if (bytes === 0) return '0 Byte';
    const i = parseInt(Math.floor(Math.log(bytes) / Math.log(1024)), 10);
    return `${(bytes / Math.pow(1024, i)).toFixed(1)} ${sizes[i]}`;
}

// Utility to get file type icon based on extension
export function getFileTypeIcon(extension) {
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
export function renderFilePreview(file, index, container) {
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


