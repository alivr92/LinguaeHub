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

//============================================================
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

// ------------ These examples now appear in different positions simultaneously ---------
// --------------------------------------------------------------------------------------
//  showAlert('Top left message', 'warning', { position: 'top-left' });                 |
//  showAlert('Bottom right message', 'error', { position: 'bottom-right' });           |
//  Center and bottom messages                                                          |
//  showAlert('Center message', 'info', { position: 'center' });                        |
//  showAlert('Bottom message', 'success', { position: 'bottom' });                     |
// --------------------------------------------------------------------------------------
