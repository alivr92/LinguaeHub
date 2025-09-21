document.addEventListener('DOMContentLoaded', function() {
    // ===================== Existing Validation Code =====================
    function validateField(field) {
        if (field.required && !field.value.trim()) {
            field.classList.add('is-invalid');
            return false;
        } else {
            field.classList.remove('is-invalid');
            return true;
        }
    }

    function validateForm(form) {
        let isValid = true;
        const requiredFields = form.querySelectorAll('input[required], select[required], textarea[required]');
        requiredFields.forEach(function(field) {
            if (!validateField(field)) isValid = false;
        });
        return isValid;
    }

    const forms = document.querySelectorAll('.needs-validation');
    forms.forEach(function(form) {
        form.addEventListener('submit', function(event) {
            if (!validateForm(form)) {
                event.preventDefault();
                event.stopPropagation();
            }
            form.classList.add('was-validated');
        }, false);
    });

    // ===================== Photo Upload + Cropping =====================
    const fileInput = document.getElementById('uploadfile-1');
    const previewImg = document.getElementById('uploadfile-1-preview');
    let cropper;

    fileInput.addEventListener('change', function(e) {
        if (e.target.files && e.target.files.length) {
            const reader = new FileReader();

            reader.onload = function(event) {
                // Create temporary image to check dimensions
                const tempImg = new Image();
                tempImg.onload = function() {
                    // Skip cropping if image is already square and small
                    if (tempImg.width === tempImg.height && tempImg.width <= 500) {
                        previewImg.src = event.target.result;
                        return;
                    }

                    // Show cropping modal
                    const modal = new bootstrap.Modal('#cropModal');
                    const imageToCrop = document.getElementById('imageToCrop');
                    imageToCrop.src = event.target.result;
                    modal.show();

                    // Initialize cropper when modal is shown
                    modal._element.addEventListener('shown.bs.modal', function() {
                        if (cropper) cropper.destroy();

                        cropper = new Cropper(imageToCrop, {
                            aspectRatio: 1,
                            viewMode: 1,
                            autoCropArea: 0.8,
                            responsive: true
                        });
                    }, {once: true});
                };
                tempImg.src = event.target.result;
            };
            reader.readAsDataURL(e.target.files[0]);
        }
    });

    // Handle crop button
    document.getElementById('cropButton')?.addEventListener('click', function() {
        if (cropper) {
            const canvas = cropper.getCroppedCanvas({
                width: 500,
                height: 500,
                fillColor: '#fff'
            });

            // Update the original preview image
            previewImg.src = canvas.toDataURL('image/jpeg');

            // Close modal
            bootstrap.Modal.getInstance(document.getElementById('cropModal')).hide();
        }
    });

    // ===================== Existing Photo Removal =====================
    document.querySelector('.uploadremove')?.addEventListener('click', function() {
        previewImg.src = '/static/assets/images/default.png';
        fileInput.value = '';
        document.getElementById('delete-photo').value = 'true';
    });

    // ===================== Choices.js Initialization =====================
    const choiceSelects = document.querySelectorAll('.js-choice');
    choiceSelects.forEach(function(select) {
        const choices = new Choices(select, {
            removeItemButton: true,
            searchEnabled: true,
            placeholderValue: 'Select an option',
            shouldSort: false,
            allowHTML: true,
        });

        select.addEventListener('change', function() {
            validateField(select);
        });
    });
});