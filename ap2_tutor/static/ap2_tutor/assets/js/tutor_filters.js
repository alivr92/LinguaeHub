// // Range Slider Functionality
// Global filter state
const activeFilters = {
    priceRange: null,
    skills: null,
    skillLevel: null,
    gender: null,
    rating: null
};

document.addEventListener('DOMContentLoaded', function() {
    initializePriceSlider();
    initializeFilterTracking();
});

function initializePriceSlider() {
    const rangeMin = document.querySelector('.range-min');
    const rangeMax = document.querySelector('.range-max');
    const minPriceInput = document.getElementById('minPriceInput');
    const maxPriceInput = document.getElementById('maxPriceInput');
    const minPriceDisplay = document.getElementById('minPriceDisplay');
    const maxPriceDisplay = document.getElementById('maxPriceDisplay');
    const minPriceEdit = document.getElementById('minPriceEdit');
    const maxPriceEdit = document.getElementById('maxPriceEdit');
    const priceRangeDropdown = document.getElementById('priceRangeDropdown');
    const sliderTrack = document.querySelector('.slider-track');

    const minValue = parseInt(rangeMin.min);
    const maxValue = parseInt(rangeMax.max);

    function updateSlider() {
        const minVal = parseInt(rangeMin.value);
        const maxVal = parseInt(rangeMax.value);

        const minPercent = ((minVal - minValue) / (maxValue - minValue)) * 100;
        const maxPercent = ((maxVal - minValue) / (maxValue - minValue)) * 100;

        // Update active track
        sliderTrack.style.setProperty('--min-percent', minPercent + '%');
        sliderTrack.style.setProperty('--max-percent', maxPercent + '%');

        // Update displays
        minPriceDisplay.textContent = '$' + minVal;
        maxPriceDisplay.textContent = '$' + maxVal;

        // Update editable inputs
        minPriceEdit.value = minVal;
        maxPriceEdit.value = maxVal;

        // Update hidden inputs
        minPriceInput.value = minVal;
        maxPriceInput.value = maxVal;
    }

    function updateFromEditableInputs() {
        let minVal = parseInt(minPriceEdit.value) || minValue;
        let maxVal = parseInt(maxPriceEdit.value) || maxValue;

        // Validate ranges
        minVal = Math.max(minValue, Math.min(maxValue, minVal));
        maxVal = Math.max(minValue, Math.min(maxValue, maxVal));

        if (minVal > maxVal) {
            minVal = maxVal;
        }

        rangeMin.value = minVal;
        rangeMax.value = maxVal;
        updateSlider();
    }

    // Slider events
    rangeMin.addEventListener('input', function() {
        if (parseInt(rangeMin.value) > parseInt(rangeMax.value)) {
            rangeMin.value = rangeMax.value;
        }
        updateSlider();
    });

    rangeMax.addEventListener('input', function() {
        if (parseInt(rangeMax.value) < parseInt(rangeMin.value)) {
            rangeMax.value = rangeMin.value;
        }
        updateSlider();
    });

    // Editable input events
    minPriceEdit.addEventListener('change', updateFromEditableInputs);
    maxPriceEdit.addEventListener('change', updateFromEditableInputs);

    minPriceEdit.addEventListener('blur', updateFromEditableInputs);
    maxPriceEdit.addEventListener('blur', updateFromEditableInputs);

    // Initialize
    updateSlider();
}

function applyPriceRange() {
    const rangeMin = document.querySelector('.range-min');
    const rangeMax = document.querySelector('.range-max');
    const minVal = rangeMin.value;
    const maxVal = rangeMax.value;
    const minValue = parseInt(rangeMin.min);
    const maxValue = parseInt(rangeMax.max);

    const priceRangeDropdown = document.getElementById('priceRangeDropdown');

    // Update dropdown button text
    if (minVal == minValue && maxVal == maxValue) {
        priceRangeDropdown.textContent = 'Hourly Price';
        removeFilter('priceRange');
    } else {
        priceRangeDropdown.textContent = `Price: $${minVal} - $${maxVal}`;
        addFilter('priceRange', `Price: $${minVal} - $${maxVal}`);
    }

    // Close dropdown
    const dropdown = document.querySelector('[data-bs-toggle="dropdown"]');
    const bootstrapDropdown = bootstrap.Dropdown.getInstance(dropdown);
    if (bootstrapDropdown) {
        bootstrapDropdown.hide();
    }

    // Submit form or trigger filtering
    triggerFiltering();
}

// Active Filters Management
function initializeFilterTracking() {
    // Track all filter changes
    document.querySelectorAll('select[name], input[name]').forEach(element => {
        if (element.name !== 'min_price' && element.name !== 'max_price') {
            element.addEventListener('change', function() {
                if (this.value) {
                    addFilter(this.name, this.options[this.selectedIndex].text);
                } else {
                    removeFilter(this.name);
                }
                triggerFiltering();
            });
        }
    });
}

function addFilter(name, value) {
    activeFilters[name] = value;
    updateActiveFiltersDisplay();
}

function removeFilter(name) {
    delete activeFilters[name];

    // Reset the corresponding form element
    const element = document.querySelector(`[name="${name}"]`);
    if (element) {
        element.value = '';

        // Special case for price range dropdown
        if (name === 'priceRange') {
            const priceRangeDropdown = document.getElementById('priceRangeDropdown');
            priceRangeDropdown.textContent = 'Hourly Price';
            resetPriceRange();
        }
    }

    updateActiveFiltersDisplay();
    triggerFiltering();
}

function updateActiveFiltersDisplay() {
    const container = document.getElementById('activeFiltersContainer');
    const filtersContainer = container.querySelector('.d-flex');

    // Remove existing filter tags (keep the "Active filters" text)
    const filterTags = filtersContainer.querySelectorAll('.filter-tag');
    filterTags.forEach(tag => tag.remove());

    // Add current active filters
    Object.entries(activeFilters).forEach(([name, value]) => {
        if (value) {
            const filterTag = document.createElement('span');
            filterTag.className = 'filter-tag';
            filterTag.innerHTML = `
                ${value}
                <span class="remove-filter" onclick="removeFilter('${name}')">×</span>
            `;
            filtersContainer.appendChild(filterTag);
        }
    });

    // Show/hide container
    container.style.display = Object.keys(activeFilters).some(key => activeFilters[key]) ? 'block' : 'none';
}

function resetPriceRange() {
    const rangeMin = document.querySelector('.range-min');
    const rangeMax = document.querySelector('.range-max');
    const minPriceEdit = document.getElementById('minPriceEdit');
    const maxPriceEdit = document.getElementById('maxPriceEdit');
    const minValue = parseInt(rangeMin.min);
    const maxValue = parseInt(rangeMax.max);

    rangeMin.value = minValue;
    rangeMax.value = maxValue;
    minPriceEdit.value = minValue;
    maxPriceEdit.value = maxValue;

    // Trigger slider update
    const event = new Event('input');
    rangeMin.dispatchEvent(event);
    rangeMax.dispatchEvent(event);
}

function triggerFiltering() {
    // Here you can submit the form or make an AJAX call
    // document.querySelector('form').submit();

    // Or for AJAX filtering:
    // const formData = new FormData(document.querySelector('form'));
    // fetch('/your-filter-endpoint/', {
    //     method: 'POST',
    //     body: formData
    // }).then(response => response.json())
    //   .then(data => updateResults(data));

    console.log('Active filters:', activeFilters);
}