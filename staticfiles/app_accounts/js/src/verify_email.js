import {showAlert} from '/static/assets/js/src/utils.js';

// Countdown timer for resend button
const nextResendInput = document.getElementById('next_resend');
const csrfTokenInput = document.getElementById('csrf_token');

// Check if we have a countdown value and it's a positive number
if (nextResendInput && nextResendInput.value && parseInt(nextResendInput.value) > 0) {
    let seconds = parseInt(nextResendInput.value);
    const countdownElement = document.getElementById('countdown');
    const resendButton = document.getElementById('resend-btn');

    const countdownInterval = setInterval(() => {
        seconds--;
        countdownElement.textContent = `(${seconds}s)`;

        if (seconds <= 0) {
            clearInterval(countdownInterval);
            resendButton.disabled = false;
            countdownElement.remove();
        }
    }, 1000);
}

// Handle resend button click
document.getElementById('resend-btn')?.addEventListener('click', async function () {
    const btn = this;
    const url = btn.getAttribute('data-url');

    // Check if reCAPTCHA is loaded and required
    let captchaResponse = null;
    if (typeof grecaptcha !== 'undefined' &&
        document.querySelector('.g-recaptcha')) {
        try {
            captchaResponse = grecaptcha.getResponse();
        } catch (e) {
            console.warn('reCAPTCHA error:', e);
        }
    }

    // Prepare form data
    const formData = new FormData();
    if (captchaResponse) {
        formData.append('g-recaptcha-response', captchaResponse);
    }

    btn.disabled = true;
    btn.innerHTML = '<i class="bi bi-hourglass-split me-2"></i> Sending...';
    btn.classList.add('btn-loading');

    try {
        const response = await fetch(url, {
            method: 'POST',
            headers: {
                'X-CSRFToken': csrfTokenInput.value,
            },
            body: formData
        });

        const data = await response.json();

        if (data.success) {
            document.getElementById('statusMessage').classList.remove('d-none');
            // Reset CAPTCHA if it was shown
            if (captchaResponse && typeof grecaptcha !== 'undefined') {
                grecaptcha.reset();
            }
            // Reload page to update UI (counter, etc)
            setTimeout(() => {
                window.location.reload();
            }, 1500);
        } else {
            showAlert(data.error || 'Failed to send verification email', 'error');
            btn.disabled = false;
            btn.classList.remove('btn-loading');
            btn.innerHTML = '<i class="bi bi-send-fill me-2"></i> Resend Verification Email';
        }
    } catch (error) {
        console.error('Error:', error);
        showAlert('An error occurred. Please try again.', 'error');
        btn.disabled = false;
        btn.classList.remove('btn-loading');
        btn.innerHTML = '<i class="bi bi-send-fill me-2"></i> Resend Verification Email';
    }
});

// Fallback in case reCAPTCHA loads after our script
function onRecaptchaLoad() {
    // console.log('reCAPTCHA loaded');
}

window.onRecaptchaLoad = onRecaptchaLoad;