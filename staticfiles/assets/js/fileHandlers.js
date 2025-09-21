import { showBootstrapAlert2 } from '/static/assets/js/avr.js';

// File type validations
export const allowedExtensions = ['pdf', 'jpg', 'jpeg', 'png'];

// =============================================
// FILE HANDLING UTILITIES
// =============================================

/**
 * Validates a file against allowed types
 * @param {File} file - The file to validate
 * @param {string[]} allowedExtensions - Array of allowed extensions (e.g., ['pdf', 'jpg'])
 * @returns {boolean} True if valid, false otherwise
 */
export function validateFileType(file, allowedExtensions) {
    if (!file || !file.name) return false;
    const extension = file.name.split('.').pop().toLowerCase();
    return allowedExtensions.includes(extension);
}

/**
 * Formats file size in human-readable format
 * @param {number} bytes - File size in bytes
 * @returns {string} Formatted size (e.g., "2.5 MB")
 */
export function formatFileSize(bytes) {
    const sizes = ['Bytes', 'KB', 'MB', 'GB'];
    if (bytes === 0) return '0 Byte';
    const i = parseInt(Math.floor(Math.log(bytes) / Math.log(1024)), 10);
    return `${(bytes / Math.pow(1024, i)).toFixed(1)} ${sizes[i]}`;
}

/**
 * Sets up a file input with preview and handling
 * @param {HTMLInputElement} input - The file input element
 * @param {HTMLLabelElement} label - The associated label
 * @param {HTMLElement} container - The container element
 * @param {string} type - Type of file ('education' or 'certification')
 */
export function setupFileInput(input, label, container, type) {
    if (!input || !label) return;

    label.addEventListener('click', () => input.click());

    input.addEventListener('change', () => {
        if (!input.files || input.files.length === 0) return;

        const file = input.files[0];
        const validTypes = type === 'education'
            ? ['pdf', 'jpg', 'jpeg', 'png']
            : ['pdf', 'jpg', 'jpeg', 'png'];

        if (!validateFileType(file, validTypes)) {
            showBootstrapAlert2(`Invalid file type. Allowed: ${validTypes.join(', ')}`, 'danger', 5000);
            input.value = '';
            return;
        }

        createFilePreview(input, label, container, file);
    });
}

/**
 * Creates a file preview display
 * @param {HTMLInputElement} input - The file input element
 * @param {HTMLLabelElement} label - The associated label
 * @param {HTMLElement} container - The container element
 * @param {File} file - The uploaded file
 */
export function createFilePreview(input, label, container, file) {
    // Remove any existing preview
    container.querySelector('.file-preview')?.remove();

    const previewDiv = document.createElement('div');
    previewDiv.className = 'd-flex align-items-center bg-light rounded p-2 file-preview mb-2';

    const icon = document.createElement('i');
    icon.className = 'bi bi-file-earmark-text-fill text-primary me-2';

    const infoDiv = document.createElement('div');
    infoDiv.className = 'd-flex flex-column';

    const nameSpan = document.createElement('span');
    nameSpan.className = 'small';
    nameSpan.textContent = file.name;

    const sizeSpan = document.createElement('span');
    sizeSpan.className = 'text-muted xsmall';
    sizeSpan.textContent = formatFileSize(file.size);

    infoDiv.appendChild(nameSpan);
    infoDiv.appendChild(sizeSpan);

    const removeBtn = document.createElement('button');
    removeBtn.type = 'button';
    removeBtn.className = 'btn btn-sm btn-outline-danger ms-auto';
    removeBtn.innerHTML = '<i class="bi bi-trash"></i>';
    removeBtn.addEventListener('click', () => {
        previewDiv.remove();
        input.value = '';
        label.style.display = 'block';
    });

    previewDiv.appendChild(icon);
    previewDiv.appendChild(infoDiv);
    previewDiv.appendChild(removeBtn);

    container.insertBefore(previewDiv, input);
    label.style.display = 'none';
}
// =============================================
// UI UTILITIES
// =============================================