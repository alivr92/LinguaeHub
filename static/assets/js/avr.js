/**
 * LinguaeHub- LMS, Tutor and Course Hub
 *
 * @author Lucas Vpr (https://www.LinguaeHub.com/)
 * @version 1.0.0
 **/


/* ===================
Table Of Content
======================
01 MESSAGE FADER
02
====================== */
window.showBootstrapAlert = showBootstrapAlert;

$(document).ready(function () {
    setTimeout(function () {
        const message = document.querySelector('#message');
        if (message) {
            message.style.transition = 'opacity 1s';
            message.style.opacity = '0';

            // Wait for the fade-out to complete before removing the element
            setTimeout(function () {
                message.remove();
            }, 1000); // This should match the transition duration
        }
    }, 5000);
});


function showBootstrapAlert(message, type = 'info', timeOut, btnCross = true) {
    const alertContainer = document.getElementById('alert-container');

    // Check if an exact same alert already exists
    const existingAlert = [...alertContainer.children].find(alert =>
        alert.classList.contains(`alert-${type}`) &&
        alert.textContent.includes(message)
    );

    // If the exact alert already exists, do nothing
    if (existingAlert) {
        return;
    }


    // Create the alert div
    const alertDiv = document.createElement('div');
    alertDiv.classList.add('alert', `alert-${type}`, 'alert-dismissible', 'fade', 'show');
    alertDiv.setAttribute('role', 'alert');

    // Add the message
    // Add the cross button
    if (btnCross) {
        alertDiv.innerHTML = `${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>`;
    } else {
        alertDiv.innerHTML = `${message}`;
    }


    // Append the alert to the container
    alertContainer.appendChild(alertDiv);

    // Apply timeout only if it is defined
    if (typeof timeOut !== 'undefined' && timeOut !== null) {
        // Automatically remove the alert after 5 seconds (optional)
        setTimeout(() => {
            alertDiv.classList.remove('show');
            alertDiv.classList.add('fade');
            setTimeout(() => alertDiv.remove(), 150); // Wait for fade-out animation
        }, timeOut);
    }


    // Scroll to the alert message
    if (alertContainer) {
        alertContainer.scrollIntoView({
            behavior: 'smooth',
            block: 'center'
        });
    }

}

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

// Alert Manager - Enterprise Version
const AlertManager = {
    // Configuration
    config: {
        maxAlerts: 3,
        defaultDuration: {
            error: 8000,
            warning: 5000,
            success: 3000,
            info: 4000
        },
        icons: {
            error: '<i class="bi bi-x-circle-fill me-2"></i>',
            warning: '<i class="bi bi-exclamation-triangle-fill me-2"></i>',
            success: '<i class="bi bi-check-circle-fill me-2"></i>',
            info: '<i class="bi bi-info-circle-fill me-2"></i>'
        },
        positions: {
            desktop: 'top-0 end-0',
            mobile: 'top-0 start-0'
        }
    },

    // State
    activeAlerts: new Set(),
    alertQueue: [],
    container: null,

    // Initialize the alert system
    init() {
        this.createContainer();
        window.addEventListener('resize', this.handleResize.bind(this));
    },

    // Create the alerts container
    createContainer() {
        this.container = document.createElement('div');
        this.container.className = `alert-container position-fixed ${this.getPositionClass()} p-3`;
        this.container.style.zIndex = '9999';
        this.container.style.maxWidth = '400px';
        this.container.style.overflowY = 'auto';
        this.container.style.maxHeight = '100vh';
        document.body.appendChild(this.container);
    },

    // Handle window resize
    handleResize() {
        if (this.container) {
            this.container.className = `alert-container position-fixed ${this.getPositionClass()} p-3`;
        }
    },

    // Get position class based on screen size
    getPositionClass() {
        return window.innerWidth > 768 ? this.config.positions.desktop : this.config.positions.mobile;
    },

    // Show an alert
    show(message, type = 'info', options = {}) {
        // Prevent duplicate messages
        const alertKey = `${type}-${message}`;
        if (this.activeAlerts.has(alertKey)) return;

        // Default options
        const {
            duration = this.config.defaultDuration[type] || 3000,
            dismissible = true,
            scrollTo = false,
            highlightSelector = null
        } = options;

        // Create alert element
        const alertDiv = document.createElement('div');
        alertDiv.className = `alert alert-${type} alert-dismissible fade show mb-2 shadow-sm`;
        alertDiv.style.width = '100%';
        alertDiv.style.transition = 'opacity 0.5s ease';

        // Add icon and message
        alertDiv.innerHTML = `
            <div class="d-flex align-items-center">
                ${this.config.icons[type] || ''}
                <div class="flex-grow-1">${message}</div>
                ${dismissible ? '<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>' : ''}
            </div>
        `;

        // Add to container
        if (!this.container) this.init();
        this.container.prepend(alertDiv);
        this.activeAlerts.add(alertKey);

        // Handle auto-dismiss
        let dismissTimeout;
        if (duration) {
            dismissTimeout = setTimeout(() => {
                this.dismissAlert(alertDiv, alertKey);
            }, duration);
        }

        // Handle manual dismiss
        if (dismissible) {
            const closeBtn = alertDiv.querySelector('.btn-close');
            closeBtn.addEventListener('click', () => {
                clearTimeout(dismissTimeout);
                this.dismissAlert(alertDiv, alertKey);
            });
        }

        // Scroll to error if needed
        if (scrollTo) {
            setTimeout(() => {
                alertDiv.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
            }, 100);
        }

        // Highlight related fields
        if (highlightSelector) {
            this.highlightField(highlightSelector);
        }
    },

    // Dismiss an alert
    dismissAlert(alertElement, alertKey) {
        alertElement.style.opacity = '0';
        setTimeout(() => {
            alertElement.remove();
            this.activeAlerts.delete(alertKey);
            this.processQueue();
        }, 500);
    },

    // Highlight form fields
    highlightField(selector) {
        const elements = document.querySelectorAll(selector);
        elements.forEach(el => {
            el.classList.add('is-invalid');
            setTimeout(() => {
                el.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
            }, 300);

            // Auto-remove highlight after 5 seconds
            setTimeout(() => {
                el.classList.remove('is-invalid');
            }, 5000);
        });
    },

    // Show multiple errors in wizard
    showWizardErrors(errors) {
        // Clear existing alerts first
        this.clearAll();

        // Show the first error with scroll
        if (errors.length > 0) {
            this.show(
                errors[0].message,
                'error',
                {
                    duration: 10000,
                    scrollTo: true,
                    highlightSelector: errors[0].selector
                }
            );

            // Queue remaining errors
            for (let i = 1; i < errors.length; i++) {
                this.show(
                    errors[i].message,
                    'error',
                    {
                        duration: 8000,
                        highlightSelector: errors[i].selector
                    }
                );
            }
        }
    },

    // Clear all alerts
    clearAll() {
        if (this.container) {
            this.container.innerHTML = '';
            this.activeAlerts.clear();
        }
    }
};

// Initialize on DOM ready
document.addEventListener('DOMContentLoaded', () => {
    AlertManager.init();
});

// Export for module usage
export function showAlert(message, type = 'info', options = {}) {
    AlertManager.show(message, type, options);
}

export function showWizardErrors(errors) {
    AlertManager.showWizardErrors(errors);
}