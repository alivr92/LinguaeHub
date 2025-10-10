// class FilterManager {
//     constructor() {
//         this.formId = 'fSearch';
//         this.activeFiltersContainerId = 'activeFiltersContainer';
//         this.filterLabels = {
//             'keySearch': 'Search',
//             'skills': 'Skills',
//             'sSkillLevel': 'Level',
//             'min_price': 'Price',
//             'max_price': 'Price',
//             'sRate': 'Rating',
//             'gender': 'Gender',
//             'country': 'Country',
//             'meeting_method': 'Method',
//             'experience': 'Experience',
//             'availability': 'Availability',
//             'student_level': 'Student Level',
//             'trial_available': 'Trial'
//         };
//         this.init();
//     }
//
//     init() {
//         this.initializeChoices();
//         this.initializeFilterTracking();
//         this.updateActiveFiltersDisplay();
//     }
//
//     initializeChoices() {
//         // Initialize Choices.js for multi-select elements
//         if (typeof Choices !== 'undefined') {
//             document.querySelectorAll('.js-choice').forEach(select => {
//                 new Choices(select, {
//                     removeItemButton: true,
//                     searchEnabled: select.dataset.searchEnabled === 'true',
//                     maxItemCount: parseInt(select.dataset.maxItemCount) || null,
//                     shouldSort: false
//                 });
//             });
//         }
//     }
//
//     initializeFilterTracking() {
//         // Track all form elements
//         const form = document.getElementById(this.formId);
//         if (form) {
//             form.addEventListener('change', () => {
//                 this.updateActiveFiltersDisplay();
//             });
//         }
//     }
//
//     updateActiveFiltersDisplay() {
//         const form = document.getElementById(this.formId);
//         const container = document.getElementById(this.activeFiltersContainerId);
//
//         if (!form || !container) return;
//
//         const formData = new FormData(form);
//         const filtersContainer = container.querySelector('.d-flex');
//
//         // Clear existing filter tags
//         filtersContainer.querySelectorAll('.filter-tag').forEach(tag => tag.remove());
//
//         let hasActiveFilters = false;
//         const processedFields = new Set();
//
//         // Process each form field
//         for (let [name, value] of formData.entries()) {
//             if (value && name !== 'page' && !processedFields.has(name)) {
//                 // Handle price range specially
//                 if (name === 'min_price' || name === 'max_price') {
//                     const minPrice = formData.get('min_price');
//                     const maxPrice = formData.get('max_price');
//                     if (minPrice && maxPrice) {
//                         hasActiveFilters = true;
//                         this.createFilterTag(filtersContainer, 'min_price', `$${minPrice}-$${maxPrice}`);
//                         processedFields.add('min_price');
//                         processedFields.add('max_price');
//                     }
//                     continue;
//                 }
//
//                 hasActiveFilters = true;
//                 this.createFilterTag(filtersContainer, name, value);
//                 processedFields.add(name);
//             }
//         }
//
//         container.style.display = hasActiveFilters ? 'block' : 'none';
//     }
//
//     createFilterTag(container, name, value) {
//         const filterTag = document.createElement('span');
//         filterTag.className = 'filter-tag';
//
//         let displayName = this.filterLabels[name] || name;
//         let displayValue = value;
//
//         // Format display values
//         if (name === 'sRate') {
//             displayValue = `${value}+ Stars`;
//         } else if (name === 'meeting_method') {
//             const methodLabels = {
//                 'online': 'Online',
//                 'in_person': 'In-Person',
//                 'hybrid': 'Hybrid'
//             };
//             displayValue = methodLabels[value] || value;
//         }
//
//         filterTag.innerHTML = `
//             ${displayName}: ${displayValue}
//             <span class="remove-filter" onclick="filterManager.removeFilter('${name}')">×</span>
//         `;
//         container.appendChild(filterTag);
//     }
//
//     removeFilter(name) {
//         const form = document.getElementById(this.formId);
//
//         if (name === 'min_price' || name === 'max_price') {
//             // Clear both price inputs
//             document.querySelector('input[name="min_price"]').value = '';
//             document.querySelector('input[name="max_price"]').value = '';
//             // Also reset the slider inputs
//             const minPriceEdit = document.getElementById('minPriceEdit');
//             const maxPriceEdit = document.getElementById('maxPriceEdit');
//             if (minPriceEdit && maxPriceEdit) {
//                 minPriceEdit.value = document.getElementById('jsMinPrice').value;
//                 maxPriceEdit.value = document.getElementById('jsMaxPrice').value;
//             }
//         } else {
//             const elements = document.querySelectorAll(`[name="${name}"]`);
//             elements.forEach(element => {
//                 if (element.multiple) {
//                     // For multi-select
//                     Array.from(element.options).forEach(option => {
//                         option.selected = false;
//                     });
//                 } else {
//                     element.value = '';
//                 }
//             });
//         }
//
//         this.updateActiveFiltersDisplay();
//         this.submitForm();
//     }
//
//     clearAllFilters() {
//         const form = document.getElementById(this.formId);
//         if (!form) return;
//
//         // Reset all form fields
//         form.querySelectorAll('select, input[type="text"], input[type="number"], input[type="search"]').forEach(element => {
//             if (element.name && element.name !== 'page') {
//                 if (element.multiple) {
//                     // For multi-select
//                     Array.from(element.options).forEach(option => {
//                         option.selected = false;
//                     });
//                 } else {
//                     element.value = '';
//                 }
//             }
//         });
//
//         // Reset price inputs to default values
//         const minPriceElement = document.querySelector('input[name="min_price"]');
//         const maxPriceElement = document.querySelector('input[name="max_price"]');
//         if (minPriceElement && maxPriceElement) {
//             minPriceElement.value = '';
//             maxPriceElement.value = '';
//         }
//
//         // Reset slider if it exists
//         if (window.priceSliderManager) {
//             window.priceSliderManager.resetPriceRange();
//         }
//
//         this.updateActiveFiltersDisplay();
//         this.submitForm();
//     }
//
//     submitForm() {
//         // Reset to page 1 when filters change
//         const pageInput = document.querySelector('input[name="page"]');
//         if (pageInput) {
//             pageInput.value = '1';
//         }
//
//         // Submit the form
//         const form = document.getElementById(this.formId);
//         if (form) {
//             form.submit();
//         }
//     }
//
//     saveSearchPreferences() {
//         const form = document.getElementById(this.formId);
//         const formData = new FormData(form);
//         const preferences = {};
//
//         for (let [name, value] of formData.entries()) {
//             if (value && name !== 'page') {
//                 preferences[name] = value;
//             }
//         }
//
//         localStorage.setItem('tutorSearchPreferences', JSON.stringify(preferences));
//         this.showToast('Search preferences saved!', 'success');
//     }
//
//     loadSavedPreferences() {
//         const saved = localStorage.getItem('tutorSearchPreferences');
//         if (saved) {
//             try {
//                 const preferences = JSON.parse(saved);
//                 Object.keys(preferences).forEach(name => {
//                     const element = document.querySelector(`[name="${name}"]`);
//                     if (element) {
//                         if (element.multiple) {
//                             // For multi-select
//                             const values = Array.isArray(preferences[name]) ? preferences[name] : [preferences[name]];
//                             values.forEach(value => {
//                                 const option = Array.from(element.options).find(opt => opt.value === value);
//                                 if (option) option.selected = true;
//                             });
//                         } else {
//                             element.value = preferences[name];
//                         }
//                     }
//                 });
//                 this.updateActiveFiltersDisplay();
//             } catch (e) {
//                 console.error('Error loading saved preferences:', e);
//             }
//         }
//     }
//
//     showToast(message, type = 'info') {
//         const toast = document.createElement('div');
//         toast.className = `alert alert-${type} alert-dismissible fade show position-fixed top-0 end-0 m-3`;
//         toast.style.zIndex = '1060';
//         toast.innerHTML = `
//             <i class="fas fa-${type === 'success' ? 'check-circle' : 'info-circle'} me-2"></i>${message}
//             <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
//         `;
//         document.body.appendChild(toast);
//
//         setTimeout(() => {
//             if (toast.parentNode) {
//                 toast.remove();
//             }
//         }, 3000);
//     }
// }
//
// // Initialize global instance
// window.filterManager = new FilterManager();


//=====================================================================================

// static/ap2_tutor/assets/js/filter_options.js

class FilterManager {
    constructor() {
        this.formId = 'fSearch';
        this.activeFiltersContainerId = 'activeFiltersContainer';
        this.filterLabels = {
            'keySearch': 'Search',
            'skills': 'Skills',
            'sSkillLevel': 'Level',
            'min_price': 'Price',
            'max_price': 'Price',
            'sRate': 'Rating',
            'gender': 'Gender',
            'country': 'Country',
            'meeting_method': 'Method',
            'experience': 'Experience',
            'availability': 'Availability',
            'student_level': 'Student Level',
            'trial_available': 'Trial',
            'sort_by': 'Sort By'
        };
        this.choicesInstances = new Map();
    }

    init() {
        this.initializeChoices();
        this.initializeFilterTracking();
        this.updateActiveFiltersDisplay();
        this.initializeSearchButton();
    }

    initializeSearchButton() {
        // Fix form submission
        const form = document.getElementById(this.formId);
        if (form) {
            form.addEventListener('submit', (e) => {
                e.preventDefault();
                this.submitForm();
            });
        }

        // Also fix search button specifically
        const searchButton = document.querySelector('button[type="submit"]');
        if (searchButton) {
            searchButton.addEventListener('click', (e) => {
                e.preventDefault();
                this.submitForm();
            });
        }
    }

    initializeChoices() {
        if (typeof Choices !== 'undefined') {
            document.querySelectorAll('.js-choice').forEach(select => {
                try {
                    const choices = new Choices(select, {
                        removeItemButton: true,
                        searchEnabled: select.dataset.searchEnabled === 'true',
                        maxItemCount: parseInt(select.dataset.maxItemCount) || null,
                        shouldSort: false
                    });

                    this.choicesInstances.set(select.name, choices);

                    // Add change listener
                    select.addEventListener('change', () => {
                        this.updateActiveFiltersDisplay();
                    });
                } catch (error) {
                    console.error('Error initializing Choices.js for', select.name, error);
                }
            });
        } else {
            console.warn('Choices.js not loaded');
        }
    }

    initializeFilterTracking() {
        // Track all form elements
        const form = document.getElementById(this.formId);
        if (form) {
            // Listen for changes on all inputs and selects
            form.addEventListener('change', (e) => {
                this.updateActiveFiltersDisplay();
            });

            // Also listen for input events on search field
            const searchInput = form.querySelector('input[name="keySearch"]');
            if (searchInput) {
                searchInput.addEventListener('input', (e) => {
                    // Update filters display when user types
                    clearTimeout(this.searchTimeout);
                    this.searchTimeout = setTimeout(() => {
                        this.updateActiveFiltersDisplay();
                    }, 500);
                });
            }
        }
    }

    updateActiveFiltersDisplay() {
        const form = document.getElementById(this.formId);
        const container = document.getElementById(this.activeFiltersContainerId);

        if (!form || !container) return;

        const formData = new FormData(form);
        const filtersContainer = container.querySelector('.d-flex');
        if (!filtersContainer) return;

        // Clear existing filter tags
        filtersContainer.querySelectorAll('.filter-tag').forEach(tag => tag.remove());

        let hasActiveFilters = false;
        const processedFields = new Set();

        // Process form data
        for (let [name, value] of formData.entries()) {
            if (value && name !== 'page' && !processedFields.has(name)) {

                // Handle multiple selections for skills and levels
                if (name === 'skills' || name === 'sSkillLevel') {
                    const allValues = formData.getAll(name);
                    if (allValues.length > 0) {
                        hasActiveFilters = true;
                        this.createMultiValueFilterTag(filtersContainer, name, allValues);
                    }
                    processedFields.add(name);
                    continue;
                }

                // Handle price range
                if (name === 'min_price' || name === 'max_price') {
                    const minPrice = formData.get('min_price');
                    const maxPrice = formData.get('max_price');
                    if (minPrice && maxPrice && !processedFields.has('price_range')) {
                        hasActiveFilters = true;
                        this.createFilterTag(filtersContainer, 'price_range', `$${minPrice}-$${maxPrice}`);
                        processedFields.add('price_range');
                        processedFields.add('min_price');
                        processedFields.add('max_price');
                    }
                    continue;
                }

                // Handle single values
                if (value && value.trim() !== '') {
                    hasActiveFilters = true;
                    this.createFilterTag(filtersContainer, name, value);
                    processedFields.add(name);
                }
            }
        }

        container.style.display = hasActiveFilters ? 'block' : 'none';
    }

    createMultiValueFilterTag(container, name, values) {
        const filterTag = document.createElement('span');
        filterTag.className = 'filter-tag';

        let displayName = this.filterLabels[name] || name;
        let displayValue = values.join(', ');

        filterTag.innerHTML = `
            ${displayName}: ${displayValue}
            <span class="remove-filter" onclick="window.filterManager.removeFilter('${name}')">×</span>
        `;
        container.appendChild(filterTag);
    }

    createFilterTag(container, name, value) {
        const filterTag = document.createElement('span');
        filterTag.className = 'filter-tag';

        let displayName = this.filterLabels[name] || name;
        let displayValue = value;

        // Format display values
        if (name === 'sRate') {
            displayValue = `${value}+ Stars`;
        } else if (name === 'meeting_method') {
            const methodLabels = {
                'online': 'Online',
                'in_person': 'In-Person',
                'hybrid': 'Hybrid'
            };
            displayValue = methodLabels[value] || value;
        } else if (name === 'sort_by') {
            const sortLabels = {
                'newest': 'Newest First',
                'oldest': 'Oldest First',
                'price_low': 'Price: Low to High',
                'price_high': 'Price: High to Low',
                'rating': 'Highest Rating',
                'students': 'Most Students',
                'sessions': 'Most Sessions',
                'reviews': 'Most Reviews'
            };
            displayValue = sortLabels[value] || value;
        } else if (name === 'price_range') {
            displayName = 'Price Range';
        }

        filterTag.innerHTML = `
            ${displayName}: ${displayValue}
            <span class="remove-filter" onclick="window.filterManager.removeFilter('${name}')">×</span>
        `;
        container.appendChild(filterTag);
    }

    removeFilter(name) {
        console.log('Removing filter:', name);

        if (name === 'min_price' || name === 'max_price' || name === 'price_range') {
            // Clear price inputs
            const minInput = document.querySelector('input[name="min_price"]');
            const maxInput = document.querySelector('input[name="max_price"]');
            if (minInput) minInput.value = '';
            if (maxInput) maxInput.value = '';

            // Reset slider
            if (window.priceSliderManager && typeof window.priceSliderManager.resetPriceRange === 'function') {
                window.priceSliderManager.resetPriceRange();
            }
        } else if (name === 'skills' || name === 'sSkillLevel') {
            // Clear multi-select fields
            const choicesInstance = this.choicesInstances.get(name);
            if (choicesInstance) {
                choicesInstance.removeActiveItems();
            } else {
                // Fallback: clear select manually
                const select = document.querySelector(`select[name="${name}"]`);
                if (select) {
                    Array.from(select.selectedOptions).forEach(option => {
                        option.selected = false;
                    });
                    select.dispatchEvent(new Event('change', { bubbles: true }));
                }
            }
        } else {
            // Clear single select/input
            const element = document.querySelector(`[name="${name}"]`);
            if (element) {
                element.value = '';
                element.dispatchEvent(new Event('change', { bubbles: true }));
            }
        }

        this.updateActiveFiltersDisplay();
        setTimeout(() => {
            this.submitForm();
        }, 100);
    }

    clearAllFilters() {
        const form = document.getElementById(this.formId);
        if (!form) return;

        // Reset all single selects and inputs
        form.querySelectorAll('select:not(.js-choice), input[type="text"], input[type="number"], input[type="search"]').forEach(element => {
            if (element.name && element.name !== 'page') {
                element.value = '';
            }
        });

        // Reset multi-select fields using Choices.js
        this.choicesInstances.forEach((choicesInstance, name) => {
            choicesInstance.removeActiveItems();
        });

        // Reset price inputs
        const minPriceElement = document.querySelector('input[name="min_price"]');
        const maxPriceElement = document.querySelector('input[name="max_price"]');
        if (minPriceElement) minPriceElement.value = '';
        if (maxPriceElement) maxPriceElement.value = '';

        // Reset slider
        if (window.priceSliderManager && typeof window.priceSliderManager.resetPriceRange === 'function') {
            window.priceSliderManager.resetPriceRange();
        }

        this.updateActiveFiltersDisplay();

        setTimeout(() => {
            this.submitForm();
        }, 100);
    }

    submitForm() {
        // Reset to page 1 when filters change
        const pageInput = document.querySelector('input[name="page"]');
        if (pageInput) {
            pageInput.value = '1';
        }

        // Submit the form
        const form = document.getElementById(this.formId);
        if (form) {
            console.log('Submitting form...');
            form.submit();
        }
    }

    saveSearchPreferences() {
        const form = document.getElementById(this.formId);
        const formData = new FormData(form);
        const preferences = {};

        for (let [name, value] of formData.entries()) {
            if (value && name !== 'page') {
                preferences[name] = value;
            }
        }

        localStorage.setItem('tutorSearchPreferences', JSON.stringify(preferences));
        this.showToast('Search preferences saved!', 'success');
    }

    loadSavedPreferences() {
        const saved = localStorage.getItem('tutorSearchPreferences');
        if (saved) {
            try {
                const preferences = JSON.parse(saved);
                Object.keys(preferences).forEach(name => {
                    const element = document.querySelector(`[name="${name}"]`);
                    if (element) {
                        if (element.multiple) {
                            const values = Array.isArray(preferences[name]) ? preferences[name] : [preferences[name]];
                            values.forEach(value => {
                                const option = Array.from(element.options).find(opt => opt.value === value);
                                if (option) option.selected = true;
                            });
                        } else {
                            element.value = preferences[name];
                        }
                    }
                });
                this.updateActiveFiltersDisplay();
            } catch (e) {
                console.error('Error loading saved preferences:', e);
            }
        }
    }

    showToast(message, type = 'info') {
        const toast = document.createElement('div');
        toast.className = `alert alert-${type} alert-dismissible fade show position-fixed top-0 end-0 m-3`;
        toast.style.zIndex = '1060';
        toast.innerHTML = `
            <i class="fas fa-${type === 'success' ? 'check-circle' : 'info-circle'} me-2"></i>${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        `;
        document.body.appendChild(toast);

        setTimeout(() => {
            if (toast.parentNode) {
                toast.remove();
            }
        }, 3000);
    }
}

// Price Slider Manager
class PriceSliderManager {
    constructor() {
        this.sliderInitialized = false;
    }

    init() {
        this.initializePriceSlider();
    }

    getPriceValues() {
        try {
            return {
                minPrice: parseInt(document.getElementById('minPrice').value) || 0,
                maxPrice: parseInt(document.getElementById('maxPrice').value) || 100,
                currentMin: parseInt(document.getElementById('currentMin').value) || 0,
                currentMax: parseInt(document.getElementById('currentMax').value) || 100
            };
        } catch (e) {
            return { minPrice: 0, maxPrice: 100, currentMin: 0, currentMax: 100 };
        }
    }

    initializePriceSlider() {
        const { minPrice, maxPrice, currentMin, currentMax } = this.getPriceValues();
        const priceSlider = document.getElementById('priceSlider');

        if (!priceSlider || typeof noUiSlider === 'undefined') {
            console.log('Price slider or noUiSlider not available yet');
            return;
        }

        try {
            // Destroy existing slider if any
            if (priceSlider.noUiSlider) {
                priceSlider.noUiSlider.destroy();
            }

            // Initialize noUiSlider
            noUiSlider.create(priceSlider, {
                start: [currentMin, currentMax],
                connect: true,
                range: {
                    'min': minPrice,
                    'max': maxPrice
                },
                step: 1,
                behaviour: 'drag-tap',
                tooltips: false
            });

            const minPriceEdit = document.getElementById('minPriceEdit');
            const maxPriceEdit = document.getElementById('maxPriceEdit');
            const minPriceInput = document.getElementById('minPriceInput');
            const maxPriceInput = document.getElementById('maxPriceInput');

            // Update inputs when slider changes
            priceSlider.noUiSlider.on('update', (values) => {
                const minVal = Math.round(values[0]);
                const maxVal = Math.round(values[1]);

                if (minPriceEdit) minPriceEdit.value = minVal;
                if (maxPriceEdit) maxPriceEdit.value = maxVal;
                if (minPriceInput) minPriceInput.value = minVal;
                if (maxPriceInput) maxPriceInput.value = maxVal;
            });

            // Update slider when inputs change
            if (minPriceEdit) {
                minPriceEdit.addEventListener('change', () => {
                    this.handlePriceInputChange('min');
                });
            }

            if (maxPriceEdit) {
                maxPriceEdit.addEventListener('change', () => {
                    this.handlePriceInputChange('max');
                });
            }

            this.sliderInitialized = true;
            console.log('Price slider initialized successfully');
        } catch (error) {
            console.error('Error initializing price slider:', error);
        }
    }

    handlePriceInputChange(type) {
        const { minPrice, maxPrice } = this.getPriceValues();
        const priceSlider = document.getElementById('priceSlider');
        const minPriceEdit = document.getElementById('minPriceEdit');
        const maxPriceEdit = document.getElementById('maxPriceEdit');

        if (!priceSlider || !minPriceEdit || !maxPriceEdit) return;

        let minVal = parseInt(minPriceEdit.value) || minPrice;
        let maxVal = parseInt(maxPriceEdit.value) || maxPrice;

        // Validate and constrain values
        minVal = Math.max(minPrice, Math.min(maxPrice, minVal));
        maxVal = Math.max(minVal, Math.min(maxPrice, maxVal));

        minPriceEdit.value = minVal;
        maxPriceEdit.value = maxVal;

        priceSlider.noUiSlider.set([minVal, maxVal]);
    }

    applyPriceRange() {
        const { minPrice, maxPrice } = this.getPriceValues();
        const minPriceEdit = document.getElementById('minPriceEdit');
        const maxPriceEdit = document.getElementById('maxPriceEdit');
        const priceRangeDropdown = document.getElementById('priceRangeDropdown');

        if (!minPriceEdit || !maxPriceEdit || !priceRangeDropdown) return;

        const minVal = minPriceEdit.value;
        const maxVal = maxPriceEdit.value;

        // Update dropdown button text
        if (minVal == minPrice && maxVal == maxPrice) {
            priceRangeDropdown.textContent = 'Price Range';
        } else {
            priceRangeDropdown.textContent = `Price: $${minVal} - $${maxVal}`;
        }

        // Close dropdown
        const dropdownElement = priceRangeDropdown.closest('.dropdown');
        if (dropdownElement) {
            const dropdown = bootstrap.Dropdown.getInstance(dropdownElement.querySelector('.dropdown-toggle'));
            if (dropdown) {
                dropdown.hide();
            }
        }

        // Submit form
        if (window.filterManager) {
            window.filterManager.submitForm();
        }
    }

    resetPriceRange() {
        const { minPrice, maxPrice } = this.getPriceValues();
        const priceSlider = document.getElementById('priceSlider');
        const minPriceEdit = document.getElementById('minPriceEdit');
        const maxPriceEdit = document.getElementById('maxPriceEdit');
        const priceRangeDropdown = document.getElementById('priceRangeDropdown');

        if (priceSlider && this.sliderInitialized) {
            priceSlider.noUiSlider.set([minPrice, maxPrice]);
        }

        if (minPriceEdit) minPriceEdit.value = minPrice;
        if (maxPriceEdit) maxPriceEdit.value = maxPrice;

        if (priceRangeDropdown) {
            priceRangeDropdown.textContent = 'Price Range';
        }

        // Close dropdown
        const dropdownElement = priceRangeDropdown?.closest('.dropdown');
        if (dropdownElement) {
            const dropdown = bootstrap.Dropdown.getInstance(dropdownElement.querySelector('.dropdown-toggle'));
            if (dropdown) {
                dropdown.hide();
            }
        }

        // Remove price filters and submit
        if (window.filterManager) {
            window.filterManager.removeFilter('min_price');
        }
    }
}

// Initialize everything when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    // Initialize Filter Manager
    window.filterManager = new FilterManager();
    window.filterManager.init();

    // Initialize Price Slider Manager
    window.priceSliderManager = new PriceSliderManager();

    // Wait a bit for noUiSlider to load, then initialize
    setTimeout(() => {
        window.priceSliderManager.init();
    }, 100);

    console.log('Filter managers initialized');
});

// Fallback initialization for turbolinks or similar
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', function() {
        if (!window.filterManager) {
            window.filterManager = new FilterManager();
            window.filterManager.init();
        }
        if (!window.priceSliderManager) {
            window.priceSliderManager = new PriceSliderManager();
            setTimeout(() => {
                window.priceSliderManager.init();
            }, 100);
        }
    });
} else {
    // DOM already loaded
    if (!window.filterManager) {
        window.filterManager = new FilterManager();
        window.filterManager.init();
    }
    if (!window.priceSliderManager) {
        window.priceSliderManager = new PriceSliderManager();
        setTimeout(() => {
            window.priceSliderManager.init();
        }, 100);
    }
}