// document.addEventListener('DOMContentLoaded', function() {
//     const phoneCountrySelect = document.querySelector('select[name="phone_country_code"]');
//
//     if (phoneCountrySelect) {
//         // Function to extract country code from label (format: "Country (XX) +123")
//         function getFlagCode(label) {
//             try {
//                 const codeMatch = label.match(/\(([A-Z]{2})\)/);
//                 return codeMatch ? codeMatch[1].toLowerCase() : 'un';
//             } catch {
//                 return 'un';
//             }
//         }
//
//         // Initialize Choices with custom templates
//         new Choices(phoneCountrySelect, {
//             searchEnabled: true,
//             removeItemButton: true,
//             shouldSort: true,
//             itemSelectText: '',
//             searchResultLimit: 10,
//             classNames: {
//                 containerInner: 'choices__inner',
//                 input: 'choices__input',
//                 item: 'choices__item',
//                 button: 'choices__button'
//             },
//             callbackOnCreateTemplates: function(template) {
//                 return {
//                     item: (classNames, data) => {
//                         const flagCode = getFlagCode(data.label);
//                         return template(`
//                             <div class="${classNames.item} choices__item--selectable"
//                                  data-item data-id="${data.id}" data-value="${data.value}">
//                                 <span class="fi fi-${flagCode} flag-icon"></span>
//                                 ${data.value} ${data.label.split('(')[0].trim()}
//                             </div>
//                         `);
//                     },
//                     choice: (classNames, data) => {
//                         const flagCode = getFlagCode(data.label);
//                         return template(`
//                             <div class="${classNames.item} choices__item--choice"
//                                  data-choice data-id="${data.id}" data-value="${data.value}">
//                                 <span class="fi fi-${flagCode} flag-icon"></span>
//                                 ${data.label}
//                             </div>
//                         `);
//                     }
//                 };
//             }
//         });
//
//         // Update selected display to show only flag + code
//         const updateSelectedDisplay = () => {
//             const selectedValue = phoneCountrySelect.value;
//             const selectedOption = phoneCountrySelect.querySelector(`option[value="${selectedValue}"]`);
//             if (selectedOption) {
//                 const flagCode = getFlagCode(selectedOption.textContent);
//                 const selectedItem = phoneCountrySelect.parentElement.querySelector('.choices__item');
//                 if (selectedItem) {
//                     selectedItem.innerHTML = `
//                         <span class="fi fi-${flagCode} flag-icon"></span>
//                         ${selectedValue}
//                     `;
//                 }
//             }
//         };
//
//         // Initial update
//         updateSelectedDisplay();
//         phoneCountrySelect.addEventListener('change', updateSelectedDisplay);
//     }
//
//     // Phone number validation
//     const phoneInput = document.querySelector('input[name="phone_number"]');
//     phoneInput?.addEventListener('input', function() {
//         this.value = this.value.replace(/\D/g, '').substring(0, 15);
//     });
// });
//-----------------------------------------------------------------------------------------------------
document.addEventListener('DOMContentLoaded', function () {
    const phoneCountrySelect = document.querySelector('select[name="phone_country_code"]');

    if (phoneCountrySelect) {
        // Function to extract components from label (format: "Country (XX) +123")
        function parseCountryLabel(label) {
            const match = label.match(/^(.*?)\s*\(([A-Z]{2})\)\s*(\+\d+)$/);
            return {
                name: match ? match[1].trim() : label,
                code: match ? match[2] : '',
                dial: match ? match[3] : ''
            };
        }

        // Initialize Choices with custom templates
        new Choices(phoneCountrySelect, {
            searchEnabled: true,
            removeItemButton: true,
            shouldSort: true,
            itemSelectText: '',
            searchResultLimit: 10,
            callbackOnCreateTemplates: function (template) {
                return {
                    item: (classNames, data) => {
                        const country = parseCountryLabel(data.label);
                        return template(`
                            <div class="${classNames.item} choices__item--selectable" 
                                 data-item data-id="${data.id}" data-value="${data.value}">
                                <span class="fi fi-${country.code.toLowerCase()} flag-icon"></span>
                                <span class="country-info">
                                    ${country.name} (${country.code}) ${country.dial}
                                </span>
                            </div>
                        `);
                    },
                    choice: (classNames, data) => {
                        const country = parseCountryLabel(data.label);
                        return template(`
                            <div class="${classNames.item} choices__item--choice" 
                                 data-choice data-id="${data.id}" data-value="${data.value}">
                                <span class="fi fi-${country.code.toLowerCase()} flag-icon"></span>
                                <span class="country-info">
                                    ${country.name} (${country.code}) ${country.dial}
                                </span>
                            </div>
                        `);
                    }
                };
            }
        });

        // Update selected display to show only flag + code
        const updateSelectedDisplay = () => {
            const selectedValue = phoneCountrySelect.value;
            const selectedOption = phoneCountrySelect.querySelector(`option[value="${selectedValue}"]`);
            if (selectedOption) {
                const country = parseCountryLabel(selectedOption.textContent);
                const selectedItem = phoneCountrySelect.parentElement.querySelector('.choices__item');
                if (selectedItem) {
                    selectedItem.innerHTML = `
                        <span class="fi fi-${country.code.toLowerCase()} flag-icon"></span>
                        ${country.dial}
                    `;
                }
            }
        };

        // Initial update
        updateSelectedDisplay();
        phoneCountrySelect.addEventListener('change', updateSelectedDisplay);
    }
});
//------------------------------------------------------------------------------------------------------