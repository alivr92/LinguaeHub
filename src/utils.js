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

// utils.js - Enterprise Alert System with Enhanced Validation
// const AlertManager = (function () {
//     // Enhanced Configuration
//     const config111 = {
//         maxAlerts: 3,
//         defaultDuration: {
//             error: 10000,  // Longer duration for errors
//             warning: 6000,
//             success: 4000,
//             info: 5000
//         },
//         icons: {
//             error: '<i class="bi bi-x-octagon-fill me-2 fs-5"></i>', // Larger, more prominent
//             warning: '<i class="bi bi-exclamation-triangle-fill me-2 fs-5 text-warning"></i>',
//             success: '<i class="bi bi-check-circle-fill me-2 fs-5 text-success"></i>',
//             info: '<i class="bi bi-info-circle-fill me-2 fs-5 text-primary"></i>'
//         },
//         styles: {
//             error: 'background-color: #f8d7da; border-color: #f5c2c7; color: #842029;', // Solid red background
//             warning: 'background-color: #fff3cd; border-color: #ffecb5; color: #664d03;',
//             success: 'background-color: #d1e7dd; border-color: #badbcc; color: #0f5132;',
//             info: 'background-color: #cfe2ff; border-color: #b6d4fe; color: #084298;'
//         },
//         positions: {
//             desktop: 'top-0 end-0',
//             mobile: 'top-0 start-0'
//         }
//     };
//     const config = {
//         maxAlerts: 3,
//         defaultDuration: {
//             error: 10000,
//             warning: 6000,
//             success: 4000,
//             info: 5000
//         },
//         icons: {
//             error: '<i class="bi bi-x-octagon-fill me-2 fs-5"></i>',
//             warning: '<i class="bi bi-exclamation-triangle-fill me-2 fs-5 text-warning"></i>',
//             success: '<i class="bi bi-check-circle-fill me-2 fs-5 text-success"></i>',
//             info: '<i class="bi bi-info-circle-fill me-2 fs-5 text-primary"></i>'
//         },
//         styles: {
//             error: 'background-color: #f8d7da; border-color: #f5c2c7; color: #842029;',
//             warning: 'background-color: #fff3cd; border-color: #ffecb5; color: #664d03;',
//             success: 'background-color: #d1e7dd; border-color: #badbcc; color: #0f5132;',
//             info: 'background-color: #cfe2ff; border-color: #b6d4fe; color: #084298;'
//         }
//     };
//
//     // State
//     let activeAlerts = new Set();
//     let container = null;
//
//     // DOM Elements
//     function createContainer() {
//         container = document.createElement('div');
//         updateContainerPosition();
//         container.style.zIndex = '9999';
//         container.style.maxWidth = '400px';
//         container.style.overflowY = 'auto';
//         container.style.maxHeight = '100vh';
//         document.body.appendChild(container);
//     }
//
//     function updateContainerPosition() {
//         if (!container) return;
//         container.className = `alert-container position-fixed ${
//             window.innerWidth > 768 ? config.positions.desktop : config.positions.mobile
//             } p-3`;
//     }
//
//     // Core Functions
//     function show(message, type = 'info', options = {}) {
//         const alertKey = `${type}-${message}`;
//         if (activeAlerts.has(alertKey)) return;
//
//         const {
//             duration = config.defaultDuration[type] || 3000,
//             dismissible = true,
//             scrollTo = false,
//             highlightSelector = null
//         } = options;
//
//         const alertElement = createAlertElement(message, type, dismissible);
//         displayAlert(alertElement);
//         activeAlerts.add(alertKey);
//
//         setupDismissal(alertElement, alertKey, duration, dismissible);
//         handleAdditionalOptions(alertElement, scrollTo, highlightSelector);
//     }
//
//     function createAlertElement(message, type, dismissible) {
//         const alertDiv = document.createElement('div');
//         alertDiv.className = `alert alert-${type} alert-dismissible fade show mb-2 shadow`;
//         alertDiv.style.cssText = `
//             width: 100%;
//             transition: opacity 0.5s ease;
//             ${config.styles[type] || ''}
//             border-left: 4px solid ${getBorderColor(type)};
//             opacity: 1; /* Ensure full opacity */
//         `;
//
//         alertDiv.innerHTML = `
//             <div class="d-flex align-items-center">
//                 ${config.icons[type] || ''}
//                 <div class="flex-grow-1">${message}</div>
//                 ${dismissible ? '<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>' : ''}
//             </div>
//         `;
//         return alertDiv;
//     }
//
//     function getBorderColor(type) {
//         const colors = {
//             error: '#dc3545',
//             warning: '#ffc107',
//             success: '#198754',
//             info: '#0dcaf0'
//         };
//         return colors[type] || '#6c757d';
//     }
//
//
//     function displayAlert(alertElement) {
//         if (!container) createContainer();
//         container.prepend(alertElement);
//     }
//
//     function setupDismissal(alertElement, alertKey, duration, dismissible) {
//         let dismissTimeout;
//
//         if (duration) {
//             dismissTimeout = setTimeout(() => {
//                 dismissAlert(alertElement, alertKey);
//             }, duration);
//         }
//
//         if (dismissible) {
//             const closeBtn = alertElement.querySelector('.btn-close');
//             closeBtn?.addEventListener('click', () => {
//                 clearTimeout(dismissTimeout);
//                 dismissAlert(alertElement, alertKey);
//             });
//         }
//     }
//
//     function handleAdditionalOptions(alertElement, scrollTo, highlightSelector) {
//         if (scrollTo) {
//             setTimeout(() => {
//                 alertElement.scrollIntoView({behavior: 'smooth', block: 'nearest'});
//             }, 100);
//         }
//
//         if (highlightSelector) {
//             highlightField(highlightSelector);
//         }
//     }
//
//     function dismissAlert(alertElement, alertKey) {
//         alertElement.style.opacity = '0';
//         setTimeout(() => {
//             alertElement.remove();
//             activeAlerts.delete(alertKey);
//         }, 500);
//     }
//
//     function highlightField(selector) {
//         const elements = document.querySelectorAll(selector);
//         elements.forEach(el => {
//             el.classList.add('is-invalid');
//             setTimeout(() => {
//                 el.scrollIntoView({behavior: 'smooth', block: 'nearest'});
//             }, 300);
//
//             setTimeout(() => {
//                 el.classList.remove('is-invalid');
//             }, 5000);
//         });
//     }
//
//     function showWizardErrors(errors) {
//         clearAll();
//
//         if (errors.length > 0) {
//             // Show first error with scroll
//             show(
//                 errors[0].message,
//                 'error',
//                 {
//                     duration: 10000,
//                     scrollTo: true,
//                     highlightSelector: errors[0].selector
//                 }
//             );
//
//             // Show remaining errors without scroll
//             for (let i = 1; i < errors.length; i++) {
//                 show(
//                     errors[i].message,
//                     'error',
//                     {
//                         duration: 8000,
//                         highlightSelector: errors[i].selector
//                     }
//                 );
//             }
//         }
//     }
//
//     function clearAll() {
//         if (container) {
//             container.innerHTML = '';
//             activeAlerts.clear();
//         }
//     }
//
//     // Initialize
//     createContainer();
//     window.addEventListener('resize', updateContainerPosition);
//
//     return {
//         show,
//         showWizardErrors,
//         clearAll
//     };
// })();
//
//
// export const showAlert = AlertManager.show;
// export const showWizardErrors = AlertManager.showWizardErrors;
// export const clearAlerts = AlertManager.clearAll;


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
            desktop: 'top-0 end-0',
            mobile: 'top-0 start-0'
        }
    };

    // State
    let activeAlerts = new Set();
    let container = null;

    // DOM Elements
    function createContainer() {
        container = document.createElement('div');
        updateContainerPosition();
        container.style.zIndex = '9999';
        container.style.maxWidth = '400px';
        container.style.overflowY = 'auto';
        container.style.maxHeight = '100vh';
        document.body.appendChild(container);
    }

    function updateContainerPosition() {
        if (!container) return;
        container.className = `alert-container position-fixed ${
            window.innerWidth > 768 ? config.positions.desktop : config.positions.mobile
        } p-3`;
    }

    // Core Functions
    function show(message, type = 'info', options = {}) {
        const alertKey = `${type}-${message}`;
        if (activeAlerts.has(alertKey)) return;

        const {
            duration = config.defaultDuration[type] || 3000,
            dismissible = true,
            scrollTo = false,
            highlightSelector = null
        } = options;

        const alertElement = createAlertElement(message, type, dismissible);
        displayAlert(alertElement);
        activeAlerts.add(alertKey);

        setupDismissal(alertElement, alertKey, duration, dismissible);
        handleAdditionalOptions(alertElement, scrollTo, highlightSelector);
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

    function displayAlert(alertElement) {
        if (!container) createContainer();
        container.prepend(alertElement);
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
        if (container) {
            container.innerHTML = '';
            activeAlerts.clear();
        }
    }

    // Initialize
    createContainer();
    window.addEventListener('resize', updateContainerPosition);

    return {
        show,
        showWizardErrors,
        clearAll
    };
})();

export const showAlert = AlertManager.show;
export const showWizardErrors = AlertManager.showWizardErrors;
export const clearAlerts = AlertManager.clearAll;



//---------------------------------------------
