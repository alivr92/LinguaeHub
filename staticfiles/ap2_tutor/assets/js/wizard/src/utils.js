export function showBootstrapAlert2(message, type = 'success', duration = 3000) {
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

export function showBootstrapAlert(message, type = 'success', duration = 3000) {
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

// ============================
// UPLOAD PROGRESS MODAL MODULE
// ============================
export class UploadProgressModal {
    constructor(options = {}) {
        this.options = {
            modalId: 'uploadProgressModal',
            progressBarId: 'uploadProgressBar',
            progressTextId: 'uploadProgressText',
            cancelButtonId: 'cancelUploadBtn',
            titleId: 'uploadModalTitle',
            ...options
        };

        this.modalElement = document.getElementById(this.options.modalId);
        this.progressBar = document.getElementById(this.options.progressBarId);
        this.progressText = document.getElementById(this.options.progressTextId);
        this.cancelButton = document.getElementById(this.options.cancelButtonId);
        this.titleElement = document.getElementById(this.options.titleId);

        if (!this.modalElement) {
            console.error('Upload progress modal element not found!');
            return;
        }

        this.modal = new bootstrap.Modal(this.modalElement);
        this.isVisible = false;
        this.currentXHR = null;

        this.init();
    }

    init() {
        // Set up cancel button
        if (this.cancelButton) {
            this.cancelButton.addEventListener('click', () => {
                this.cancelUpload();
            });
        }

        // Clean up on modal hide
        this.modalElement.addEventListener('hidden.bs.modal', () => {
            this.isVisible = false;
            this.currentXHR = null;
        });
    }

    show(title = 'Uploading Files') {
        if (this.titleElement) {
            this.titleElement.textContent = title;
        }

        this.setProgress(0, 'Preparing upload... 0%');
        this.modal.show();
        this.isVisible = true;
    }

    hide() {
        if (this.isVisible) {
            this.modal.hide();
            this.isVisible = false;
        }
    }

    setProgress(percent, text) {
        if (this.progressBar) {
            this.progressBar.style.width = `${percent}%`;
            this.progressBar.setAttribute('aria-valuenow', percent);
        }

        if (this.progressText) {
            this.progressText.textContent = text;
        }
    }

    updateProgress(event) {
        if (event.lengthComputable) {
            const percent = Math.round((event.loaded / event.total) * 100);
            const text = `Uploading: ${percent}% complete (${this.formatFileSize(event.loaded)} / ${this.formatFileSize(event.total)})`;
            this.setProgress(percent, text);
        }
    }

    cancelUpload() {
        if (this.currentXHR) {
            this.currentXHR.abort();
        }
        this.hide();
    }

    setCurrentXHR(xhr) {
        this.currentXHR = xhr;
    }

    formatFileSize(bytes) {
        const sizes = ['Bytes', 'KB', 'MB', 'GB'];
        if (bytes === 0) return '0 Byte';
        const i = parseInt(Math.floor(Math.log(bytes) / Math.log(1024)), 10);
        return `${(bytes / Math.pow(1024, i)).toFixed(1)} ${sizes[i]}`;
    }

    // Main method to handle file upload with progress
    async uploadFiles(formData, url, options = {}) {
        const {
            method = 'POST',
            headers = {},
            timeout = 15000,
            onSuccess = null,
            onError = null,
            onProgress = null,
            title = 'Uploading Files'
        } = options;

        return new Promise((resolve, reject) => {
            const xhr = new XMLHttpRequest();
            this.setCurrentXHR(xhr);

            // Show modal
            this.show(title);

            xhr.open(method, url, true);

            // Set headers
            Object.entries(headers).forEach(([key, value]) => {
                xhr.setRequestHeader(key, value);
            });

            xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');

            // Progress tracking
            xhr.upload.onprogress = (event) => {
                this.updateProgress(event);
                if (onProgress) onProgress(event);
            };

            // Completion
            xhr.onload = () => {
                this.hide();
                try {
                    const response = xhr.responseText ? JSON.parse(xhr.responseText) : {};

                    if (xhr.status >= 200 && xhr.status < 300) {
                        if (onSuccess) onSuccess(response);
                        resolve(response);
                    } else {
                        // Handle 4xx and 5xx errors that return JSON responses
                        const error = new Error(response.error || response.message || `HTTP error: ${xhr.status}`);
                        error.response = response;
                        error.status = xhr.status;

                        if (onError) onError(error);
                        reject(error);
                    }
                } catch (e) {
                    // Handle non-JSON responses or parsing errors
                    const error = new Error(xhr.status >= 400 ? `HTTP error: ${xhr.status}` : 'Invalid server response');
                    error.status = xhr.status;

                    if (onError) onError(error);
                    reject(error);
                }
            };

            // Error handling
            xhr.onerror = () => {
                this.hide();
                const error = new Error('Network error during upload');
                if (onError) onError(error);
                reject(error);
            };

            xhr.onabort = () => {
                this.hide();
                const error = new Error('Upload cancelled');
                if (onError) onError(error);
                reject(error);
            };

            xhr.timeout = timeout;
            xhr.ontimeout = () => {
                this.hide();
                const error = new Error('Request timed out');
                if (onError) onError(error);
                reject(error);
            };

            xhr.send(formData);
        });
    }
}

const AlertManager = (function () {
    // Configuration
    const config = {
        maxAlerts: 3,
        defaultDuration: {
            error: 10000,
            warning: 6000,
            success: 4000,
            info: 5000
        },
        icons: {
            error: '<i class="bi bi-x-octagon-fill me-2 fs-5"></i>',
            warning: '<i class="bi bi-exclamation-triangle-fill me-2 fs-5 text-warning"></i>',
            success: '<i class="bi bi-check-circle-fill me-2 fs-5 text-success"></i>',
            info: '<i class="bi bi-info-circle-fill me-2 fs-5 text-primary"></i>'
        },
        styles: {
            error: 'background-color: #f8d7da; border-color: #f5c2c7; color: #842029;',
            warning: 'background-color: #fff3cd; border-color: #ffecb5; color: #664d03;',
            success: 'background-color: #d1e7dd; border-color: #badbcc; color: #0f5132;',
            info: 'background-color: #cfe2ff; border-color: #b6d4fe; color: #084298;'
        },
        positions: {
            desktop: {
                default: 'top-0 start-50 translate-middle-x',
                top: 'top-0 start-50 translate-middle-x',
                bottom: 'bottom-0 start-50 translate-middle-x',
                'top-left': 'top-0 start-0',
                'top-right': 'top-0 end-0',
                'bottom-left': 'bottom-0 start-0',
                'bottom-right': 'bottom-0 end-0',
                'center': 'top-50 start-50 translate-middle'
            },
            mobile: {
                default: 'top-0 start-0',
                top: 'top-0 start-0',
                bottom: 'bottom-0 start-0',
                'top-left': 'top-0 start-0',
                'top-right': 'top-0 end-0',
                'bottom-left': 'bottom-0 start-0',
                'bottom-right': 'bottom-0 end-0'
            }
        }
    };

    // State
    let activeAlerts = new Set();
    let containers = new Map();

    // DOM Elements
    function getOrCreateContainer(position = 'default') {
        if (containers.has(position)) {
            return containers.get(position);
        }

        const container = document.createElement('div');
        const isDesktop = window.innerWidth > 768;
        const positionConfig = isDesktop ? config.positions.desktop : config.positions.mobile;
        const positionClasses = positionConfig[position] || positionConfig.default;

        container.className = `alert-container position-fixed p-3 ${positionClasses}`;
        container.style.zIndex = '9999';
        container.style.maxWidth = '400px';
        container.style.overflowY = 'auto';
        container.style.maxHeight = '100vh';

        document.body.appendChild(container);
        containers.set(position, container);

        return container;
    }

    // Core Functions
    function show(message, type = 'info', options = {}) {
        const alertKey = `${type}-${message}-${options.position || 'default'}`;
        if (activeAlerts.has(alertKey)) return;

        const {
            duration = config.defaultDuration[type] || 3000,
            dismissible = true,
            scrollTo = false,
            highlightSelector = null,
            position = 'default',
        } = options;

        const alertElement = createAlertElement(message, type, dismissible);
        displayAlert(alertElement, position);
        activeAlerts.add(alertKey);

        setupDismissal(alertElement, alertKey, duration, dismissible);
        handleAdditionalOptions(alertElement, scrollTo, highlightSelector);
    }

    //----------------------------------------------------------------------------------------
    function confirm(message, options = {}) {
        return new Promise((resolve) => {
            const alertKey = `confirm-${message}`;
            if (activeAlerts.has(alertKey)) return;

            const {
                confirmText = 'Confirm',
                cancelText = 'Cancel',
                position = 'center',
                type = 'warning'
            } = options;

            const alertElement = document.createElement('div');
            alertElement.className = `alert alert-${type} alert-dismissible fade show mb-2 shadow`;
            alertElement.style.cssText = `
            width: 100%;
            transition: opacity 0.5s ease;
            ${config.styles[type] || ''}
            border-left: 4px solid ${getBorderColor(type)};
            opacity: 1;
        `;

            alertElement.innerHTML = `
            <div class="d-flex flex-column">
                <div class="d-flex align-items-center mb-3">
                    ${config.icons[type] || ''}
                    <div class="flex-grow-1">${message}</div>
                </div>
                <div class="d-flex justify-content-end gap-2">
                    <button class="btn btn-sm btn-outline-secondary cancel-btn">${cancelText}</button>
                    <button class="btn btn-sm btn-${type} confirm-btn">${confirmText}</button>
                </div>
            </div>
        `;

            const container = getOrCreateContainer(position);
            container.prepend(alertElement);
            activeAlerts.add(alertKey);

            const confirmBtn = alertElement.querySelector('.confirm-btn');
            const cancelBtn = alertElement.querySelector('.cancel-btn');

            const cleanup = () => {
                alertElement.style.opacity = '0';
                setTimeout(() => {
                    alertElement.remove();
                    activeAlerts.delete(alertKey);
                }, 500);
            };

            confirmBtn.addEventListener('click', () => {
                cleanup();
                resolve(true);
            });

            cancelBtn.addEventListener('click', () => {
                cleanup();
                resolve(false);
            });
        });
    }

    //----------------------------------------------------------------------------------------


    function displayAlert(alertElement, position = 'default') {
        const container = getOrCreateContainer(position);
        container.prepend(alertElement);
    }

    function createAlertElement(message, type, dismissible) {
        const alertDiv = document.createElement('div');
        alertDiv.className = `alert alert-${type} alert-dismissible fade show mb-2 shadow`;
        alertDiv.style.cssText = `
            width: 100%;
            transition: opacity 0.5s ease;
            ${config.styles[type] || ''}
            border-left: 4px solid ${getBorderColor(type)};
            opacity: 1;
        `;

        alertDiv.innerHTML = `
            <div class="d-flex align-items-center">
                ${config.icons[type] || ''}
                <div class="flex-grow-1">${message}</div>
                ${dismissible ? '<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>' : ''}
            </div>
        `;
        return alertDiv;
    }

    function getBorderColor(type) {
        const colors = {
            error: '#dc3545',
            warning: '#ffc107',
            success: '#198754',
            info: '#0dcaf0'
        };
        return colors[type] || '#6c757d';
    }

    function setupDismissal(alertElement, alertKey, duration, dismissible) {
        let dismissTimeout;

        if (duration) {
            dismissTimeout = setTimeout(() => {
                dismissAlert(alertElement, alertKey);
            }, duration);
        }

        if (dismissible) {
            const closeBtn = alertElement.querySelector('.btn-close');
            closeBtn?.addEventListener('click', () => {
                clearTimeout(dismissTimeout);
                dismissAlert(alertElement, alertKey);
            });
        }
    }

    function handleAdditionalOptions(alertElement, scrollTo, highlightSelector) {
        if (scrollTo) {
            setTimeout(() => {
                alertElement.scrollIntoView({behavior: 'smooth', block: 'nearest'});
            }, 100);
        }

        if (highlightSelector) {
            highlightField(highlightSelector);
        }
    }

    function dismissAlert(alertElement, alertKey) {
        alertElement.style.opacity = '0';
        setTimeout(() => {
            alertElement.remove();
            activeAlerts.delete(alertKey);

            // Clean up container if it's empty
            const container = alertElement.parentElement;
            if (container && container.children.length === 0) {
                container.remove();
                containers.delete(Array.from(containers.entries())
                    .find(([_, c]) => c === container)?.[0]);
            }
        }, 500);
    }

    function highlightField(selector) {
        const elements = document.querySelectorAll(selector);
        elements.forEach(el => {
            el.classList.add('is-invalid');
            setTimeout(() => {
                el.scrollIntoView({behavior: 'smooth', block: 'nearest'});
            }, 300);

            setTimeout(() => {
                el.classList.remove('is-invalid');
            }, 5000);
        });
    }

    function showWizardErrors(errors) {
        clearAll();

        if (errors.length > 0) {
            // Show first error with scroll
            show(
                errors[0].message,
                'error',
                {
                    duration: 10000,
                    scrollTo: true,
                    highlightSelector: errors[0].selector
                }
            );

            // Show remaining errors without scroll
            for (let i = 1; i < errors.length; i++) {
                show(
                    errors[i].message,
                    'error',
                    {
                        duration: 8000,
                        highlightSelector: errors[i].selector
                    }
                );
            }
        }
    }

    function clearAll() {
        containers.forEach(container => {
            container.remove();
        });
        containers.clear();
        activeAlerts.clear();
    }

    function handleResize() {
        containers.forEach((container, position) => {
            const isDesktop = window.innerWidth > 768;
            const positionConfig = isDesktop ? config.positions.desktop : config.positions.mobile;
            const positionClasses = positionConfig[position] || positionConfig.default;

            // Clear position classes and reapply
            container.className = container.className.replace(/(top|bottom|start|end|translate)-\S+/g, '');
            container.classList.add(...positionClasses.split(' '));
        });
    }

    // Initialize
    window.addEventListener('resize', handleResize);

    return {
        show,
        showWizardErrors,
        confirm,
        clearAll,
    };
})();

export const showAlert = AlertManager.show;
export const showWizardErrors = AlertManager.showWizardErrors;
export const clearAlerts = AlertManager.clearAll;
export const showConfirm = AlertManager.confirm;
// Create a default instance
export const uploadProgressModal = new UploadProgressModal();
// ------------ These examples now appear in different positions simultaneously ---------
// --------------------------------------------------------------------------------------
//  showAlert('Top left message', 'warning', { position: 'top-left' });                 |
//  showAlert('Bottom right message', 'error', { position: 'bottom-right' });           |
//  Center and bottom messages                                                          |
//  showAlert('Center message', 'info', { position: 'center' });                        |
//  showAlert('Bottom message', 'success', { position: 'bottom' });                     |
// --------------------------------------------------------------------------------------

// Add this function to create progress bars
export function createProgressBar(parentElement) {
    const progressDiv = document.createElement('div');
    progressDiv.className = 'progress mt-2';
    progressDiv.style.height = '20px';

    const progressBar = document.createElement('div');
    progressBar.className = 'progress-bar progress-bar-striped progress-bar-animated';
    progressBar.style.width = '0%';
    progressBar.setAttribute('aria-valuenow', '0');
    progressBar.setAttribute('aria-valuemin', '0');
    progressBar.setAttribute('aria-valuemax', '100');

    const progressText = document.createElement('small');
    progressText.className = 'progress-text text-center d-block mt-1';
    progressText.textContent = '0%';

    progressDiv.appendChild(progressBar);
    parentElement.appendChild(progressDiv);
    parentElement.appendChild(progressText);

    return {progressBar, progressText};
}


//==============================
// modal-utils.js - Just the modal handling, no upload logic

// utils.js - Enhanced version
export class ModalManager {
    constructor() {
        this.modalElement = document.getElementById('uploadProgressModal');
        this.progressBar = document.getElementById('uploadProgressBar');
        this.progressText = document.getElementById('uploadProgressText');
        this.cancelButton = document.getElementById('cancelUploadBtn');
        this.isVisible = false;
        this.currentXHR = null;

        if (this.modalElement) {
            this.modal = new bootstrap.Modal(this.modalElement);

            // Add event listener for when modal is completely hidden
            this.modalElement.addEventListener('hidden.bs.modal', () => {
                this.isVisible = false;
                this.currentXHR = null;
            });
        }
    }

    show(title = 'Uploading Files') {
        if (!this.modal) return;

        this.isVisible = true;

        // Update title if provided
        const titleElement = this.modalElement.querySelector('.modal-title');
        if (titleElement && title) {
            titleElement.textContent = title;
        }

        // Reset progress
        this.resetProgress();

        this.modal.show();
    }

    hide() {
        if (this.modal && this.isVisible) {
            this.modal.hide();
            this.isVisible = false;
            this.currentXHR = null;
        }
    }

    resetProgress() {
        if (this.progressBar) {
            this.progressBar.style.width = '0%';
            this.progressBar.setAttribute('aria-valuenow', 0);
            this.progressBar.classList.remove('bg-success', 'bg-danger');
            this.progressBar.classList.add('bg-primary');
        }
        if (this.progressText) {
            this.progressText.textContent = 'Preparing upload... 0%';
            this.progressText.classList.remove('text-success', 'text-danger');
        }
    }

    updateProgress(event) {
        if (this.isVisible && event.lengthComputable && this.progressBar && this.progressText) {
            const percent = Math.round((event.loaded / event.total) * 100);
            this.progressBar.style.width = `${percent}%`;
            this.progressBar.setAttribute('aria-valuenow', percent);
            this.progressText.textContent = `Uploading: ${percent}% complete (${this.formatFileSize(event.loaded)} / ${this.formatFileSize(event.total)})`;
        }
    }

    markSuccess(message = 'Upload completed successfully!') {
        if (this.progressBar) {
            this.progressBar.classList.remove('bg-primary');
            this.progressBar.classList.add('bg-success');
        }
        if (this.progressText) {
            this.progressText.textContent = message;
            this.progressText.classList.add('text-success');
        }

        // Auto-hide after success
        setTimeout(() => this.hide(), 1500);
    }

    markError(message = 'Upload failed!') {
        if (this.progressBar) {
            this.progressBar.classList.remove('bg-primary');
            this.progressBar.classList.add('bg-danger');
        }
        if (this.progressText) {
            this.progressText.textContent = message;
            this.progressText.classList.add('text-danger');
        }
    }

    formatFileSize(bytes) {
        const sizes = ['Bytes', 'KB', 'MB', 'GB'];
        if (bytes === 0) return '0 Byte';
        const i = parseInt(Math.floor(Math.log(bytes) / Math.log(1024)), 10);
        return `${(bytes / Math.pow(1024, i)).toFixed(1)} ${sizes[i]}`;
    }

    setupCancelButton(xhr) {
        this.currentXHR = xhr;
        if (this.cancelButton) {
            // Remove any existing listeners
            this.cancelButton.replaceWith(this.cancelButton.cloneNode(true));
            this.cancelButton = document.getElementById('cancelUploadBtn');

            this.cancelButton.onclick = () => {
                if (this.currentXHR) {
                    this.currentXHR.abort();
                }
                this.hide();
            };
        }
    }
}

// Create a singleton instance
export const modalManager = new ModalManager();