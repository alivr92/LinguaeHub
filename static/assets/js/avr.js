/**
 * LinguaeHub- LMS, Tutor and Course Hub
 *
 * @author Lucas Vpr (https://www.LinguaeHub.com/)
 * @version 1.0.0
 **/


/* ===================
Table Of Content
======================
01 MESSAGE FADER
02
====================== */
window.showBootstrapAlert = showBootstrapAlert;

$(document).ready(function () {
    setTimeout(function () {
        const message = document.querySelector('#message');
        if (message) {
            message.style.transition = 'opacity 1s';
            message.style.opacity = '0';

            // Wait for the fade-out to complete before removing the element
            setTimeout(function () {
                message.remove();
            }, 1000); // This should match the transition duration
        }
    }, 5000);
});


function showBootstrapAlert(message, type = 'info', timeOut, btnCross = true) {
    const alertContainer = document.getElementById('alert-container');

    // Check if an exact same alert already exists
    const existingAlert = [...alertContainer.children].find(alert =>
        alert.classList.contains(`alert-${type}`) &&
        alert.textContent.includes(message)
    );

    // If the exact alert already exists, do nothing
    if (existingAlert) {
        return;
    }


    // Create the alert div
    const alertDiv = document.createElement('div');
    alertDiv.classList.add('alert', `alert-${type}`, 'alert-dismissible', 'fade', 'show');
    alertDiv.setAttribute('role', 'alert');

    // Add the message
    // Add the cross button
    if (btnCross) {
        alertDiv.innerHTML = `${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>`;
    } else {
        alertDiv.innerHTML = `${message}`;
    }


    // Append the alert to the container
    alertContainer.appendChild(alertDiv);

    // Apply timeout only if it is defined
    if (typeof timeOut !== 'undefined' && timeOut !== null) {
        // Automatically remove the alert after 5 seconds (optional)
        setTimeout(() => {
            alertDiv.classList.remove('show');
            alertDiv.classList.add('fade');
            setTimeout(() => alertDiv.remove(), 150); // Wait for fade-out animation
        }, timeOut);
    }


    // Scroll to the alert message
    if (alertContainer) {
        alertContainer.scrollIntoView({
            behavior: 'smooth',
            block: 'center'
        });
    }

}