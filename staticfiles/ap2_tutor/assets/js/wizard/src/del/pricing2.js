        document.addEventListener('DOMContentLoaded', function () {
            const lessonPriceInput = document.getElementById('lessonPrice');
            const followRecommendation = document.getElementById('followRecommendation');
            const yourEarnings = document.getElementById('yourEarnings');
            const platformFee = document.getElementById('platformFee');
            const commissionRate = document.getElementById('commissionRate');
            const progressText = document.getElementById('progressText');

            // Monthly earnings projection elements
            const lessonsPerWeekSlider = document.getElementById('lessonsPerWeek');
            const lessonsValue = document.getElementById('lessonsValue');
            const monthlyEarnings = document.getElementById('monthlyEarnings');
            const weeklyEarnings = document.getElementById('weeklyEarnings');
            const quarterlyEarnings = document.getElementById('quarterlyEarnings');
            const yearlyEarnings = document.getElementById('yearlyEarnings');
            const sliderTooltip = document.getElementById('sliderTooltip');
            const sliderContainer = document.getElementById('sliderContainer');
            const sliderValueDisplay = document.getElementById('sliderValueDisplay');
            const sliderMonthly = document.getElementById('sliderMonthly');

            // UPDATED: More competitive commission tiers
            const commissionTiers = [
                {hours: 0, rate: 0.30},    // 30% for beginners
                {hours: 20, rate: 0.25},   // 25% after 20 hours
                {hours: 50, rate: 0.22},   // 22% after 50 hours
                {hours: 100, rate: 0.19},  // 19% after 100 hours
                {hours: 200, rate: 0.15}   // 15% after 200 hours (top tier)
            ];

            // For demonstration, we'll use the starting rate (30%)
            let currentCommissionRate = commissionTiers[0].rate;
            let currentTierIndex = 0;
            let completedHours = 0; // For demonstration, start with 0 hours

            // Update price display with calculations
            function updatePriceDisplay() {
                const price = parseFloat(lessonPriceInput.value) || 24;
                const commissionAmount = price * currentCommissionRate;
                const earnings = price - commissionAmount;

                commissionRate.textContent = `${Math.round(currentCommissionRate * 100)}%`;
                yourEarnings.textContent = `$${earnings.toFixed(2)}`;
                platformFee.textContent = `$${commissionAmount.toFixed(2)}`;

                // Update progress bar
                const progressBar = document.querySelector('.progress-bar');
                let progressPercentage = 0;

                if (currentTierIndex < commissionTiers.length - 1) {
                    const nextTierHours = commissionTiers[currentTierIndex + 1].hours;
                    progressPercentage = Math.min(100, (completedHours / nextTierHours) * 100);
                    progressText.textContent = `${completedHours}/${nextTierHours} hours`;
                } else {
                    progressPercentage = 100;
                    progressText.textContent = "Maximum tier reached!";
                }

                progressBar.style.width = `${progressPercentage}%`;
                progressBar.setAttribute('aria-valuenow', progressPercentage);

                // Also update the commission table with new calculations
                updateCommissionTable(price);
                updateMonthlyEarnings();
            }

            // NEW: Update commission table with dynamic calculations
            function updateCommissionTable(price) {
                const rows = document.querySelectorAll('#commissionTable tbody tr');

                commissionTiers.forEach((tier, index) => {
                    if (rows[index]) {
                        const commissionAmount = price * tier.rate;
                        const earnings = price - commissionAmount;

                        // Update earnings column
                        const earningsCell = rows[index].cells[2];
                        if (earningsCell) {
                            earningsCell.textContent = `$${earnings.toFixed(2)} per lesson`;
                        }

                        // Highlight current tier
                        if (tier.rate === currentCommissionRate) {
                            rows[index].classList.add('table-primary');
                        } else {
                            rows[index].classList.remove('table-primary');
                        }
                    }
                });
            }

            function updateMonthlyEarnings() {
                const price = parseFloat(lessonPriceInput.value) || 24;
                const lessons = parseInt(lessonsPerWeekSlider.value);
                const weeklyEarningsValue = (price * (1 - currentCommissionRate)) * lessons;
                const monthly = weeklyEarningsValue * 4.33; // Average weeks in month
                const quarterly = monthly * 3; // can be consider as season
                const yearly = monthly * 12;

                lessonsValue.textContent = `${lessons} lesson${lessons !== 1 ? 's' : ''}`;
                monthlyEarnings.textContent = `$${Math.round(monthly)}`;
                weeklyEarnings.textContent = `$${weeklyEarningsValue.toFixed(2)}`;
                quarterlyEarnings.textContent = `$${Math.round(quarterly)}`;
                yearlyEarnings.textContent = `$${Math.round(yearly)}`;
                sliderMonthly.textContent = `$${Math.round(monthly)}`;

                // Update slider tooltip position and value
                const percent = ((lessons - 1) / 19) * 100;
                sliderTooltip.textContent = `${lessons} lessons`;
                sliderTooltip.style.left = `${percent}%`;

                // Add animation to monthly earnings card
                monthlyEarnings.parentElement.parentElement.classList.add('pulse-animation');
                setTimeout(() => {
                    monthlyEarnings.parentElement.parentElement.classList.remove('pulse-animation');
                }, 1000);

                // Add animation to slider value display
                sliderValueDisplay.classList.add('slider-animation');
                setTimeout(() => {
                    sliderValueDisplay.classList.remove('slider-animation');
                }, 500);
            }

            // Enhanced slider interactions
            lessonsPerWeekSlider.addEventListener('input', function () {
                lessonsValue.textContent = `${this.value} lesson${this.value !== '1' ? 's' : ''}`;
                updateMonthlyEarnings();
            });

            lessonsPerWeekSlider.addEventListener('mousedown', function() {
                sliderContainer.classList.add('slider-active');
            });

            lessonsPerWeekSlider.addEventListener('mouseup', function() {
                setTimeout(() => {
                    sliderContainer.classList.remove('slider-active');
                }, 1500);
            });

            lessonsPerWeekSlider.addEventListener('touchstart', function() {
                sliderContainer.classList.add('slider-active');
            });

            lessonsPerWeekSlider.addEventListener('touchend', function() {
                setTimeout(() => {
                    sliderContainer.classList.remove('slider-active');
                }, 1500);
            });

            // Follow recommendation handler
            followRecommendation.addEventListener('change', function () {
                if (this.checked) {
                    lessonPriceInput.value = 24;
                    updatePriceDisplay();

                    // Add highlight animation to price input
                    lessonPriceInput.classList.add('highlight-change');
                    setTimeout(() => {
                        lessonPriceInput.classList.remove('highlight-change');
                    }, 1000);
                }
            });

            // Price input handler
            lessonPriceInput.addEventListener('input', updatePriceDisplay);

            // Validate price range
            lessonPriceInput.addEventListener('change', function () {
                let price = parseFloat(this.value);

                if (isNaN(price) || price < 10) {
                    this.value = 10;
                } else if (price > 100) {
                    this.value = 100;
                }

                // Uncheck recommendation if user changes price
                if (price !== 24) {
                    followRecommendation.checked = false;
                }

                updatePriceDisplay();

                // Add highlight animation
                this.classList.add('highlight-change');
                setTimeout(() => {
                    this.classList.remove('highlight-change');
                }, 1000);
            });

            // For demonstration: Simulate completing hours to show tier progression
            document.addEventListener('keydown', function(e) {
                if (e.key === 'ArrowUp') {
                    completedHours += 5;
                    updateTier();
                    updatePriceDisplay();
                } else if (e.key === 'ArrowDown' && completedHours > 0) {
                    completedHours -= 5;
                    updateTier();
                    updatePriceDisplay();
                }
            });

            function updateTier() {
                // Find the appropriate tier based on completed hours
                for (let i = commissionTiers.length - 1; i >= 0; i--) {
                    if (completedHours >= commissionTiers[i].hours) {
                        currentCommissionRate = commissionTiers[i].rate;
                        currentTierIndex = i;
                        break;
                    }
                }
            }

            // Initialize price display
            updatePriceDisplay();
            updateMonthlyEarnings();
        });