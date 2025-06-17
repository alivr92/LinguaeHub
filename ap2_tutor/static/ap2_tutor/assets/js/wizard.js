document.addEventListener("DOMContentLoaded", function () {
    const steps = [2, 3, 4, 5];  // Define steps you're using

    steps.forEach(step => {
        const form = document.getElementById(`form_step${step}`); // e.g., form_step2, form_step3
        const nextBtn = document.getElementById(`btnNext_step${step}`);
        const saveBtn = document.getElementById(`btnSave_step${step}`);
        const prevBtn = document.getElementById(`btnPrev_step${step}`);

        if (form && nextBtn) {
            nextBtn.addEventListener("click", () => handleSubmit(form, "next", step));
        }

        if (form && saveBtn) {
            saveBtn.addEventListener("click", () => handleSubmit(form, "save", step));
        }

        if (prevBtn) {
            prevBtn.addEventListener("click", () => window.stepper.previous());
        }
    });

    function handleSubmit(form, actionType, step) {
        const formData = new FormData(form);
        formData.set("action", actionType);
        formData.set("step", step);

        // Clear previous alerts
        form.querySelectorAll(".alert.alert-danger").forEach(el => el.remove());

        fetch(form.action, {
            method: "POST",
            headers: {
                "X-CSRFToken": form.querySelector("[name=csrfmiddlewaretoken]").value,
            },
            body: formData,
        })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    if (actionType === "next") {
                        window.stepper.next();
                    } else {
                        showAlert("Changes saved successfully.", "success");
                    }
                } else if (data.errors) {
                    for (let [field, errors] of Object.entries(data.errors)) {
                        const input = form.querySelector(`[name="${field}"]`);
                        if (input) {
                            const errorDiv = document.createElement("div");
                            errorDiv.className = "alert alert-danger alert-dismissible";
                            errorDiv.innerHTML = errors.join("<br>") +
                                '<button type="button" class="close" data-dismiss="alert">&times;</button>';
                            input.closest(".col-md-6, .col-12").appendChild(errorDiv);
                        }
                    }
                } else {
                    showAlert("Something went wrong.", "danger");
                }
            })
            .catch(error => {
                console.error("AJAX error:", error);
                showAlert("Unexpected error.", "danger");
            });
    }

    function showAlert(message, type) {
        const container = document.getElementById("alert-container");
        const alertBox = document.createElement("div");
        alertBox.className = `alert alert-${type} alert-dismissible`;
        alertBox.innerHTML = `${message}<button type="button" class="close" data-dismiss="alert">&times;</button>`;
        container.appendChild(alertBox);
    }
});
