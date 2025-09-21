//------------------------ Showing/Hiding location section ------------------------
//--------------------------------- BEST ------------------------------------------------
document.addEventListener('DOMContentLoaded', function () {
    const methodRadios = document.querySelectorAll('input[name="meeting_method"]');
    const methodCards = document.querySelectorAll('.method-card');
    const meeting_method = document.getElementById('meeting_method');
    const locationSection = document.getElementById('inPersonLocationSection');
    const privacyHint = document.getElementById('privacyHint');
    const methodHint = document.getElementById('methodHint');

    // Method hints content
    const methodHints = {
        online: `
                    <i class="bi bi-info-circle-fill me-2 fs-5 info-icon"></i>
                    <strong>Online Only Sessions</strong>
                    <ul class="benefit-list mt-2 mb-0">
                        <li>Access to all available online tutors</li>
                        <li>Maximum flexibility with scheduling</li>
                        <li>No geographical limitations</li>
                        <li>Save time on commuting</li>
                    </ul>
                `,
        hybrid: `
                    <i class="bi bi-info-circle-fill me-2 fs-5 info-icon"></i>
                    <strong>Hybrid Approach - Recommended</strong>
                    <ul class="benefit-list mt-2 mb-0">
                        <li><span class="highlight">Best matching opportunity</span> - we'll show you online options if in-person isn't available</li>
                        <li>Flexibility to choose between online and in-person sessions</li>
                        <li>Wider selection of tutors/students</li>
                        <li>Fallback to online when in-person isn't convenient</li>
                    </ul>
                    <p class="mt-2 mb-0"><small>Choosing hybrid increases your chances of finding the right match by <span class="highlight">65%</span> compared to in-person only.</small></p>
                `,
        in_person: `
                    <i class="bi bi-info-circle-fill me-2 fs-5 info-icon"></i>
                    <strong>In-Person Only Sessions</strong>
                    <ul class="benefit-list mt-2 mb-0">
                        <li>Face-to-face interaction only</li>
                        <li>Limited to tutors/students in your area</li>
                        <li><span class="highlight">Note:</span> You'll only see in-person options, which may limit available matches</li>
                    </ul>
                    <p class="mt-2 mb-0"><small>For broader options, consider the <span class="highlight">Hybrid</span> approach which includes both in-person and online possibilities.</small></p>
                `
    };

    function toggleLocationSection() {
        const selectedMethod = document.querySelector('input[name="meeting_method"]:checked').value;
        // locationSection.classList.toggle('d-none', !['hybrid', 'in_person'].includes(selectedMethod));
        locationSection.classList.toggle('d-none', ['online'].includes(selectedMethod));
        privacyHint.classList.toggle('d-none', ['online'].includes(selectedMethod));
    }

    function updateMethodHint(method) {
        methodHint.innerHTML = `
                    <div>${methodHints[method]}</div>
                `;
    }

    function updateMethodSelection() {
        const selectedMethod = document.querySelector('input[name="meeting_method"]:checked').value;

        // Update card styles
        methodCards.forEach(card => {
            if (card.dataset.method === selectedMethod) {
                card.classList.add('selected');
            } else {
                card.classList.remove('selected');
            }
        });

        // Update hint and section visibility
        updateMethodHint(selectedMethod);
        toggleLocationSection();
    }

    // Add event listeners to method cards
    methodCards.forEach(card => {
        card.addEventListener('click', function () {
            const method = this.dataset.method;
            document.querySelector(`#method_${method}`).checked = true;
            updateMethodSelection();
        });
    });

    // Add event listeners to radio buttons
    methodRadios.forEach(radio => {
        radio.addEventListener('change', updateMethodSelection);
    });

    // Initialize on page load
    // const initialMethod = document.querySelector('input[name="meeting_method"]:checked').value;
    // updateMethodHint(initialMethod);
    updateMethodSelection();
    // toggleLocationSection();

    // Initialize tooltips
    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });
});
//---------------------------------------------------------------------------------
// document.addEventListener('DOMContentLoaded', function() {
//     const methodRadios = document.querySelectorAll('input[name="meeting_method"]');
//     const locationSection = document.getElementById('inPersonLocationSection');
//     const methodHint = document.getElementById('methodHint');
//
//     function toggleLocationSection() {
//         const selectedMethod = document.querySelector('input[name="meeting_method"]:checked').value;
//         // Show location section only for hybrid and in_person options
//         locationSection.classList.toggle('d-none', !['hybrid', 'in_person'].includes(selectedMethod));
//         // locationSection.classList.toggle('d-none', !['hybrid'].includes(selectedMethod));
//         methodHint.classList.toggle('d-none', ['in_person'].includes(selectedMethod));
//
//         // Note: We're not changing any explanation text when switching to in-person-only
//     }
//
//     methodRadios.forEach(radio => {
//         radio.addEventListener('change', toggleLocationSection);
//     });
//
//     // Initialize on page load
//     toggleLocationSection();
//
//     // Additional map initialization code would go here
// });
//---------------------------------------------------------------------------------

// document.addEventListener('DOMContentLoaded', function() {
//     const inPersonToggle = document.getElementById('inPersonToggle');
//     const locationSection = document.getElementById('inPersonLocationSection');
//
//     if (inPersonToggle && locationSection) {
//         // Initial state
//         toggleLocationFields();
//
//         // Change handler
//         inPersonToggle.addEventListener('change', toggleLocationFields);
//
//         function toggleLocationFields() {
//             if (inPersonToggle.checked) {
//                 locationSection.classList.remove('d-none');
//                 // Make fields required when visible
//                 locationSection.querySelectorAll('input, select').forEach(field => {
//                     field.required = true;
//                 });
//             } else {
//                 locationSection.classList.add('d-none');
//                 // Remove requirement when hidden
//                 locationSection.querySelectorAll('input, select').forEach(field => {
//                     field.required = false;
//                 });
//             }
//         }
//     }
//
//     // Optional: City autocomplete
//     const cityInputs = document.querySelectorAll('[data-city-autocomplete="true"]');
//     cityInputs.forEach(input => {
//         // Initialize autocomplete here
//         // Could use Google Places, Mapbox, or a local dataset
//     });
// });

//---------------------------------------------------------------------------------

// document.addEventListener('DOMContentLoaded', function () {
//     const onlineRadio = document.getElementById('onlineOnly');
//     const hybridRadio = document.getElementById('hybridOption');
//     const inPersonSection = document.getElementById('inPersonLocationSection');
//     const offersInPersonField = document.getElementById('offersInPerson');
//
//     function toggleInPersonSection() {
//         if (hybridRadio.checked) {
//             inPersonSection.classList.remove('d-none');
//             offersInPersonField.value = 'true';
//         } else {
//             inPersonSection.classList.add('d-none');
//             offersInPersonField.value = 'false';
//         }
//     }
//
//     onlineRadio.addEventListener('change', toggleInPersonSection);
//     hybridRadio.addEventListener('change', toggleInPersonSection);
//
// });
