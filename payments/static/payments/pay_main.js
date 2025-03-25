// Get Stripe publishable key
fetch("/payments/config/")
    .then((result) => result.json())
    .then((data) => {
        // Initialize Stripe.js
        const stripe = Stripe(data.publicKey);

        // Event handler for the payment button
        document.querySelector("#submitBtn").addEventListener("click", () => {
            // Get Checkout Session ID
            fetch("/payments/create-checkout-session/", {
                method: "POST",
                headers: {
                    'Content-Type': 'application/json',
                    'X-CSRFToken': getCookie('csrftoken'),  // Ensure CSRF token is included
                },
            })
                .then((result) => {
                    if (!result.ok) {
                        throw new Error('Network response was not ok');
                    }
                    return result.json();
                })
                .then((data) => {
                    console.log('Response data:', data);  // Debugging line

                    if (data.error) {
                        throw new Error(data.error);
                    }
                    if (!data.sessionId) {
                        throw new Error('No sessionId received from the server');
                    }
                    // Redirect to Stripe Checkout
                    return stripe.redirectToCheckout({sessionId: data.sessionId});
                })
                .then((result) => {
                    if (result.error) {
                        alert(result.error.message);
                    }
                })
                .catch((error) => {
                    console.error("Error:", error);
                    alert("An error occurred: " + error.message);
                });
        });
    });

function getCookie(name) {
    let cookieValue = null;
    if (document.cookie && document.cookie !== '') {
        const cookies = document.cookie.split(';');
        for (let i = 0; i < cookies.length; i++) {
            const cookie = cookies[i].trim();
            if (cookie.substring(0, name.length + 1) === (name + '=')) {
                cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
                break;
            }
        }
    }
    return cookieValue;
}