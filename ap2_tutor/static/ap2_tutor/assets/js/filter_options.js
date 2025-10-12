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
        this.resettingPrice = false;
    }

    init() {
        this.initializeChoices();
        this.initializeFilterTracking();
        this.updateActiveFiltersDisplay();
        this.initializeSearchButton();
    }

    initializeSearchButton() {
        const form = document.getElementById(this.formId);
        if (form) {
            form.addEventListener('submit', (e) => {
                e.preventDefault();
                this.submitForm();
            });
        }

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
        const form = document.getElementById(this.formId);
        if (form) {
            form.addEventListener('change', (e) => {
                this.updateActiveFiltersDisplay();
            });

            const searchInput = form.querySelector('input[name="keySearch"]');
            if (searchInput) {
                searchInput.addEventListener('input', (e) => {
                    clearTimeout(this.searchTimeout);
                    this.searchTimeout = setTimeout(() => {
                        this.updateActiveFiltersDisplay();
                    }, 500);
                });
            }
        }
    }

    updateActiveFiltersDisplay1() {
        const form = document.getElementById(this.formId);
        const container = document.getElementById(this.activeFiltersContainerId);

        if (!form || !container) return;

        const formData = new FormData(form);
        const filtersContainer = container.querySelector('.d-flex');
        if (!filtersContainer) return;

        filtersContainer.querySelectorAll('.filter-tag').forEach(tag => tag.remove());

        let hasActiveFilters = false;
        const processedFields = new Set();

        for (let [name, value] of formData.entries()) {
            if (value && name !== 'page' && !processedFields.has(name)) {

                // Handle price range - only show if explicitly set by user
                if (name === 'min_price' || name === 'max_price') {
                    const minPrice = formData.get('min_price');
                    const maxPrice = formData.get('max_price');

                    // Only show price filter if both values are explicitly set and different from default range
                    if (minPrice && maxPrice &&
                        minPrice.trim() !== '' && maxPrice.trim() !== '' &&
                        !processedFields.has('price_range')) {

                        const minNum = parseFloat(minPrice);
                        const maxNum = parseFloat(maxPrice);
                        const {
                            minPrice: defaultMin,
                            maxPrice: defaultMax
                        } = window.priceSliderManager?.getPriceValues() || {minPrice: 0, maxPrice: 100};

                        // Only show if values are different from default range
                        if (!isNaN(minNum) && !isNaN(maxNum) &&
                            (minNum !== defaultMin || maxNum !== defaultMax)) {

                            hasActiveFilters = true;
                            this.createFilterTag(filtersContainer, 'price_range', `$${minPrice}-$${maxPrice}`);
                            processedFields.add('price_range');
                            processedFields.add('min_price');
                            processedFields.add('max_price');
                        }
                    }
                    continue;
                }

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

                // Handle single values
                if (value && value.trim() !== '' && name !== 'search_terms') {
                    hasActiveFilters = true;
                    this.createFilterTag(filtersContainer, name, value);
                    processedFields.add(name);
                }
            }
        }

        container.style.display = hasActiveFilters ? 'block' : 'none';
    }

    updateActiveFiltersDisplay_ForMultipleChoices() {
        const form = document.getElementById(this.formId);
        const container = document.getElementById(this.activeFiltersContainerId);

        if (!form || !container) return;

        const formData = new FormData(form);
        const filtersContainer = container.querySelector('.d-flex');
        if (!filtersContainer) return;

        filtersContainer.querySelectorAll('.filter-tag').forEach(tag => tag.remove());

        let hasActiveFilters = false;
        const processedFields = new Set();

        // Process price range first - check if it's explicitly set
        const minPrice = formData.get('min_price');
        const maxPrice = formData.get('max_price');

        // Check if price range is explicitly set by user (not default)
        if (minPrice && maxPrice &&
            minPrice.trim() !== '' && maxPrice.trim() !== '' &&
            !processedFields.has('price_range')) {

            const minNum = parseFloat(minPrice);
            const maxNum = parseFloat(maxPrice);
            const {
                minPrice: defaultMin,
                maxPrice: defaultMax
            } = window.priceSliderManager?.getPriceValues() || {minPrice: 0, maxPrice: 100};

            // Only show price filter if values are different from default range
            if (!isNaN(minNum) && !isNaN(maxNum) &&
                (minNum !== defaultMin || maxNum !== defaultMax)) {

                hasActiveFilters = true;
                this.createFilterTag(filtersContainer, 'price_range', `$${minPrice}-$${maxPrice}`);
                processedFields.add('price_range');
                processedFields.add('min_price');
                processedFields.add('max_price');
            }
        }

        // Process other form data
        for (let [name, value] of formData.entries()) {
            if (value && name !== 'page' && !processedFields.has(name)) {

                // Skip price fields since we already processed them
                if (name === 'min_price' || name === 'max_price') {
                    continue;
                }

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

                // Handle single values
                if (value && value.trim() !== '' && name !== 'search_terms') {
                    hasActiveFilters = true;
                    this.createFilterTag(filtersContainer, name, value);
                    processedFields.add(name);
                }
            }
        }

        container.style.display = hasActiveFilters ? 'block' : 'none';
    }

    updateActiveFiltersDisplay() {
        const form = document.getElementById(this.formId);
        const container = document.getElementById(this.activeFiltersContainerId);

        if (!form || !container) return;

        const formData = new FormData(form);

        const filtersContainer = container.querySelector('.d-flex');
        if (!filtersContainer) return;

        filtersContainer.querySelectorAll('.filter-tag').forEach(tag => tag.remove());

        let hasActiveFilters = false;
        const processedFields = new Set();

        // Process price range first - check if it's explicitly set
        const minPrice = formData.get('min_price');
        const maxPrice = formData.get('max_price');

        // Check if price range is explicitly set by user (not default)
        if (minPrice && maxPrice &&
            minPrice.trim() !== '' && maxPrice.trim() !== '' &&
            !processedFields.has('price_range')) {

            const minNum = parseFloat(minPrice);
            const maxNum = parseFloat(maxPrice);
            const { minPrice: defaultMin, maxPrice: defaultMax } = window.priceSliderManager?.getPriceValues() || { minPrice: 0, maxPrice: 100 };

            // Only show price filter if values are different from default range
            if (!isNaN(minNum) && !isNaN(maxNum) &&
                (minNum !== defaultMin || maxNum !== defaultMax)) {

                hasActiveFilters = true;
                this.createFilterTag(filtersContainer, 'price_range', `$${minPrice}-$${maxPrice}`);
                processedFields.add('price_range');
                processedFields.add('min_price');
                processedFields.add('max_price');
            }
        }

        // Process other form data
        for (let [name, value] of formData.entries()) {
            if (value && name !== 'page' && !processedFields.has(name)) {

                // Skip price fields since we already processed them
                if (name === 'min_price' || name === 'max_price') {
                    continue;
                }

                // Handle single selections for skills and levels (CHANGED FROM MULTIPLE)
                if (name === 'skills' || name === 'sSkillLevel') {
                    // For single selection, just check if value exists
                    if (value && value.trim() !== '') {
                        hasActiveFilters = true;
                        this.createFilterTag(filtersContainer, name, value); // Use createFilterTag instead of createMultiValueFilterTag
                    }
                    processedFields.add(name);
                    continue;
                }

                // Handle other single values
                if (value && value.trim() !== '' && name !== 'search_terms') {
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
        // let displayValue = values.map(v => v.toUpperCase()).join(', ');
        let displayValue = values.map(v => v.charAt(0).toUpperCase() + v.slice(1)).join(', ');

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
        // let displayValue = value;
        let displayValue = value.charAt(0).toUpperCase() + value.slice(1);


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

    removeFilter_ForMultipleChoices(name) {
        console.log('Removing filter:', name);

        if (name === 'min_price' || name === 'max_price' || name === 'price_range') {
            const minInput = document.querySelector('input[name="min_price"]');
            const maxInput = document.querySelector('input[name="max_price"]');
            if (minInput) minInput.value = '';
            if (maxInput) maxInput.value = '';

            if (window.priceSliderManager && typeof window.priceSliderManager.resetPriceRange === 'function') {
                if (!this.resettingPrice) {
                    this.resettingPrice = true;
                    window.priceSliderManager.resetPriceRange();
                    this.resettingPrice = false;
                }
            }
        } else if (name === 'skills' || name === 'sSkillLevel') {
            const choicesInstance = this.choicesInstances.get(name);
            if (choicesInstance) {
                choicesInstance.removeActiveItems();
            } else {
                const select = document.querySelector(`select[name="${name}"]`);
                if (select) {
                    Array.from(select.selectedOptions).forEach(option => {
                        option.selected = false;
                    });
                    select.dispatchEvent(new Event('change', {bubbles: true}));
                }
            }
        } else {
            const element = document.querySelector(`[name="${name}"]`);
            if (element) {
                element.value = '';
                element.dispatchEvent(new Event('change', {bubbles: true}));
            }
        }

        this.updateActiveFiltersDisplay();
        setTimeout(() => {
            this.submitForm();
        }, 100);
    }

    removeFilter(name) {
        console.log('Removing filter:', name);

        if (name === 'min_price' || name === 'max_price' || name === 'price_range') {
            const minInput = document.querySelector('input[name="min_price"]');
            const maxInput = document.querySelector('input[name="max_price"]');
            if (minInput) minInput.value = '';
            if (maxInput) maxInput.value = '';

            if (window.priceSliderManager && typeof window.priceSliderManager.resetPriceRange === 'function') {
                if (!this.resettingPrice) {
                    this.resettingPrice = true;
                    window.priceSliderManager.resetPriceRange();
                    this.resettingPrice = false;
                }
            }
        }
        // else if (name === 'skills' || name === 'sSkillLevel') {
        //     const choicesInstance = this.choicesInstances.get(name);
        //     if (choicesInstance) {
        //         choicesInstance.removeActiveItems();
        //         // For single selection, also clear the selected value
        //         choicesInstance.setChoiceByValue('');
        //     } else {
        //         const select = document.querySelector(`select[name="${name}"]`);
        //         if (select) {
        //             select.value = ''; // Simply set to empty for single selection
        //             select.dispatchEvent(new Event('change', { bubbles: true }));
        //         }
        //     }
        // }
        else {
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

    clearAllFilters_ForMultipleChoices() {
        const form = document.getElementById(this.formId);
        if (!form) return;

        form.querySelectorAll('.js-choice, input[type="text"], input[type="number"], input[type="search"]').forEach(element => {
            if (element.name && element.name !== 'page') {
                element.value = '';
                element.dispatchEvent(new Event('change', {bubbles: true}));
            }
        });

        this.choicesInstances.forEach((choicesInstance, name) => {
            try {
                choicesInstance.removeActiveItems();
                const select = document.querySelector(`select[name="${name}"]`);
                if (select) {
                    Array.from(select.selectedOptions).forEach(option => {
                        option.selected = false;
                    });
                }
            } catch (error) {
                console.error('Error clearing choices instance:', name, error);
            }
        });

        const minPriceInput = document.querySelector('input[name="min_price"]');
        const maxPriceInput = document.querySelector('input[name="max_price"]');
        const minPriceEdit = document.getElementById('minPriceEdit');
        const maxPriceEdit = document.getElementById('maxPriceEdit');

        if (minPriceInput) minPriceInput.value = '';
        if (maxPriceInput) maxPriceInput.value = '';
        if (minPriceEdit) minPriceEdit.value = '';
        if (maxPriceEdit) maxPriceEdit.value = '';

        if (window.priceSliderManager && typeof window.priceSliderManager.resetPriceRange === 'function') {
            window.priceSliderManager.resetPriceRange();
        } else {
            const priceRangeDropdown = document.getElementById('priceRangeDropdown');
            if (priceRangeDropdown) {
                priceRangeDropdown.textContent = 'Price Range';
            }
        }

        this.updateActiveFiltersDisplay();
        this.submitForm();

        setTimeout(() => {
            this.submitForm();
        }, 150);
    }

    clearAllFilters() {
        const form = document.getElementById(this.formId);
        if (!form) return;

        // Clear all inputs and selects
        form.querySelectorAll('.js-choice, input[type="text"], input[type="number"], input[type="search"], select').forEach(element => {
            if (element.name && element.name !== 'page') {
                element.value = '';
                element.dispatchEvent(new Event('change', { bubbles: true }));
            }
        });

        // Reset Choices.js instances for single selects
        this.choicesInstances.forEach((choicesInstance, name) => {
            try {
                choicesInstance.removeActiveItems();
                // For single selection, set to empty value
                choicesInstance.setChoiceByValue('');
            } catch (error) {
                console.error('Error clearing choices instance:', name, error);
            }
        });

        // Clear price inputs
        const minPriceInput = document.querySelector('input[name="min_price"]');
        const maxPriceInput = document.querySelector('input[name="max_price"]');
        const minPriceEdit = document.getElementById('minPriceEdit');
        const maxPriceEdit = document.getElementById('maxPriceEdit');

        if (minPriceInput) minPriceInput.value = '';
        if (maxPriceInput) maxPriceInput.value = '';
        if (minPriceEdit) minPriceEdit.value = '';
        if (maxPriceEdit) maxPriceEdit.value = '';

        // Reset slider
        if (window.priceSliderManager && typeof window.priceSliderManager.resetPriceRange === 'function') {
            window.priceSliderManager.resetPriceRange();
        } else {
            const priceRangeDropdown = document.getElementById('priceRangeDropdown');
            if (priceRangeDropdown) {
                priceRangeDropdown.textContent = 'Price Range';
            }
        }

        this.updateActiveFiltersDisplay();
        this.submitForm();
    }

    submitForm() {
        const pageInput = document.querySelector('input[name="page"]');
        if (pageInput) {
            pageInput.value = '1';
        }

        const form = document.getElementById(this.formId);
        if (form) {
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

class PriceSliderManager {
    constructor() {
        this.sliderInitialized = false;
    }

    init() {
        this.initializePriceSlider();
    }

    getPriceValues() {
        try {
            const minPriceElem = document.getElementById('minPrice');
            const maxPriceElem = document.getElementById('maxPrice');
            const currentMinElem = document.getElementById('currentMin');
            const currentMaxElem = document.getElementById('currentMax');

            const minPrice = minPriceElem && minPriceElem.value ? parseFloat(minPriceElem.value) : 0;
            const maxPrice = maxPriceElem && maxPriceElem.value ? parseFloat(maxPriceElem.value) : 100;

            let currentMin = minPrice;
            let currentMax = maxPrice;

            if (currentMinElem && currentMinElem.value !== '') {
                currentMin = parseFloat(currentMinElem.value);
            }
            if (currentMaxElem && currentMaxElem.value !== '') {
                currentMax = parseFloat(currentMaxElem.value);
            }

            return {
                minPrice,
                maxPrice,
                currentMin,
                currentMax
            };
        } catch (e) {
            return {minPrice: 0, maxPrice: 100, currentMin: 0, currentMax: 100};
        }
    }

    initializePriceSlider1() {
        const {minPrice, maxPrice, currentMin, currentMax} = this.getPriceValues();
        const priceSlider = document.getElementById('priceSlider');

        if (!priceSlider || typeof noUiSlider === 'undefined') {
            return;
        }

        try {
            if (priceSlider.noUiSlider) {
                priceSlider.noUiSlider.destroy();
            }

            const startMin = isNaN(currentMin) ? minPrice : currentMin;
            const startMax = isNaN(currentMax) ? maxPrice : currentMax;

            noUiSlider.create(priceSlider, {
                start: [startMin, startMax],
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

            priceSlider.noUiSlider.on('update', (values) => {
                const minVal = Math.round(values[0]);
                const maxVal = Math.round(values[1]);

                if (minPriceEdit) minPriceEdit.value = minVal;
                if (maxPriceEdit) maxPriceEdit.value = maxVal;
                if (minPriceInput) minPriceInput.value = minVal;
                if (maxPriceInput) maxPriceInput.value = maxVal;
            });

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
        } catch (error) {
            console.error('Error initializing price slider:', error);
        }
    }

    initializePriceSlider() {
        const {minPrice, maxPrice, currentMin, currentMax} = this.getPriceValues();
        const priceSlider = document.getElementById('priceSlider');

        if (!priceSlider || typeof noUiSlider === 'undefined') {
            return;
        }

        try {
            if (priceSlider.noUiSlider) {
                priceSlider.noUiSlider.destroy();
            }

            const startMin = isNaN(currentMin) ? minPrice : currentMin;
            const startMax = isNaN(currentMax) ? maxPrice : currentMax;

            noUiSlider.create(priceSlider, {
                start: [startMin, startMax],
                connect: true,
                range: {
                    'min': minPrice,
                    'max': maxPrice
                },
                step: 1, // Change this to 0.5 for decimal steps
                behaviour: 'drag-tap',
                tooltips: false,
                format: {
                    to: function (value) {
                        return value % 1 === 0 ? value.toFixed(0) : value.toFixed(1); // Keep decimal if needed
                    },
                    from: function (value) {
                        return parseFloat(value);
                    }
                }
            });

            const minPriceEdit = document.getElementById('minPriceEdit');
            const maxPriceEdit = document.getElementById('maxPriceEdit');
            const minPriceInput = document.getElementById('minPriceInput');
            const maxPriceInput = document.getElementById('maxPriceInput');

            // FIX: Remove rounding to keep decimal values
            priceSlider.noUiSlider.on('update', (values) => {
                const minVal = parseFloat(values[0]); // Remove Math.round
                const maxVal = parseFloat(values[1]); // Remove Math.round

                if (minPriceEdit) minPriceEdit.value = minVal;
                if (maxPriceEdit) maxPriceEdit.value = maxVal;
                if (minPriceInput) minPriceInput.value = minVal;
                if (maxPriceInput) maxPriceInput.value = maxVal;
            });

            // ... rest of the code

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
        } catch (error) {
            console.error('Error initializing price slider:', error);
        }
    }

    handlePriceInputChange1(type) {
        const {minPrice, maxPrice} = this.getPriceValues();
        const priceSlider = document.getElementById('priceSlider');
        const minPriceEdit = document.getElementById('minPriceEdit');
        const maxPriceEdit = document.getElementById('maxPriceEdit');

        if (!priceSlider || !minPriceEdit || !maxPriceEdit) return;

        let minVal = parseInt(minPriceEdit.value) || minPrice;
        let maxVal = parseInt(maxPriceEdit.value) || maxPrice;

        minVal = Math.max(minPrice, Math.min(maxPrice, minVal));
        maxVal = Math.max(minVal, Math.min(maxPrice, maxVal));

        minPriceEdit.value = minVal;
        maxPriceEdit.value = maxVal;

        priceSlider.noUiSlider.set([minVal, maxVal]);
    }

    handlePriceInputChange(type) {
        const { minPrice, maxPrice } = this.getPriceValues();
        const priceSlider = document.getElementById('priceSlider');
        const minPriceEdit = document.getElementById('minPriceEdit');
        const maxPriceEdit = document.getElementById('maxPriceEdit');

        if (!priceSlider || !minPriceEdit || !maxPriceEdit) return;

        let minVal = parseFloat(minPriceEdit.value) || minPrice; // Use parseFloat instead of parseInt
        let maxVal = parseFloat(maxPriceEdit.value) || maxPrice; // Use parseFloat instead of parseInt

        // Validate and constrain values
        minVal = Math.max(minPrice, Math.min(maxPrice, minVal));
        maxVal = Math.max(minVal, Math.min(maxPrice, maxVal));

        minPriceEdit.value = minVal;
        maxPriceEdit.value = maxVal;

        priceSlider.noUiSlider.set([minVal, maxVal]);
    }

    applyPriceRange1() {
        const {minPrice, maxPrice} = this.getPriceValues();
        const minPriceEdit = document.getElementById('minPriceEdit');
        const maxPriceEdit = document.getElementById('maxPriceEdit');
        const priceRangeDropdown = document.getElementById('priceRangeDropdown');

        if (!minPriceEdit || !maxPriceEdit || !priceRangeDropdown) return;

        const minVal = minPriceEdit.value;
        const maxVal = maxPriceEdit.value;

        if (minVal == minPrice && maxVal == maxPrice) {
            priceRangeDropdown.textContent = 'Price Range';
        } else {
            priceRangeDropdown.textContent = `Price: $${minVal} - $${maxVal}`;
        }

        const dropdownElement = priceRangeDropdown.closest('.dropdown');
        if (dropdownElement) {
            const dropdown = bootstrap.Dropdown.getInstance(dropdownElement.querySelector('.dropdown-toggle'));
            if (dropdown) {
                dropdown.hide();
            }
        }

        if (window.filterManager) {
            window.filterManager.submitForm();
        }
    }

    applyPriceRange() {
        const { minPrice, maxPrice } = this.getPriceValues();
        const minPriceEdit = document.getElementById('minPriceEdit');
        const maxPriceEdit = document.getElementById('maxPriceEdit');
        const priceRangeDropdown = document.getElementById('priceRangeDropdown');

        if (!minPriceEdit || !maxPriceEdit || !priceRangeDropdown) return;

        const minVal = parseFloat(minPriceEdit.value);
        const maxVal = parseFloat(maxPriceEdit.value);

        // Update dropdown button text with proper formatting
        if (minVal === minPrice && maxVal === maxPrice) {
            priceRangeDropdown.textContent = 'Price Range';
        } else {
            // Format to show decimals only if needed
            const formatPrice = (price) => price % 1 === 0 ? price.toFixed(0) : price.toFixed(1);
            priceRangeDropdown.textContent = `Price: $${formatPrice(minVal)} - $${formatPrice(maxVal)}`;
        }

        const dropdownElement = priceRangeDropdown.closest('.dropdown');
        if (dropdownElement) {
            const dropdown = bootstrap.Dropdown.getInstance(dropdownElement.querySelector('.dropdown-toggle'));
            if (dropdown) {
                dropdown.hide();
            }
        }

        if (window.filterManager) {
            window.filterManager.submitForm();
        }
    }

    resetPriceRange() {
        const {minPrice, maxPrice} = this.getPriceValues();
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

        const dropdownElement = priceRangeDropdown?.closest('.dropdown');
        if (dropdownElement) {
            const dropdown = bootstrap.Dropdown.getInstance(dropdownElement.querySelector('.dropdown-toggle'));
            if (dropdown) {
                dropdown.hide();
            }
        }

        const minPriceInput = document.querySelector('input[name="min_price"]');
        const maxPriceInput = document.querySelector('input[name="max_price"]');

        if (minPriceInput) minPriceInput.value = '';
        if (maxPriceInput) maxPriceInput.value = '';

        if (window.filterManager) {
            window.filterManager.updateActiveFiltersDisplay();
        }
    }
}

document.addEventListener('DOMContentLoaded', function () {
    window.filterManager = new FilterManager();
    window.filterManager.init();

    window.priceSliderManager = new PriceSliderManager();

    setTimeout(() => {
        window.priceSliderManager.init();
    }, 100);
});

if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', function () {
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

// $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// static/ap2_tutor/assets/js/filter_options.js
