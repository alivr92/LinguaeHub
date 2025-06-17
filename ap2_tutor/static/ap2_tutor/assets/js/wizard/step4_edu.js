// document.addEventListener("DOMContentLoaded", function() {
//     console.log("[1] DOM fully loaded");
//
//     // 1. Select element verification
//     const selectElement = document.getElementById('teachingCategoriesSelect');
//     if (!selectElement) {
//         console.error("[ERROR] Select element not found!");
//         return;
//     }
//     console.log("[2] Select element found:", selectElement);
//
//     // 2. Check if Choices is already initialized
//     if (selectElement._choices) {
//         console.warn("[WARNING] Choices already initialized on this element. Current instance:", selectElement._choices);
//         console.log("[DEBUG] Removing previous Choices instance...");
//         const existingChoices = selectElement._choices;
//         existingChoices.destroy();
//         console.log("[DEBUG] Previous instance destroyed");
//     }
//
//     // 3. Initialize Choices with debug options
//     console.log("[3] Initializing new Choices instance...");
//     try {
//         const choice = new Choices(selectElement, {
//             removeItemButton: true,
//             maxItemCount: 5,
//             allowHTML: false, // Explicitly set to avoid deprecation warning
//             silent: false, // Show all warnings
//             callbackOnInit: function() {
//                 console.log("[4] Choices initialized successfully", this);
//             }
//         });
//
//         // Store reference for debugging
//         window.debugChoices = choice;
//         console.log("[5] Choices instance stored in window.debugChoices");
//
//         // 4. Fetch data
//         console.log("[6] Fetching categories from API...");
//         fetch("/tutor/get-categories/")
//             .then(response => {
//                 console.log("[7] API response received. Status:", response.status);
//                 if (!response.ok) {
//                     throw new Error(`HTTP ${response.status}`);
//                 }
//                 return response.json();
//             })
//             .then(data => {
//                 console.log("[8] API data received:", data);
//
//                 // 5. Validate data structure
//                 if (!data.categories || !Array.isArray(data.categories)) {
//                     throw new Error("Invalid data format - missing categories array");
//                 }
//
//                 // 6. Prepare choices array
//                 const choices = [];
//                 console.log("[9] Processing categories...");
//
//                 data.categories.forEach((category, catIndex) => {
//                     console.log(`[10] Processing category ${catIndex}:`, category.category);
//
//                     if (!category.subcategories || !Array.isArray(category.subcategories)) {
//                         console.warn(`[WARNING] Category ${category.category} has no valid subcategories`);
//                         return;
//                     }
//
//                     category.subcategories.forEach((subcategory, subIndex) => {
//                         console.log(`[11] Processing subcategory ${subIndex}:`, subcategory.name);
//
//                         if (!subcategory.id || !subcategory.name) {
//                             console.warn("[WARNING] Invalid subcategory format:", subcategory);
//                             return;
//                         }
//
//                         choices.push({
//                             value: subcategory.id.toString(),
//                             label: subcategory.name,
//                             customProperties: {
//                                 category: category.category
//                             }
//                         });
//                     });
//                 });
//
//                 console.log("[12] Final choices array:", choices);
//
//                 // 7. Set choices
//                 if (choices.length > 0) {
//                     console.log("[13] Setting choices...");
//                     choice.setChoices(choices, 'value', 'label', false);
//                     console.log("[14] Choices set successfully");
//                 } else {
//                     console.warn("[WARNING] No valid choices to set");
//                     choice.setChoices([{
//                         value: '',
//                         label: 'No categories available',
//                         disabled: true
//                     }]);
//                 }
//             })
//             .catch(error => {
//                 console.error("[ERROR] In fetch/processing chain:", error);
//                 if (choice && typeof choice.setChoices === 'function') {
//                     choice.setChoices([{
//                         value: '',
//                         label: 'Error loading categories',
//                         disabled: true
//                     }]);
//                 }
//             });
//     } catch (initError) {
//         console.error("[ERROR] Choices initialization failed:", initError);
//     }
// });


//
// document.addEventListener("DOMContentLoaded", function() {
//     // 1. Get select element
//     const selectElement = document.getElementById('teachingCategoriesSelect');
//     if (!selectElement) {
//         console.error("Select element not found");
//         return;
//     }
//
//     // 2. Clean up any existing Choices instance
//     if (selectElement._choices) {
//         console.log("Cleaning up existing Choices instance");
//         selectElement._choices.destroy();
//         selectElement._choices = undefined;
//     }
//
//     // 3. Initialize Choices with minimal config
//     console.log("Initializing new Choices instance");
//     const choice = new Choices(selectElement, {
//         removeItemButton: true,
//         maxItemCount: 5,
//         allowHTML: false,
//         silent: true, // Temporarily suppress warnings
//         callbackOnInit: function() {
//             console.log("Choices initialized successfully");
//             loadCategories(this); // Pass the instance
//         }
//     });
//
//     // Store reference for debugging
//     window.choiceInstance = choice;
// });
//
// function loadCategories(choicesInstance) {
//     console.log("Starting to load categories");
//
//     // Show loading state
//     choicesInstance.setChoices([{
//         value: '',
//         label: 'Loading categories...',
//         disabled: true
//     }], 'value', 'label', false);
//
//     fetch("/tutor/get-categories/")
//         .then(response => {
//             if (!response.ok) throw new Error(`HTTP ${response.status}`);
//             return response.json();
//         })
//         .then(data => {
//             console.log("Received categories data:", data);
//
//             // Process data into choices format
//             const options = [];
//             data.categories.forEach(category => {
//                 if (category.subcategories && category.subcategories.length) {
//                     category.subcategories.forEach(subcategory => {
//                         options.push({
//                             value: subcategory.id.toString(),
//                             label: subcategory.name,
//                             customProperties: {
//                                 category: category.category
//                             }
//                         });
//                     });
//                 }
//             });
//
//             console.log("Processed options:", options);
//
//             // Set the new choices
//             if (options.length) {
//                 choicesInstance.setChoices(options, 'value', 'label', false);
//                 console.log("Choices updated successfully");
//             } else {
//                 choicesInstance.setChoices([{
//                     value: '',
//                     label: 'No categories available',
//                     disabled: true
//                 }], 'value', 'label', false);
//             }
//         })
//         .catch(error => {
//             console.error("Error loading categories:", error);
//             choicesInstance.setChoices([{
//                 value: '',
//                 label: 'Error loading categories',
//                 disabled: true
//             }], 'value', 'label', false);
//         });
// }


//==========================================================================================================
// document.addEventListener("DOMContentLoaded", function() {
//     const selectElement = document.getElementById('teachingCategoriesSelect');
//
//     // First load all options normally
//     fetch("/tutor/get-categories/")
//         .then(response => response.json())
//         .then(data => {
//             // Clear existing options
//             selectElement.innerHTML = '';
//
//             // Add options directly to DOM
//             data.categories.forEach(category => {
//                 category.subcategories.forEach(subcategory => {
//                     const option = document.createElement('option');
//                     option.value = subcategory.id;
//                     option.textContent = subcategory.name;
//                     selectElement.appendChild(option);
//                 });
//             });
//
//             // Initialize Choices AFTER options are loaded
//             new Choices(selectElement, {
//                 removeItemButton: true,
//                 maxItemCount: 5,
//                 allowHTML: false
//             });
//         })
//         .catch(error => {
//             console.error("Error:", error);
//             selectElement.innerHTML = '<option value="" disabled>Error loading categories</option>';
//             new Choices(selectElement);
//         });
// });
//==========================================================================================================
// document.addEventListener("DOMContentLoaded", function() {
//     // 1. First get the select element
//     const selectElement = document.getElementById('teachingCategoriesSelect');
//     if (!selectElement) {
//         console.error("Select element not found");
//         return;
//     }
//
//     // 2. Show loading state
//     selectElement.innerHTML = '<option value="" disabled>Loading categories...</option>';
//
//     // 3. Fetch data first (without Choices initialization)
//     fetch("/tutor/get-categories/")
//         .then(response => {
//             if (!response.ok) throw new Error(`HTTP ${response.status}`);
//             return response.json();
//         })
//         .then(data => {
//             console.log("Received categories data:", data);
//
//             // 4. Process data into static array
//             const staticOptions = [];
//             data.categories.forEach(category => {
//                 if (category.subcategories && category.subcategories.length) {
//                     category.subcategories.forEach(subcategory => {
//                         staticOptions.push({
//                             value: subcategory.id.toString(),
//                             label: subcategory.name,
//                             customProperties: {
//                                 category: category.category
//                             }
//                         });
//                     });
//                 }
//             });
//
//             console.log("Static options array:", staticOptions);
//
//             // 5. Clear and rebuild select element
//             selectElement.innerHTML = '';
//             staticOptions.forEach(option => {
//                 const optElement = document.createElement('option');
//                 optElement.value = option.value;
//                 optElement.textContent = option.label;
//                 selectElement.appendChild(optElement);
//             });
//
//             // 6. NOW initialize Choices
//             console.log("Initializing Choices with static data");
//             new Choices(selectElement, {
//                 removeItemButton: true,
//                 maxItemCount: 5,
//                 allowHTML: false,
//                 silent: true
//             });
//
//             console.log("Choices initialized successfully");
//         })
//         .catch(error => {
//             console.error("Error loading categories:", error);
//             selectElement.innerHTML = '<option value="" disabled>Error loading categories</option>';
//             new Choices(selectElement);
//         });
// });
//==========================================================================================================
document.addEventListener("DOMContentLoaded", function () {
    const selectElement = document.getElementById('teachingCategoriesSelect');
    const choice = new Choices(selectElement, {
        removeItemButton: true,
        maxItemCount: 5,
        shouldSort: false,
        duplicateItemsAllowed: false
    });

    fetch("/tutor/get-categories/")
        .then(response => response.json())
        .then(data => {
            choice.clearChoices();

            const allChoices = [];

            data.categories.forEach(category => {
                // Add optgroup label as a disabled item (not a real optgroup tag)
                allChoices.push({
                    value: '',
                    label: category.category,
                    disabled: true,
                    customProperties: { isHeader: true }
                });

                // Add subcategories
                const subcategoryOptions = category.subcategories.map(sub => ({
                    value: sub.id,
                    label: sub.name,
                    customProperties: {
                        parentCategory: category.category
                    }
                }));

                allChoices.push(...subcategoryOptions);
            });

            // Now set all choices at once
            choice.setChoices(allChoices, 'value', 'label', false);

            // Preselect values if needed
            const preselectedValues = []; // e.g., [1, 3, 5]
            if (preselectedValues.length > 0) {
                choice.setValue(preselectedValues);
            }
        })
        .catch(error => console.error("Error:", error));
});

//==========================================================================================================