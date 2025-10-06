// priceRangeModule.js
export class PriceRangeFilter {
    constructor() {
        this.config = null;
        this.init();
    }

    init() {
        document.addEventListener('DOMContentLoaded', () => {
            this.initializePriceRange();
            this.initializeEnhancedDropdowns();
        });
    }

    initializePriceRange() {
        const minPrice = parseInt(document.getElementById('minPrice').value) || 0;
        const maxPrice = parseInt(document.getElementById('maxPrice').value) || 100;
        const currentMin = parseInt(document.getElementById('currentMin').value) || minPrice;
        const currentMax = parseInt(document.getElementById('currentMax').value) || maxPrice;

        this.config = { minPrice, maxPrice, currentMin, currentMax };
        this.initializePriceSlider(currentMin, currentMax, minPrice, maxPrice);
    }

    initializePriceSlider(currentMin, currentMax, minPrice, maxPrice) {
        const priceSlider = document.getElementById('priceSlider');
        if (!priceSlider) return;

        noUiSlider.create(priceSlider, {
            start: [currentMin, currentMax],
            connect: true,
            range: { 'min': minPrice, 'max': maxPrice },
            step: 1,
            behaviour: 'drag-tap',
            tooltips: false
        });

        priceSlider.noUiSlider.on('update', (values) => {
            const [minVal, maxVal] = values.map(val => Math.round(val));
            this.updateInputs(minVal, maxVal);
        });

        this.setupInputListeners(minPrice, maxPrice);
        this.updateInputs(currentMin, currentMax);
    }

    updateInputs(minVal, maxVal) {
        const elements = {
            minPriceEdit: document.getElementById('minPriceEdit'),
            maxPriceEdit: document.getElementById('maxPriceEdit'),
            minPriceInput: document.getElementById('minPriceInput'),
            maxPriceInput: document.getElementById('maxPriceInput')
        };

        Object.entries(elements).forEach(([id, element]) => {
            if (element) {
                if (id.includes('min')) element.value = minVal;
                if (id.includes('max')) element.value = maxVal;
            }
        });
    }

    setupInputListeners(minPrice, maxPrice) {
        const minPriceEdit = document.getElementById('minPriceEdit');
        const maxPriceEdit = document.getElementById('maxPriceEdit');
        const priceSlider = document.getElementById('priceSlider');

        if (minPriceEdit) {
            minPriceEdit.addEventListener('change', () => this.validateAndUpdateInputs());
        }
        if (maxPriceEdit) {
            maxPriceEdit.addEventListener('change', () => this.validateAndUpdateInputs());
        }
    }

    validateAndUpdateInputs() {
        const minPriceEdit = document.getElementById('minPriceEdit');
        const maxPriceEdit = document.getElementById('maxPriceEdit');
        const priceSlider = document.getElementById('priceSlider');
        const config = this.config;

        if (!minPriceEdit || !maxPriceEdit || !priceSlider || !config) return;

        let minVal = parseInt(minPriceEdit.value) || config.minPrice;
        let maxVal = parseInt(maxPriceEdit.value) || config.maxPrice;

        minVal = Math.max(config.minPrice, Math.min(config.maxPrice, minVal));
        maxVal = Math.max(minVal, Math.min(config.maxPrice, maxVal));

        minPriceEdit.value = minVal;
        maxPriceEdit.value = maxVal;
        priceSlider.noUiSlider.set([minVal, maxVal]);
    }

    initializeEnhancedDropdowns() {
        const dropdowns = document.querySelectorAll('.dropdown');
        dropdowns.forEach(dropdown => {
            dropdown.addEventListener('click', (e) => {
                if (e.target.closest('.dropdown-menu')) {
                    e.stopPropagation();
                }
            });
        });
    }

    applyPriceRange() {
        const minPriceEdit = document.getElementById('minPriceEdit');
        const maxPriceEdit = document.getElementById('maxPriceEdit');
        const priceRangeDropdown = document.getElementById('priceRangeDropdown');

        if (!minPriceEdit || !maxPriceEdit || !priceRangeDropdown || !this.config) return;

        const minVal = minPriceEdit.value;
        const maxVal = maxPriceEdit.value;
        const dropdownText = priceRangeDropdown.querySelector('span');

        if (minVal == this.config.minPrice && maxVal == this.config.maxPrice) {
            dropdownText.textContent = 'Price Range';
            this.removeFilter('priceRange');
        } else {
            dropdownText.textContent = `$${minVal} - $${maxVal}`;
            this.addFilter('priceRange', `Price: $${minVal} - $${maxVal}`);
        }

        document.getElementById('fSearch').submit();
    }

    resetPriceRange() {
        const priceSlider = document.getElementById('priceSlider');
        const priceRangeDropdown = document.getElementById('priceRangeDropdown');

        if (!priceRangeDropdown || !this.config) return;

        const dropdownText = priceRangeDropdown.querySelector('span');

        if (priceSlider && priceSlider.noUiSlider) {
            priceSlider.noUiSlider.set([this.config.minPrice, this.config.maxPrice]);
        }

        dropdownText.textContent = 'Price Range';
        this.removeFilter('priceRange');
        document.getElementById('fSearch').submit();
    }

    addFilter(name, value) {
        console.log('Adding filter:', name, value);
        // Your implementation
    }

    removeFilter(name) {
        console.log('Removing filter:', name);
        // Your implementation
    }
}

// Initialize
new PriceRangeFilter();