// Complete country list (250+ countries) - No npm required
const countries = [
    {code: 'af', name: 'Afghanistan', dial: '+93'},
    {code: 'al', name: 'Albania', dial: '+355'},
    {code: 'dz', name: 'Algeria', dial: '+213'},
    {code: 'as', name: 'American Samoa', dial: '+1684'},
    {code: 'ad', name: 'Andorra', dial: '+376'},
    {code: 'ao', name: 'Angola', dial: '+244'},
    {code: 'ai', name: 'Anguilla', dial: '+1264'},
    {code: 'ag', name: 'Antigua and Barbuda', dial: '+1268'},
    {code: 'ar', name: 'Argentina', dial: '+54'},
    {code: 'am', name: 'Armenia', dial: '+374'},
    {code: 'aw', name: 'Aruba', dial: '+297'},
    {code: 'au', name: 'Australia', dial: '+61'},
    {code: 'at', name: 'Austria', dial: '+43'},
    {code: 'az', name: 'Azerbaijan', dial: '+994'},
    {code: 'bs', name: 'Bahamas', dial: '+1242'},
    {code: 'bh', name: 'Bahrain', dial: '+973'},
    {code: 'bd', name: 'Bangladesh', dial: '+880'},
    {code: 'bb', name: 'Barbados', dial: '+1246'},
    {code: 'by', name: 'Belarus', dial: '+375'},
    {code: 'be', name: 'Belgium', dial: '+32'},
    {code: 'bz', name: 'Belize', dial: '+501'},
    {code: 'bj', name: 'Benin', dial: '+229'},
    {code: 'bm', name: 'Bermuda', dial: '+1441'},
    {code: 'bt', name: 'Bhutan', dial: '+975'},
    {code: 'bo', name: 'Bolivia', dial: '+591'},
    {code: 'ba', name: 'Bosnia and Herzegovina', dial: '+387'},
    {code: 'bw', name: 'Botswana', dial: '+267'},
    {code: 'br', name: 'Brazil', dial: '+55'},
    {code: 'io', name: 'British Indian Ocean Territory', dial: '+246'},
    {code: 'vg', name: 'British Virgin Islands', dial: '+1284'},
    {code: 'bn', name: 'Brunei', dial: '+673'},
    {code: 'bg', name: 'Bulgaria', dial: '+359'},
    {code: 'bf', name: 'Burkina Faso', dial: '+226'},
    {code: 'bi', name: 'Burundi', dial: '+257'},
    {code: 'kh', name: 'Cambodia', dial: '+855'},
    {code: 'cm', name: 'Cameroon', dial: '+237'},
    {code: 'ca', name: 'Canada', dial: '+1'},
    {code: 'cv', name: 'Cape Verde', dial: '+238'},
    {code: 'ky', name: 'Cayman Islands', dial: '+1345'},
    {code: 'cf', name: 'Central African Republic', dial: '+236'},
    {code: 'td', name: 'Chad', dial: '+235'},
    {code: 'cl', name: 'Chile', dial: '+56'},
    {code: 'cn', name: 'China', dial: '+86'},
    {code: 'cx', name: 'Christmas Island', dial: '+61'},
    {code: 'cc', name: 'Cocos Islands', dial: '+61'},
    {code: 'co', name: 'Colombia', dial: '+57'},
    {code: 'km', name: 'Comoros', dial: '+269'},
    {code: 'ck', name: 'Cook Islands', dial: '+682'},
    {code: 'cr', name: 'Costa Rica', dial: '+506'},
    {code: 'hr', name: 'Croatia', dial: '+385'},
    {code: 'cu', name: 'Cuba', dial: '+53'},
    {code: 'cw', name: 'Curacao', dial: '+599'},
    {code: 'cy', name: 'Cyprus', dial: '+357'},
    {code: 'cz', name: 'Czech Republic', dial: '+420'},
    {code: 'cd', name: 'Democratic Republic of the Congo', dial: '+243'},
    {code: 'dk', name: 'Denmark', dial: '+45'},
    {code: 'dj', name: 'Djibouti', dial: '+253'},
    {code: 'dm', name: 'Dominica', dial: '+1767'},
    {code: 'do', name: 'Dominican Republic', dial: '+1809'},
    {code: 'tl', name: 'East Timor', dial: '+670'},
    {code: 'ec', name: 'Ecuador', dial: '+593'},
    {code: 'eg', name: 'Egypt', dial: '+20'},
    {code: 'sv', name: 'El Salvador', dial: '+503'},
    {code: 'gq', name: 'Equatorial Guinea', dial: '+240'},
    {code: 'er', name: 'Eritrea', dial: '+291'},
    {code: 'ee', name: 'Estonia', dial: '+372'},
    {code: 'et', name: 'Ethiopia', dial: '+251'},
    {code: 'fk', name: 'Falkland Islands', dial: '+500'},
    {code: 'fo', name: 'Faroe Islands', dial: '+298'},
    {code: 'fj', name: 'Fiji', dial: '+679'},
    {code: 'fi', name: 'Finland', dial: '+358'},
    {code: 'fr', name: 'France', dial: '+33'},
    {code: 'pf', name: 'French Polynesia', dial: '+689'},
    {code: 'ga', name: 'Gabon', dial: '+241'},
    {code: 'gm', name: 'Gambia', dial: '+220'},
    {code: 'ge', name: 'Georgia', dial: '+995'},
    {code: 'de', name: 'Germany', dial: '+49'},
    {code: 'gh', name: 'Ghana', dial: '+233'},
    {code: 'gi', name: 'Gibraltar', dial: '+350'},
    {code: 'gr', name: 'Greece', dial: '+30'},
    {code: 'gl', name: 'Greenland', dial: '+299'},
    {code: 'gd', name: 'Grenada', dial: '+1473'},
    {code: 'gu', name: 'Guam', dial: '+1671'},
    {code: 'gt', name: 'Guatemala', dial: '+502'},
    {code: 'gg', name: 'Guernsey', dial: '+441481'},
    {code: 'gn', name: 'Guinea', dial: '+224'},
    {code: 'gw', name: 'Guinea-Bissau', dial: '+245'},
    {code: 'gy', name: 'Guyana', dial: '+592'},
    {code: 'ht', name: 'Haiti', dial: '+509'},
    {code: 'hn', name: 'Honduras', dial: '+504'},
    {code: 'hk', name: 'Hong Kong', dial: '+852'},
    {code: 'hu', name: 'Hungary', dial: '+36'},
    {code: 'is', name: 'Iceland', dial: '+354'},
    {code: 'in', name: 'India', dial: '+91'},
    {code: 'id', name: 'Indonesia', dial: '+62'},
    {code: 'ir', name: 'Iran', dial: '+98'},
    {code: 'iq', name: 'Iraq', dial: '+964'},
    {code: 'ie', name: 'Ireland', dial: '+353'},
    {code: 'im', name: 'Isle of Man', dial: '+441624'},
    {code: 'il', name: 'Israel', dial: '+972'},
    {code: 'it', name: 'Italy', dial: '+39'},
    {code: 'ci', name: 'Ivory Coast', dial: '+225'},
    {code: 'jm', name: 'Jamaica', dial: '+1876'},
    {code: 'jp', name: 'Japan', dial: '+81'},
    {code: 'je', name: 'Jersey', dial: '+441534'},
    {code: 'jo', name: 'Jordan', dial: '+962'},
    {code: 'kz', name: 'Kazakhstan', dial: '+7'},
    {code: 'ke', name: 'Kenya', dial: '+254'},
    {code: 'ki', name: 'Kiribati', dial: '+686'},
    {code: 'xk', name: 'Kosovo', dial: '+383'},
    {code: 'kw', name: 'Kuwait', dial: '+965'},
    {code: 'kg', name: 'Kyrgyzstan', dial: '+996'},
    {code: 'la', name: 'Laos', dial: '+856'},
    {code: 'lv', name: 'Latvia', dial: '+371'},
    {code: 'lb', name: 'Lebanon', dial: '+961'},
    {code: 'ls', name: 'Lesotho', dial: '+266'},
    {code: 'lr', name: 'Liberia', dial: '+231'},
    {code: 'ly', name: 'Libya', dial: '+218'},
    {code: 'li', name: 'Liechtenstein', dial: '+423'},
    {code: 'lt', name: 'Lithuania', dial: '+370'},
    {code: 'lu', name: 'Luxembourg', dial: '+352'},
    {code: 'mo', name: 'Macau', dial: '+853'},
    {code: 'mk', name: 'North Macedonia', dial: '+389'},
    {code: 'mg', name: 'Madagascar', dial: '+261'},
    {code: 'mw', name: 'Malawi', dial: '+265'},
    {code: 'my', name: 'Malaysia', dial: '+60'},
    {code: 'mv', name: 'Maldives', dial: '+960'},
    {code: 'ml', name: 'Mali', dial: '+223'},
    {code: 'mt', name: 'Malta', dial: '+356'},
    {code: 'mh', name: 'Marshall Islands', dial: '+692'},
    {code: 'mr', name: 'Mauritania', dial: '+222'},
    {code: 'mu', name: 'Mauritius', dial: '+230'},
    {code: 'yt', name: 'Mayotte', dial: '+262'},
    {code: 'mx', name: 'Mexico', dial: '+52'},
    {code: 'fm', name: 'Micronesia', dial: '+691'},
    {code: 'md', name: 'Moldova', dial: '+373'},
    {code: 'mc', name: 'Monaco', dial: '+377'},
    {code: 'mn', name: 'Mongolia', dial: '+976'},
    {code: 'me', name: 'Montenegro', dial: '+382'},
    {code: 'ms', name: 'Montserrat', dial: '+1664'},
    {code: 'ma', name: 'Morocco', dial: '+212'},
    {code: 'mz', name: 'Mozambique', dial: '+258'},
    {code: 'mm', name: 'Myanmar', dial: '+95'},
    {code: 'na', name: 'Namibia', dial: '+264'},
    {code: 'nr', name: 'Nauru', dial: '+674'},
    {code: 'np', name: 'Nepal', dial: '+977'},
    {code: 'nl', name: 'Netherlands', dial: '+31'},
    {code: 'nc', name: 'New Caledonia', dial: '+687'},
    {code: 'nz', name: 'New Zealand', dial: '+64'},
    {code: 'ni', name: 'Nicaragua', dial: '+505'},
    {code: 'ne', name: 'Niger', dial: '+227'},
    {code: 'ng', name: 'Nigeria', dial: '+234'},
    {code: 'nu', name: 'Niue', dial: '+683'},
    {code: 'kp', name: 'North Korea', dial: '+850'},
    {code: 'mp', name: 'Northern Mariana Islands', dial: '+1670'},
    {code: 'no', name: 'Norway', dial: '+47'},
    {code: 'om', name: 'Oman', dial: '+968'},
    {code: 'pk', name: 'Pakistan', dial: '+92'},
    {code: 'pw', name: 'Palau', dial: '+680'},
    {code: 'ps', name: 'Palestine', dial: '+970'},
    {code: 'pa', name: 'Panama', dial: '+507'},
    {code: 'pg', name: 'Papua New Guinea', dial: '+675'},
    {code: 'py', name: 'Paraguay', dial: '+595'},
    {code: 'pe', name: 'Peru', dial: '+51'},
    {code: 'ph', name: 'Philippines', dial: '+63'},
    {code: 'pn', name: 'Pitcairn', dial: '+64'},
    {code: 'pl', name: 'Poland', dial: '+48'},
    {code: 'pt', name: 'Portugal', dial: '+351'},
    {code: 'pr', name: 'Puerto Rico', dial: '+1787'},
    {code: 'qa', name: 'Qatar', dial: '+974'},
    {code: 'cg', name: 'Republic of the Congo', dial: '+242'},
    {code: 're', name: 'Reunion', dial: '+262'},
    {code: 'ro', name: 'Romania', dial: '+40'},
    {code: 'ru', name: 'Russia', dial: '+7'},
    {code: 'rw', name: 'Rwanda', dial: '+250'},
    {code: 'bl', name: 'Saint Barthelemy', dial: '+590'},
    {code: 'sh', name: 'Saint Helena', dial: '+290'},
    {code: 'kn', name: 'Saint Kitts and Nevis', dial: '+1869'},
    {code: 'lc', name: 'Saint Lucia', dial: '+1758'},
    {code: 'mf', name: 'Saint Martin', dial: '+590'},
    {code: 'pm', name: 'Saint Pierre and Miquelon', dial: '+508'},
    {code: 'vc', name: 'Saint Vincent and the Grenadines', dial: '+1784'},
    {code: 'ws', name: 'Samoa', dial: '+685'},
    {code: 'sm', name: 'San Marino', dial: '+378'},
    {code: 'st', name: 'Sao Tome and Principe', dial: '+239'},
    {code: 'sa', name: 'Saudi Arabia', dial: '+966'},
    {code: 'sn', name: 'Senegal', dial: '+221'},
    {code: 'rs', name: 'Serbia', dial: '+381'},
    {code: 'sc', name: 'Seychelles', dial: '+248'},
    {code: 'sl', name: 'Sierra Leone', dial: '+232'},
    {code: 'sg', name: 'Singapore', dial: '+65'},
    {code: 'sx', name: 'Sint Maarten', dial: '+1721'},
    {code: 'sk', name: 'Slovakia', dial: '+421'},
    {code: 'si', name: 'Slovenia', dial: '+386'},
    {code: 'sb', name: 'Solomon Islands', dial: '+677'},
    {code: 'so', name: 'Somalia', dial: '+252'},
    {code: 'za', name: 'South Africa', dial: '+27'},
    {code: 'kr', name: 'South Korea', dial: '+82'},
    {code: 'ss', name: 'South Sudan', dial: '+211'},
    {code: 'es', name: 'Spain', dial: '+34'},
    {code: 'lk', name: 'Sri Lanka', dial: '+94'},
    {code: 'sd', name: 'Sudan', dial: '+249'},
    {code: 'sr', name: 'Suriname', dial: '+597'},
    {code: 'sj', name: 'Svalbard and Jan Mayen', dial: '+47'},
    {code: 'sz', name: 'Swaziland', dial: '+268'},
    {code: 'se', name: 'Sweden', dial: '+46'},
    {code: 'ch', name: 'Switzerland', dial: '+41'},
    {code: 'sy', name: 'Syria', dial: '+963'},
    {code: 'tw', name: 'Taiwan', dial: '+886'},
    {code: 'tj', name: 'Tajikistan', dial: '+992'},
    {code: 'tz', name: 'Tanzania', dial: '+255'},
    {code: 'th', name: 'Thailand', dial: '+66'},
    {code: 'tg', name: 'Togo', dial: '+228'},
    {code: 'tk', name: 'Tokelau', dial: '+690'},
    {code: 'to', name: 'Tonga', dial: '+676'},
    {code: 'tt', name: 'Trinidad and Tobago', dial: '+1868'},
    {code: 'tn', name: 'Tunisia', dial: '+216'},
    {code: 'tr', name: 'Turkey', dial: '+90'},
    {code: 'tm', name: 'Turkmenistan', dial: '+993'},
    {code: 'tc', name: 'Turks and Caicos Islands', dial: '+1649'},
    {code: 'tv', name: 'Tuvalu', dial: '+688'},
    {code: 'vi', name: 'U.S. Virgin Islands', dial: '+1340'},
    {code: 'ug', name: 'Uganda', dial: '+256'},
    {code: 'ua', name: 'Ukraine', dial: '+380'},
    {code: 'ae', name: 'United Arab Emirates', dial: '+971'},
    {code: 'gb', name: 'United Kingdom', dial: '+44'},
    {code: 'us', name: 'United States', dial: '+1'},
    {code: 'uy', name: 'Uruguay', dial: '+598'},
    {code: 'uz', name: 'Uzbekistan', dial: '+998'},
    {code: 'vu', name: 'Vanuatu', dial: '+678'},
    {code: 'va', name: 'Vatican', dial: '+379'},
    {code: 've', name: 'Venezuela', dial: '+58'},
    {code: 'vn', name: 'Vietnam', dial: '+84'},
    {code: 'wf', name: 'Wallis and Futuna', dial: '+681'},
    {code: 'eh', name: 'Western Sahara', dial: '+212'},
    {code: 'ye', name: 'Yemen', dial: '+967'},
    {code: 'zm', name: 'Zambia', dial: '+260'},
    {code: 'zw', name: 'Zimbabwe', dial: '+263'}
];

// DOM Elements
const countrySelector = document.getElementById('countrySelector');
const countryDropdown = document.getElementById('countryDropdown');
const countrySearch = document.getElementById('countrySearch');
const countryList = document.getElementById('countryList');
const selectedFlag = document.getElementById('selectedFlag');
const selectedCountryCode = document.getElementById('selectedCountryCode');

const phoneNumberInput = document.querySelector('[name="phone_display"]');
const selectedCountryCodeHidden = document.querySelector('[name="phone_country_code"]');
const phoneNumberHidden = document.querySelector('[name="phone_number"]');

const phoneInputWrapper = document.getElementById('phoneInputWrapper') ||
    document.querySelector('.input-group.border.rounded');


const validationMessage = document.getElementById('validationMessage');
const fullPhoneNumber = document.getElementById('fullPhoneNumber');
const form = document.getElementById('profileForm');

// Current selected country
let selectedCountry = countries[0];
let highlightedIndex = -1;

// Calculate the width of the dropdown based on the longest content
function calculateDropdownWidth() {
    // Create a temporary element to measure text width
    const tempEl = document.createElement('div');
    tempEl.style.position = 'absolute';
    tempEl.style.visibility = 'hidden';
    tempEl.style.whiteSpace = 'nowrap';
    tempEl.style.fontSize = '14px'; // Fixed font size for consistent measurement
    tempEl.style.padding = '8px 12px';
    document.body.appendChild(tempEl);

    // Find the longest country name
    let maxNameWidth = 0;
    countries.forEach(country => {
        tempEl.textContent = country.name;
        const width = tempEl.offsetWidth;
        if (width > maxNameWidth) maxNameWidth = width;
    });

    // Find the longest dial code
    let maxDialWidth = 0;
    countries.forEach(country => {
        tempEl.textContent = country.dial;
        const width = tempEl.offsetWidth;
        if (width > maxDialWidth) maxDialWidth = width;
    });

    // Clean up
    document.body.removeChild(tempEl);

    // Calculate total width: flag (24px) + margins (8px + auto) + name + dial + padding
    return 24 + 8 + maxNameWidth + maxDialWidth + 24; // 24px padding on each side
}

// Set dropdown width with a maximum limit
const calculatedWidth = calculateDropdownWidth();
const maxDropdownWidth = 300; // You can adjust this maximum width as needed
countryDropdown.style.width = `${Math.min(calculatedWidth, maxDropdownWidth)}px`;


// Render country list
function renderCountryList(filter = '') {
    countryList.innerHTML = '';
    const filteredCountries = countries.filter(country =>
        country.name.toLowerCase().includes(filter.toLowerCase()) ||
        country.dial.includes(filter)
    );

    filteredCountries.forEach((country, index) => {
        const li = document.createElement('li');
        li.className = 'country-item';
        li.innerHTML = `
          <span class="fi fi-${country.code}"></span>
          <span class="country-name">${country.name}</span>
          <span class="country-dial">${country.dial}</span>
        `;
        li.addEventListener('click', () => {
            selectCountry(country);
            closeDropdown();
        });

        li.addEventListener('mouseover', () => {
            highlightItem(index);
        });

        countryList.appendChild(li);
    });

    highlightedIndex = -1;
}

// Highlight item in the list
function highlightItem(index) {
    const items = countryList.querySelectorAll('.country-item');

    // Remove highlight from all items
    items.forEach(item => {
        item.classList.remove('highlighted');
    });

    // Add highlight to selected item
    if (index >= 0 && index < items.length) {
        items[index].classList.add('highlighted');
        items[index].scrollIntoView({block: 'nearest'});
        highlightedIndex = index;
    }
}


// Handle keyboard navigation
function handleKeyboardNavigation(e) {
    if (countryDropdown.style.display !== 'block') return;

    const items = countryList.querySelectorAll('.country-item');
    if (items.length === 0) return;

    switch (e.key) {
        case 'ArrowDown':
            e.preventDefault();
            highlightItem((highlightedIndex + 1) % items.length);
            break;
        case 'ArrowUp':
            e.preventDefault();
            highlightItem((highlightedIndex - 1 + items.length) % items.length);
            break;
        case 'Enter':
            if (highlightedIndex >= 0) {
                e.preventDefault();
                const country = countries.find(c =>
                    c.name === items[highlightedIndex].querySelector('span:nth-child(2)').textContent
                );
                if (country) {
                    selectCountry(country);
                    closeDropdown();
                }
            }
            break;
        case 'Escape':
            closeDropdown();
            break;
    }
}

// Set dropdown width to match the country selector button
function setDropdownWidth() {
    const buttonWidth = countrySelector.offsetWidth;
    countryDropdown.style.width = `${buttonWidth}px`;
}

// Open dropdown function
function openDropdown() {
    setDropdownWidth();
    countryDropdown.style.display = 'block';
    countrySearch.focus();
    renderCountryList();
}

// Close dropdown function
function closeDropdown() {
    countryDropdown.style.display = 'none';
    highlightedIndex = -1;
}

// Toggle dropdown
function toggleDropdown() {
    if (countryDropdown.style.display === 'block') {
        closeDropdown();
    } else {
        openDropdown();
    }
}

// Initialize
setDropdownWidth(); // Set initial width
window.addEventListener('resize', setDropdownWidth); // Adjust on resize
//-----------------------------------------------------------

// Event listeners
countrySelector.addEventListener('click', toggleDropdown);

document.addEventListener('click', (e) => {
    if (!countrySelector.contains(e.target) &&
        !countryDropdown.contains(e.target)) {
        closeDropdown();
    }
});

countrySearch.addEventListener('input', (e) => {
    renderCountryList(e.target.value);
});

phoneNumberInput.addEventListener('input', (e) => {
    let numbers = e.target.value.replace(/\D/g, '');
    numbers = numbers.substring(0, 15);
    e.target.value = numbers;
    validatePhoneNumber();
});

phoneNumberInput.addEventListener('keydown', (e) => {
    if ([46, 8, 9, 27, 13].includes(e.keyCode) ||
        (e.keyCode === 65 && e.ctrlKey === true) ||
        (e.keyCode === 67 && e.ctrlKey === true) ||
        (e.keyCode === 86 && e.ctrlKey === true) ||
        (e.keyCode === 88 && e.ctrlKey === true) ||
        (e.keyCode >= 35 && e.keyCode <= 39)) {
        return;
    }
    if ((e.shiftKey || (e.keyCode < 48 || e.keyCode > 57)) &&
        (e.keyCode < 96 || e.keyCode > 105)) {
        e.preventDefault();
    }
});


// Add keyboard event listener
document.addEventListener('keydown', handleKeyboardNavigation);

// Initialize
renderCountryList();

//================================ Use Mix of js and forms.py ================================================
// Add real-time validation
phoneNumberInput.addEventListener('input', function (e) {
    validatePhoneNumber();
});

export function validatePhoneNumber() {
    const phoneNumber = phoneNumberInput.value.replace(/\D/g, ''); // Remove non-digits
    const isValid = phoneNumber.length >= 8 && phoneNumber.length <= 15;

    // Update UI
    if (phoneNumber && !isValid) {
        phoneInputWrapper.classList.add('is-invalid');
        showValidationError('Phone number must be 8-15 digits');
        return false;
    } else {
        phoneInputWrapper.classList.remove('is-invalid');
        hideValidationError();
        return true;
    }
}

function showValidationError(message) {
    const errorElement = document.getElementById('phoneError');
    if (errorElement) {
        errorElement.textContent = message;
        errorElement.style.display = 'block';
    }
}

function hideValidationError() {
    const errorElement = document.getElementById('phoneError');
    if (errorElement) {
        errorElement.style.display = 'none';
    }
}

// Enhanced form submission handler
form.addEventListener('submit', function (e) {
    // Get and clean the phone number
    const rawPhone = phoneNumberInput.value;
    const cleanPhone = rawPhone.replace(/\D/g, '');

    // Update fields
    phoneNumberHidden.value = cleanPhone;
    phoneNumberInput.value = cleanPhone;

    // Validate before submission
    if (!validatePhoneNumber()) {
        e.preventDefault();
        showValidationError('Please correct the phone number (8-15 digits)');
        return false;
    }

    return true;
});
// Update form submission handler
// form.addEventListener('submit', function(e) {
//     // 1. Get and clean the phone number
//     const rawPhone = phoneNumberInput.value;
//     const cleanPhone = rawPhone.replace(/\D/g, ''); // Remove all non-digits
//
//     // 2. Update BOTH the hidden field AND the display field
//     phoneNumberHidden.value = cleanPhone; // This updates the actual submitted value
//     phoneNumberInput.value = cleanPhone;  // This updates the visible field
//
//     // 3. Debug output
//     console.log('Phone values:', {
//         display: phoneNumberInput.value,
//         hidden: phoneNumberHidden.value,
//         country: selectedCountryCodeHidden.value
//     });
//
//     // 4. Final validation
//     if (cleanPhone.length < 8 || cleanPhone.length > 15) {
//         e.preventDefault();
//         showValidationError('Phone number must be 8-15 digits');
//     }
// });


document.addEventListener('DOMContentLoaded', function () {
    // Get the current values from hidden fields
    const currentCountryCode = selectedCountryCodeHidden ? selectedCountryCodeHidden.value : '+1';
    const currentPhoneNumber = phoneNumberHidden ? phoneNumberHidden.value : '';

    // Set initial country
    const initialCountry = countries.find(c => c.dial === currentCountryCode) || countries[0];
    selectCountry(initialCountry);

    // Set initial phone number
    if (phoneNumberInput && currentPhoneNumber) {
        phoneNumberInput.value = currentPhoneNumber;
    }
});

// Modify your existing selectCountry function to update the hidden field
function selectCountry(country) {
    selectedCountry = country;
    selectedFlag.className = `fi fi-${country.code}`;
    selectedCountryCode.textContent = country.dial;
    selectedCountryCodeHidden.value = country.dial;
    phoneNumberInput.focus();
    validatePhoneNumber();
}