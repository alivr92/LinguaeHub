class PriceSliderManager {
    constructor() {
        this.sliderInitialized = false;
        this.init();
    }

    init() {
        this.initializePriceSlider();
    }

    getPriceValues() {
        return {
            minPrice: parseInt(document.getElementById('jsMinPrice').value) || 0,
            maxPrice: parseInt(document.getElementById('jsMaxPrice').value) || 100,
            currentMin: parseInt(document.getElementById('jsCurrentMinPrice').value) || 0,
            currentMax: parseInt(document.getElementById('jsCurrentMaxPrice').value) || 100
        };
    }

    initializePriceSlider() {
        const { minPrice, maxPrice, currentMin, currentMax } = this.getPriceValues();
        const priceSlider = document.getElementById('priceSlider');

        if (!priceSlider || typeof noUiSlider === 'undefined') {
            console.error('Price slider element or noUiSlider not found');
            return;
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
        const dropdown = bootstrap.Dropdown.getInstance(priceRangeDropdown.closest('.dropdown').querySelector('.dropdown-toggle'));
        if (dropdown) {
            dropdown.hide();
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
        const dropdown = bootstrap.Dropdown.getInstance(priceRangeDropdown.closest('.dropdown').querySelector('.dropdown-toggle'));
        if (dropdown) {
            dropdown.hide();
        }

        // Remove price filters and submit
        if (window.filterManager) {
            window.filterManager.removeFilter('min_price');
        }
    }
}

// Initialize global instance
window.priceSliderManager = new PriceSliderManager();