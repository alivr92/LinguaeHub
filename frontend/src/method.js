// Function to fetch current pricing from server
async function fetchCurrentPricing() {
    try {
        const response = await fetch('/tutor/get-pricing/', {
            method: 'GET',
            headers: {
                'X-Requested-With': 'XMLHttpRequest',
            },
        });

        if (!response.ok) {
            throw new Error('Failed to fetch pricing data');
        }

        const data = await response.json();

        if (data.status === 'success') {
            // Update the input field with current pricing
            document.getElementById('lessonPrice').value = data.cost_hourly;
            // Also update any other calculations that depend on the price
            updatePriceDisplay();
            return data.cost_hourly;
        } else {
            console.error('Error fetching pricing:', data.message);
            return null;
        }
    } catch (error) {
        console.error('Error in fetchCurrentPricing:', error);
        return null;
    }
}

// Function to update pricing via AJAX
export async function updatePricing() {

    try {
        const response = await fetch('/tutor/update-pricing/', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-Requested-With': 'XMLHttpRequest',
                'X-CSRFToken': getCookie('csrftoken'),
            },
            body: JSON.stringify({cost_hourly: newPrice}),
        });

        const data = await response.json();

        if (data.status === 'success') {
            // Show success message
            showAlert('Your Hourly Price saved successfully!', 'success');
            return true;
        } else {
            // Show error message
            showAlert('Error updating price: ' + data.message, 'error');
            return false;
        }
    } catch (error) {
        console.error('Error in updatePricing:', error);
        showAlert('Network error while updating price', 'error');
        return false;
    }
}

export function saveMethod(){

}
document.addEventListener('DOMContentLoaded', function() {
    // Method selection with dynamic guidance
    const methodCards = document.querySelectorAll('.method-card');
    const methodHint = document.getElementById('methodHint');

    methodCards.forEach(card => {
        card.addEventListener('click', function() {
            const method = this.getAttribute('data-method');

            // Update active state
            methodCards.forEach(c => c.classList.remove('active'));
            this.classList.add('active');

            // Check the radio button
            document.getElementById(`method_${method}`).checked = true;

            // Toggle in-person section
            if (method === 'online') {
                document.getElementById('inPersonLocationSection').style.display = 'none';
            } else {
                document.getElementById('inPersonLocationSection').style.display = 'block';
            }

            // Update method hint based on selection
            if (method === 'hybrid') {
                methodHint.innerHTML = `
                    <i class="bi bi-lightbulb-fill me-2 fs-5 text-warning"></i>
                    <div>
                        <strong>Hybrid Teaching - Maximize Your Opportunities</strong>
                        <ul class="benefit-list mt-2 mb-0">
                            <li><span class="highlight">Appear in both online and local searches</span> - double your visibility to potential students</li>
                            <li><span class="highlight">Flexibility to accept both remote and local students</span> based on your schedule and preferences</li>
                            <li><span class="highlight">Automatic fallback option</span> - if local students aren't available, you'll still get online opportunities</li>
                            <li><span class="highlight">Higher acceptance rate</span> - students prefer tutors with multiple options</li>
                        </ul>
                        <p class="mt-2 mb-0">
                            <small>Tutors who choose hybrid typically get their first student <span class="highlight">2x faster</span> and maintain <span class="highlight">40% more consistent bookings</span>.</small>
                        </p>
                    </div>
                `;
            } else if (method === 'online') {
                methodHint.innerHTML = `
                    <i class="bi bi-lightbulb-fill me-2 fs-5 text-warning"></i>
                    <div>
                        <strong>Online Teaching - Global Reach</strong>
                        <ul class="benefit-list mt-2 mb-0">
                            <li><span class="highlight">Teach students from anywhere in the world</span> - no geographical limitations</li>
                            <li><span class="highlight">Higher student volume</span> - access to a much larger pool of potential students</li>
                            <li><span class="highlight">No travel time or expenses</span> - teach from the comfort of your home</li>
                            <li><span class="highlight">Flexible scheduling</span> - easier to accommodate different time zones</li>
                        </ul>
                        <p class="mt-2 mb-0">
                            <small>Online tutors typically build their student base <span class="highlight">30% faster</span> but may face more competition on pricing.</small>
                        </p>
                    </div>
                `;
            } else if (method === 'in_person') {
                methodHint.innerHTML = `
                    <i class="bi bi-lightbulb-fill me-2 fs-5 text-warning"></i>
                    <div>
                        <strong>In-Person Teaching - Local Expertise</strong>
                        <ul class="benefit-list mt-2 mb-0">
                            <li><span class="highlight">Premium pricing potential</span> - in-person sessions typically command higher rates</li>
                            <li><span class="highlight">Stronger student relationships</span> - face-to-face interaction builds better connections</li>
                            <li><span class="highlight">Less competition</span> - you'll only compete with tutors in your local area</li>
                            <li><span class="highlight">Specialized local knowledge</span> - understand local curriculum and requirements</li>
                        </ul>
                        <p class="mt-2 mb-0">
                            <small>In-person tutors often achieve <span class="highlight">higher student retention rates</span> but may take longer to build their initial client base.</small>
                        </p>
                    </div>
                `;
            }
        });
    });

    // Initialize with current method
    const currentMethod = document.querySelector('input[name="meeting_method"]:checked');
    if (currentMethod) {
        const currentCard = document.querySelector(`.method-card[data-method="${currentMethod.value}"]`);
        if (currentCard) {
            currentCard.click();
        }
    } else {
        // Default to hybrid
        document.querySelector('.method-card[data-method="hybrid"]').click();
    }
});