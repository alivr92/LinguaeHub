document.addEventListener('DOMContentLoaded', function () {
    // Function to validate a single field
    function validateField(field) {
        if (field.required && !field.value.trim()) {
            field.classList.add('is-invalid');  // Add invalid class
            return false;  // Field is invalid
        } else {
            field.classList.remove('is-invalid');  // Remove invalid class
            return true;  // Field is valid
        }
    }

    // Function to validate all required fields in a form
    function validateForm(form) {
        let isValid = true;
        const requiredFields = form.querySelectorAll('input[required], select[required], textarea[required]');

        requiredFields.forEach(function (field) {
            if (!validateField(field)) {
                isValid = false;  // Form is invalid
            }
        });

        return isValid;
    }

    // Attach validation to form submission
    const forms = document.querySelectorAll('.needs-validation');
    forms.forEach(function (form) {
        form.addEventListener('submit', function (event) {
            if (!validateForm(form)) {
                event.preventDefault();  // Prevent form submission
                event.stopPropagation();
            }

            form.classList.add('was-validated');  // Show validation feedback
        }, false);
    });

    // Handle Choices.js fields
    const choiceSelects = document.querySelectorAll('.js-choice');
    choiceSelects.forEach(function (select) {
        const choices = new Choices(select, {
            removeItemButton: true,
            searchEnabled: true,
            placeholderValue: 'Select an option',
            shouldSort: false,
            allowHTML: true,
        });

        // Sync validation state with Bootstrap
        select.addEventListener('change', function () {
            validateField(select);  // Validate the field on change
        });
    });
});
// JavaScript for Bootstrap validation
(function () {
    'use strict';

    // Fetch all forms with the .needs-validation class
    var forms = document.querySelectorAll('.needs-validation');

    // Loop over them and prevent submission if invalid
    Array.prototype.slice.call(forms).forEach(function (form) {
        form.addEventListener('submit', function (event) {
            if (!form.checkValidity()) {
                event.preventDefault();
                event.stopPropagation();

                // Manually trigger validation for Choices.js fields
                var customSelects = form.querySelectorAll('.js-choice');
                customSelects.forEach(function (select) {
                    if (!select.validity.valid) {
                        select.classList.add('is-invalid');
                    }
                });
            }

            // Add the 'was-validated' class to show validation feedback
            form.classList.add('was-validated');
        }, false);
    });
})();


// Upload or Remove profile photo
document.getElementById('uploadfile-1').addEventListener('change', function (event) {
    var reader = new FileReader();
    reader.onload = function () {
        var output = document.getElementById('uploadfile-1-preview');
        output.src = reader.result;
    };
    reader.readAsDataURL(event.target.files[0]);
});

document.querySelector('.uploadremove').addEventListener('click', function () {
    var output = document.getElementById('uploadfile-1-preview');
    var fileInput = document.getElementById('uploadfile-1');
    var deletePhotoInput = document.getElementById('delete-photo');


    // Set the image source to a placeholder or empty value
    output.src = '/static/assets/images/default.png';

    // Clear the file input value
    fileInput.value = '';

    // Indicate that the photo should be deleted
    deletePhotoInput.value = 'true';
});