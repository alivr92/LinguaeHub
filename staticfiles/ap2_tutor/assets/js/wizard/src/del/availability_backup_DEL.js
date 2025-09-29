import {utcTimeToLocalTime, localTimeToUtcTime} from '/static/assets/js/src/timeUtils.js';
import {showAlert} from './utils.js';

// Constants and variables
const accordionContainer = document.getElementById('AccordionWeekDays');
const daysOfWeek = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
const daysOfWeek_abbr = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
const btnFreeWeek = document.getElementById('freeWeek');
const btnSubmitTimes = document.getElementById('btnSave_availability');
const providerUId = document.getElementById('providerUId').value;
const timezoneSelect = document.getElementById('timezone-select');
const previousTimeSlots = {};

let userTimezone;
let allTimeSlots = [];
let newTimeSlots = [];
let newTimeSlotCounter = 0; // Global counter for unique IDs
let existedTimeSlots = [];
let waitToDeleteTimeSlots = [];
let sessionLength = 2; // set a default sessionLength (1=30 min,  2=60 min, 3=90 min , 4=120 min, 6=180 min)
let class_type;


// Setup event listeners
function setupEventListeners() {
    // Timezone change listener
    timezoneSelect.addEventListener('change', function () {
        userTimezone = this.value;
        showAlert(`Timezone updated to: ${userTimezone}`, 'info');

        // Refresh availability display with new timezone
        removeAllTimeSlots();
        // showAvailableTimeSlots();
    });


}


// Validate availability settings
export function validateAvailability() {
    if (!userTimezone) {
        showAlert('Please select your timezone first.', 'error');
        timezoneSelect.focus();
        return false;
    }

    // Check if at least one time slot is set
    const hasTimeSlots = newTimeSlots.length > 0 || existedTimeSlots.length > 0;
    if (!hasTimeSlots) {
        showAlert('Please set your availability for at least one day.', 'warning');
        return false;
    }

    return true;
}

function setupAccordionInteractions() {
    // Add smooth scrolling to accordion items
    const accordionButtons = document.querySelectorAll('.accordion-button');
    accordionButtons.forEach(button => {
        button.addEventListener('click', function () {
            const target = this.getAttribute('data-bs-target');
            const collapseElement = document.querySelector(target);

            // Smooth scroll into view
            setTimeout(() => {
                collapseElement.scrollIntoView({
                    behavior: 'smooth',
                    block: 'nearest'
                });
            }, 300);
        });
    });

    // Add keyboard navigation
    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape') {
            // Collapse all accordions when Escape is pressed
            const openAccordions = document.querySelectorAll('.accordion-collapse.show');
            openAccordions.forEach(accordion => {
                bootstrap.Collapse.getInstance(accordion).hide();
            });
        }
    });
}

function generateAccordionItems() {
    accordionContainer.innerHTML = '';

    for (let i = 0; i < 7; i++) {
        const dayIndex = i;
        const fullDayName = daysOfWeek[dayIndex];
        const abbrDay = daysOfWeek_abbr[dayIndex];

        const columnWrapper = document.createElement('div');
        columnWrapper.className = 'col-12 col-sm-6 col-md-6 col-lg-6';

        const accordionItem = document.createElement('div');
        accordionItem.className = `accordion-item border-0 mb-3`;
        accordionItem.innerHTML = `
            <h6 class="accordion-header" id="heading_${abbrDay}">
                <button class="accordion-button collapsed rounded-3 bg-light" type="button" data-bs-toggle="collapse"
                        data-bs-target="#collapse_${abbrDay}" aria-expanded="false" aria-controls="collapse_${abbrDay}">
                    <i class="bi bi-calendar-check me-2 text-primary"></i>
                    <span class="fw-semibold">${fullDayName}</span>
                </button>
            </h6>
            <div id="collapse_${abbrDay}" class="accordion-collapse collapse" aria-labelledby="heading_${abbrDay}"
                 data-bs-parent="#AccordionWeekDays">
                <div class="accordion-body pt-3">
                    <div id="timeSlots_${abbrDay}" class="time-slots-container mb-3"></div>
                    
                    <div class="card bg-light border-0">
                        <div class="card-body p-3">
                            <div class="row gx-2 align-items-center flex-nowrap">
    <!-- Time Input Section -->
                    <div class="bg-light rounded p-3">
                        <!-- Time Inputs Row -->
                        <div class="row g-2 align-items-center mb-2">
                            <div class="col-12">
                                <div class="d-flex align-items-center gap-2">
                                    <input type="time" class="form-control form-control-sm flex-grow-1" 
                                           id="startTime_${abbrDay}" placeholder="Start">
                                    <span class="text-muted fw-bold">-</span>
                                    <input type="time" class="form-control form-control-sm flex-grow-1" 
                                           id="endTime_${abbrDay}" placeholder="End">
                                </div>
                            </div>
                        </div>
                        
                        <!-- Buttons Row -->
                        <div class="row g-2 align-items-center">
                            <div class="col-8">
                                <div class="d-flex gap-2">
                                    <button class="btn btn-sm btn-primary flex-fill" id="addTime_${abbrDay}">
                                        <i class="bi bi-plus-circle me-1"></i>Add
                                    </button>
                                    <button class="btn btn-sm btn-outline-danger flex-fill" id="clear_${abbrDay}">
                                        <i class="bi bi-eraser"></i> Clear
                                    </button>
                                </div>
                            </div>
                            <div class="col-4">
                                <div class="form-check form-switch mb-0">
                                    <input class="form-check-input" type="checkbox" id="freeDay_${abbrDay}">
                                    <label class="form-check-label small text-muted" for="freeDay_${abbrDay}">
                                        All day
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>
</div>

                            
                        </div>
                    </div>
                </div>
            </div>
        `;
        columnWrapper.appendChild(accordionItem);
        accordionContainer.appendChild(columnWrapper);
    }
}

// Function to submit time slots via AJAX
export async function submitTimes() {
    // Always include timezone even if no new time slots
    const requestData = {
        timezone: userTimezone,
        available_sessions: newTimeSlots,
        DeletableTimeSlots: waitToDeleteTimeSlots
    };

    // console.log('Submitting data:', requestData);

    const url = `/schedule/save-available-rule-times/`;
    fetch(url, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'X-CSRFToken': getCookie('csrftoken'),
        },
        body: JSON.stringify(requestData),
    })
        .then(response => {
            if (!response.ok) {
                return response.json().then(err => {
                    throw err;
                });
            }
            return response.json();
        })
        .then(data => {
            // console.log(data);
            // Handle success
            if (data.status === 'success') {
                // Reset counters and arrays after successful save
                newTimeSlots = [];
                waitToDeleteTimeSlots = [];
                newTimeSlotCounter = 0;
            } else {
                showAlert(data.message, 'error');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            showAlert('Error saving availability. Please try again.', 'error');
        });
}

// Helper function to get CSRF token
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

function validateTimeRange(startTime, endTime) {
    // Check if minutes are 00 or 30
    const isValidMinutes = (time) => {
        const minutes = time.split(':')[1];
        return minutes === '00' || minutes === '30';
    };

    if (!isValidMinutes(startTime) || !isValidMinutes(endTime)) {
        showAlert('Please enter times with minutes rounded to 00 or 30 (e.g., 10:00, 10:30).', 'error');
        return false;
    }

    // Special case: 24:00 is 00:00 (next day)
    if (endTime === '00:00') {
        return true;
    }

    // Check if endTime is after startTime
    if (startTime >= endTime) {
        showAlert('End time must be after start time.', 'error');
        return false;
    }

    return true;
}

// Function to display available time slots in the accordion
async function showAvailableTimeSlots() {
    const url = `/schedule/get-available-rules/?providerUId=${providerUId}&timezone=${encodeURIComponent(userTimezone)}`;
    try {
        const response = await fetch(url);
        if (!response.ok) throw new Error('Failed to fetch availability data');
        const data = await response.json();

        // Highlight available cells and add them to the accordion
        data.availability.forEach(availability => {
            const availId = availability.availId;
            const startTimeUTC = availability.start_time_utc;
            const endTimeUTC = availability.end_time_utc;

            // Convert UTC times to the provider's time zone
            // const startTime = convertUTCClockToLocal(startTimeUTC, userTimezone);
            // const endTime = convertUTCClockToLocal(endTimeUTC, userTimezone);

            const startTime = utcTimeToLocalTime(startTimeUTC, userTimezone);
            const endTime = utcTimeToLocalTime(endTimeUTC, userTimezone);
            // Extract time in the desired format (using local time zone)
            // const startTimeFormatted = formatLocalTime(startTime); // HH:MM
            // const endTimeFormatted = formatLocalTime(endTime); // HH:MM

            // Get day of week from availability data (assuming it's stored)
            // const day = availability.day_of_week || daysOfWeek_abbr[startTime.getDay()];
            const day = daysOfWeek_abbr[availability.weekday];
            if (day) {
                // addAvailableTimeSlot(availId, day, startTimeFormatted, endTimeFormatted);
                addAvailableTimeSlot(availId, day, startTime, endTime);
            }

            const availTimeSlot = {
                tsId: availId,
                day: day,
                start: startTime,
                end: endTime,
            };
            existedTimeSlots.push(availTimeSlot);
        });

        // console.log('existedTimeSlots: ', existedTimeSlots);
    } catch (error) {
        console.error('Error fetching availability:', error);
    }
}


function isOverlapping(day, newStart, newEnd) {
    const timeSlotsContainer = document.getElementById(`timeSlots_${day}`);
    const timeSlots = Array.from(timeSlotsContainer.children);
    // console.log('timeSlots length: ', timeSlots.length);

    for (const slot of timeSlots) {
        const timeRange = slot.querySelector('span:nth-child(3)')?.textContent.trim();
        if (timeRange) {
            let [startTime, endTime] = timeRange.split(' - ');
            /* Note: If endTime has parenthesis means that it is in the next day and the length is more than 5 (e.g.  2025-02-25 TUE 03:30 - 03:30 (2025-02-26))
            While the normal endTime must be 5 (e.g.  2025-02-25 TUE 05:30 - 07:00) (HH:MM has 5 chars)
            */
            if (endTime.length > 5) {
                endTime = '24:00';
            }
            // console.log('[startTime, endTime]: ', [startTime, endTime]);

            if (
                (newStart >= startTime && newStart < endTime) ||
                (newEnd > startTime && newEnd <= endTime) ||
                (newStart <= startTime && newEnd >= endTime)
            ) {
                return true; // Overlapping found
            }
        } else {
            // console.log('timeRange is undefined!');
        }
    }

    return false; // No overlapping
}

// Function to add a NEW time slot
function addNewTimeSlot(day) {
    const startTime = document.getElementById(`startTime_${day}`).value;
    const endTime = document.getElementById(`endTime_${day}`).value;
    if (!startTime || !endTime) {
        showAlert('Please fill in both start and end times.', 'error');
        return;
    }
    if (!validateTimeRange(startTime, endTime)) {
        return;
    }
    if (isOverlapping(day, startTime, endTime)) {
        showAlert(`This time slot overlaps with an existing one. Please choose a different time in ${daysOfWeek[daysOfWeek_abbr.indexOf(day)]}.`, 'error');
        return;
    }

    // Generate a unique ID for the new time slot
    const tsId = `newTS_${newTimeSlotCounter++}`;

    // Create a new time slot
    const newTimeSlot = document.createElement('div');
    newTimeSlot.innerHTML = `
      <div class="d-flex justify-content-between align-items-center mb-2">
        <div class="position-relative time-slots">
          <span  class="btn btn-primary btn-round btn-sm mb-0 stretched-link position-static"><i class="fas fa-calendar-check"></i></span>
          <span class="ms-2 mb-0 h6 fw-light">${day}</span>
          <span class="ms-2 mb-0 h6 fw-light">${startTime} - ${endTime}</span>
          <input type="hidden" value="${tsId}"> <!-- Add a hidden input to store the ID -->
        </div>
        <div>
          <button class="btn btn-sm btn-danger-soft btn-round mb-0" onclick="deleteTimeSlot(this)"><i class="fas fa-fw fa-times"></i></button>
        </div>
      </div>
    `;

    // Append the new time slot to the accordion area
    const timeSlotsContainer = document.getElementById(`timeSlots_${day}`);
    timeSlotsContainer.appendChild(newTimeSlot);

    // Add the slot to newTimeSlots array
    const timeSlot = {
        tsId: tsId,
        providerUId: providerUId, // Tutor ID -> Provider User ID
        timezone: userTimezone, // User's timezone
        day: day, // this use just for remove slots
        startTime: startTime,
        endTime: endTime,
    };

    newTimeSlots.push(timeSlot);
    // console.log('newTimeSlots', newTimeSlots);

    // Clear the input fields
    document.getElementById(`startTime_${day}`).value = '';
    document.getElementById(`endTime_${day}`).value = '';
}


// checkbox to indicate a special day of week is free or not!
function freeDay(day, isProgrammatic = false) {
    const freeDay = document.getElementById(`freeDay_${day}`);
    const timeSlotsContainer = document.getElementById(`timeSlots_${day}`);

    // Debugging: Ensure elements exist
    if (!freeDay || !timeSlotsContainer) {
        console.error(`Checkbox or time slots container for ${day} not found!`);
        return;
    }

    // Debugging: Log checkbox state
    // console.log(`Checkbox state for ${day}:`, freeDay.checked);

    // If the function is called programmatically (e.g., from btnFreeWeek), check the checkbox
    if (isProgrammatic) {
        freeDay.checked = true;
    }

    if (freeDay.checked) {
        // Store the current time slots before clearing them
        previousTimeSlots[day] = timeSlotsContainer.innerHTML;
        // console.log(`Stored time slots for ${day}:`, previousTimeSlots[day]); // Debugging line

        // Clear all existing time slots
        removeTimeSlots(day);
        timeSlotsContainer.innerHTML = '';

        // Add a special time slot for the entire day
        const newTimeSlot = document.createElement('div');
        newTimeSlot.innerHTML = `
          <div class="d-flex justify-content-between align-items-center mb-2">
              <div class="position-relative time-slots">
                  <span class="btn btn-primary btn-round btn-sm mb-0 stretched-link position-static"><i class="fas fa-calendar-check"></i></span>
                  <span class="ms-2 mb-0 h6 fw-light">${day}</span>
                  <span class="ms-2 mb-0 h6 fw-light">00:00 - 24:00</span>
              </div>
          </div>
      `;
        timeSlotsContainer.appendChild(newTimeSlot);

        // Add the slot to newTimeSlots array
        const timeSlot = {
            tsId: 'newTS_Full', // Unique ID for the full-day slot
            providerUId: providerUId, // Tutor ID
            timezone: userTimezone, // User's timezone
            day: day, // Day of the week
            startTime: '00:00',
            endTime: '24:00',
        };
        newTimeSlots.push(timeSlot);
        // console.log('newTimeSlots', newTimeSlots);

        // Disable the "Add Time" button and inputs
        document.getElementById(`addTime_${day}`).disabled = true;
        document.getElementById(`clear_${day}`).disabled = true;
        document.getElementById(`startTime_${day}`).disabled = true;
        document.getElementById(`endTime_${day}`).disabled = true;
    } else {
        // Enable the "Add Time" button and inputs
        document.getElementById(`addTime_${day}`).disabled = false;
        document.getElementById(`clear_${day}`).disabled = false;
        document.getElementById(`startTime_${day}`).disabled = false;
        document.getElementById(`endTime_${day}`).disabled = false;

        // Retrieve and display the previous time slots
        if (previousTimeSlots[day]) {
            // Clear the container before appending previous time slots
            timeSlotsContainer.innerHTML = '';

            // Parse the stored HTML string into a DOM node
            const tempContainer = document.createElement('div');
            tempContainer.innerHTML = previousTimeSlots[day];

            // Append each child node to the timeSlotsContainer
            while (tempContainer.firstChild) {
                timeSlotsContainer.appendChild(tempContainer.firstChild);
            }

            // Update the newTimeSlots array
            newTimeSlots = newTimeSlots.filter(slot => slot.tsId !== 'newTS_Full' && slot.day !== day);

            // Optionally, retrieve and re-add the previous slots to newTimeSlots
            retrievePreviousSlots(day);
        } else {
            // If there are no previous time slots, clear the container
            timeSlotsContainer.innerHTML = '';
        }
    }
}

function retrievePreviousSlots(day) {
    const previousSlots = previousTimeSlots[day];
    if (!previousSlots) return;

    // Parse the stored HTML string to extract slot information
    const tempContainer = document.createElement('div');
    tempContainer.innerHTML = previousSlots;

    // Loop through the slots and add them to newTimeSlots
    tempContainer.querySelectorAll('.time-slots').forEach(slot => {
        const timeRange = slot.querySelector('span:nth-child(3)')?.textContent.trim();
        const input = slot.querySelector('input[type="hidden"]');
        if (timeRange && input) {
            const tsId = input.value; // Get the value of the hidden input
            let [startTime, endTime] = timeRange.split(' - ');

            if (tsId.startsWith('newTS_')) {
                const timeSlot = {
                    tsId: tsId, // Generate a unique ID if needed
                    providerUId: providerUId, // Tutor ID
                    timezone: userTimezone, // User's timezone
                    day: day, // Day of the week
                    startTime: startTime, // Adjust format as needed
                    endTime: endTime, // Adjust format as needed
                };
                newTimeSlots.push(timeSlot);
            } else {
                const timeSlot = {
                    tsId: parseInt(tsId), // Generate a unique ID if needed
                    day: day, // Day of the week
                    startTime: startTime, // Adjust format as needed
                    endTime: endTime, // Adjust format as needed
                };
                existedTimeSlots.push(timeSlot);
                waitToDeleteTimeSlots = waitToDeleteTimeSlots.filter(item => item !== tsId);
            }
        } else {
            console.error('ERROR, [startTime, endTime] didnt find! ');
        }
    });

    // console.log('Updated newTimeSlots:', newTimeSlots);
    // console.log('Updated existedTimeSlots:', existedTimeSlots);
    // console.log('Updated waitToDeleteTimeSlots:', waitToDeleteTimeSlots);
}

//Clear All Arrays
function clearAllArrays() {
    newTimeSlots = [];
    existedTimeSlots = [];
    waitToDeleteTimeSlots = [];
    allTimeSlots = [];
}

//Remove timeSlots of one spacial Day in HTML not in array (allTimeSlots)
function removeTimeSlots(day) {
    const timeSlotsContainer = document.getElementById(`timeSlots_${day}`);
    const timeSlots = Array.from(timeSlotsContainer.children);
    timeSlots.forEach(slot => {
        const input = slot.querySelector('input[type="hidden"]');
        if (input) {
            const tsId = input.value; // Get the value of the hidden input
            if (tsId.startsWith('newTS_')) {
                // Remove from newTimeSlots array
                newTimeSlots = newTimeSlots.filter(slot => slot.tsId !== tsId);
            } else {
                // Remove from existedTimeSlots array and add to waitToDeleteTimeSlots
                waitToDeleteTimeSlots.push(tsId); // Add to the deletion queue
                // existedTimeSlots = existedTimeSlots.filter(slot => slot.tsId != tsId);
            }
        }
    });
    existedTimeSlots = existedTimeSlots.filter(slot => slot.day !== day);
    // Clear the DOM
    timeSlotsContainer.innerHTML = ''; // Clear all child elements

    // console.log('waitToDeleteTimeSlots', waitToDeleteTimeSlots);
    // console.log('newTimeSlots', newTimeSlots);
    // console.log('RemoveALL-existedTimeSlots', existedTimeSlots);
}

//Remove All Time slots
function removeAllTimeSlots() {
    daysOfWeek_abbr.forEach(day => {
        const timeSlotsContainer = document.getElementById(`timeSlots_${day}`);
        timeSlotsContainer.innerText = '';
    });
    clearAllArrays();
}

// Function to delete a time slot
window.deleteTimeSlot = function (button) {
    const timeSlotDiv = button.closest('.d-flex');
    const input = timeSlotDiv.querySelector('input[type="hidden"]');
    if (input) {
        const tsId = input.value; // Get the value of the hidden input
        // console.log('Deleting time slot with ID:', tsId);

        // Remove the time slot from the DOM
        timeSlotDiv.remove();

        // Check if the time slot is new or existing
        if (tsId.startsWith('newTS_')) {
            // Remove from newTimeSlots array
            newTimeSlots = newTimeSlots.filter(slot => slot.tsId !== tsId);
        } else {
            // Remove from existedTimeSlots array and add to waitToDeleteTimeSlots
            existedTimeSlots = existedTimeSlots.filter(slot => slot.tsId != tsId);
            waitToDeleteTimeSlots.push(tsId); // Add to the deletion queue
        }

        // Update allTimeSlots
        allTimeSlots = allTimeSlots.filter(slot => slot.tsId !== tsId);
    }

    // console.log('newTimeSlots', newTimeSlots);
    // console.log('existedTimeSlots-AVR: ', existedTimeSlots);
    // console.log('allTimeSlots', allTimeSlots);
    // console.log('waitToDeleteTimeSlots', waitToDeleteTimeSlots);
};


// Function to initialize timezone
async function fetchSettings() {
    try {
        // First try to get timezone from user settings
        const settingsUrl = `/schedule/fetch-appointment-settings/`;
        const response = await fetch(settingsUrl);
        if (response.ok) {
            const data = await response.json();
            userTimezone = data.user_timezone;

            // Set the timezone select value if available
            if (userTimezone && timezoneSelect.querySelector(`option[value="${userTimezone}"]`)) {
                timezoneSelect.value = userTimezone;
            } else {
                // Fallback to browser timezone
                userTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;
                timezoneSelect.value = userTimezone;
            }
        }
    } catch (error) {
        console.error('Error fetching timezone:', error);
        // Fallback to browser timezone
        userTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;
        timezoneSelect.value = userTimezone;
    }

    // console.log('Initialized timezone:', userTimezone);
}

// Update your initAvailabilityWizard function:
async function initAvailabilityWizard() {
    await fetchSettings(); // Initialize timezone first
    // console.log("Fetched data after:", sessionLength, userTimezone, class_type);

    setupEventListeners();
    generateAccordionItems();
    setupAccordionInteractions();
    showAvailableTimeSlots();
}

document.addEventListener('DOMContentLoaded', async () => {


    // console.log("Fetched data after:", sessionLength, userTimezone, class_type);


    //===============================  Event Delegation START  ==========================================
    // Add a single event listener to the parent container
    accordionContainer.addEventListener('click', (event) => {
        const target = event.target;

        // Handle "Add Time" button clicks
        if (target.id && target.id.startsWith('addTime_')) {
            const day = target.id.replace('addTime_', ''); // e.g. addTime__MON => day= 'MON'
            addNewTimeSlot(day);
        }

        // Handle "Clear" button clicks
        if (target.id && target.id.startsWith('clear_')) {
            const day = target.id.replace('clear_', ''); // e.g. clear_SUN => day='SUN'
            removeTimeSlots(day);
        }

        // Handle "Clear" button clicks
        if (target.id && target.id.startsWith('freeDay_')) {
            const day = target.id.replace('freeDay_', ''); // e.g. freeDay_SUN => day='SUN'
            freeDay(day);
        }
    });

    //=================================== Event Delegation END ===========================================
// Free week checkbox
    btnFreeWeek.addEventListener('change', () => {
        const isChecked = btnFreeWeek.checked;// Get the state of the "Free Week" checkbox
        daysOfWeek_abbr.forEach(day => {
            const freeDayCheckbox = document.getElementById(`freeDay_${day}`);
            if (freeDayCheckbox) {
                freeDayCheckbox.checked = isChecked;
                // Call the `freeDay` function to handle the logic for each day
                freeDay(day, isChecked); // Pass `true` to indicate programmatic call
                // freeDay(day, true);// Pass `true` to indicate programmatic call
            }
        });
    });


    // Initialize the wizard
    initAvailabilityWizard();

});

//=======================================================================
// ============================== ARCHIVED ==============================
//=======================================================================


//--------------------------------- Fetch Tutor Appointment Settings START -----------------------------------------

// Fetch tutor appointment settings
async function fetchSettings1() {
    const url = `/schedule/fetch-appointment-settings/`;
    try {
        const response = await fetch(url);
        if (!response.ok) throw new Error('Failed to fetch settings data');
        const data = await response.json();
        sessionLength = parseInt(data.session_length);
        userTimezone = data.user_timezone || timezoneSelect.value;
        class_type = data.class_type;

        // Set the timezone select value
        if (userTimezone && timezoneSelect.querySelector(`option[value="${userTimezone}"]`)) {
            timezoneSelect.value = userTimezone;
        }

        // console.log("Fetched settings:", data);
    } catch (error) {
        console.error('Error fetching settings:', error);
        // Set default timezone if fetch fails
        userTimezone = timezoneSelect.value || 'UTC';
    }
}

// Wait for settings to be fetched
// await fetchSettings1();
//--------------------------------- Fetch Settings END ---------------------------------------------------

// Function to generate accordion items
function generateAccordionItems_MAIN() {
    accordionContainer.innerHTML = ''; // Clear existing items

    for (let i = 0; i < 7; i++) {
        const dayIndex = i;
        const fullDayName = daysOfWeek[dayIndex];
        const abbrDay = daysOfWeek_abbr[dayIndex];

        const accordionItem = document.createElement('div');
        accordionItem.className = `accordion-item`;
        accordionItem.innerHTML = `
                <h6 class="accordion-header font-base" id="heading_${abbrDay}">
                    <button class="accordion-button rounded collapsed" type="button" data-bs-toggle="collapse"
                            data-bs-target="#collapse_${abbrDay}" aria-expanded="false" aria-controls="collapse_${abbrDay}">
                        <span class="fw-bold me-3 text-primary">${fullDayName}</span>
                    </button>
                </h6>
                <div id="collapse_${abbrDay}" class="accordion-collapse collapse" aria-labelledby="heading_${abbrDay}"
                     data-bs-parent="#AccordionWeekDays">
                    <div class="accordion-body mt-3">
                        <div id="timeSlots_${abbrDay}" class="time-slots-container"></div>
                        <hr>
                        <div class="d-flex justify-content-between align-items-center">
                            <div class="d-flex align-items-center gap-2 h-100">
                                <input type="time" class="form-control form-control-sm h-100" id="startTime_${abbrDay}">
                                <span class="fw-bold">-</span>
                                <input type="time" class="form-control form-control-sm h-100" id="endTime_${abbrDay}">
                            </div>
                            <div class="d-flex align-items-center gap-2 h-100">
                                <button class="btn btn-sm btn-dark h-100" id="addTime_${abbrDay}"> 
                                    <i class="bi bi-plus-circle me-2"></i>Add time
                                </button>
                                <button class="btn btn-sm btn-danger h-100" id="clear_${abbrDay}">
                                    <i class="bi bi-eraser me-2"></i>Clear ${abbrDay}
                                </button>
                            </div>
                            <div class="form-check form-check-md">
                                <input class="form-check-input" type="checkbox" value="" id="freeDay_${abbrDay}">
                                <label class="form-check-label" for="freeDay_${abbrDay}">Free whole ${fullDayName}</label>
                            </div>
                        </div>
                    </div>
                </div>
            `;
        accordionContainer.appendChild(accordionItem);
    }
}

function generateAccordionItems_grid() {
    accordionContainer.innerHTML = '';

    // Create a responsive grid container
    const gridContainer = document.createElement('div');
    gridContainer.className = 'row g-3';
    accordionContainer.appendChild(gridContainer);

    for (let i = 0; i < 7; i++) {
        const dayIndex = i;
        const fullDayName = daysOfWeek[dayIndex];
        const abbrDay = daysOfWeek_abbr[dayIndex];

        // Create column for each accordion item
        const column = document.createElement('div');
        column.className = 'col-12 col-md-6 col-lg-4'; // 3 columns on desktop, 2 on tablet, 1 on mobile

        const accordionItem = document.createElement('div');
        accordionItem.className = 'accordion-item border-0 shadow-sm h-100';
        accordionItem.innerHTML = `
            <!-- Each accordion item is independent (no data-bs-parent) -->
            <h6 class="accordion-header" id="heading_${abbrDay}">
                <button class="accordion-button collapsed rounded-3 bg-light w-100 d-flex align-items-center" 
                        type="button" data-bs-toggle="collapse" data-bs-target="#collapse_${abbrDay}" 
                        aria-expanded="false" aria-controls="collapse_${abbrDay}">
                    <i class="bi bi-calendar-check me-2 text-primary flex-shrink-0"></i>
                    <span class="fw-semibold text-truncate me-2">${fullDayName}</span>
                </button>
            </h6>
            <div id="collapse_${abbrDay}" class="accordion-collapse collapse" 
                 aria-labelledby="heading_${abbrDay}">
                <!-- Removed data-bs-parent to make each accordion independent -->
                <div class="accordion-body p-3">
                    <!-- Time Slots Container -->
                    <div id="timeSlots_${abbrDay}" class="time-slots-container mb-3" style="max-height: 120px; overflow-y: auto;"></div>
                    
                    <!-- Time Input Section -->
                    <div class="bg-light rounded p-3">
                        <!-- Time Inputs Row -->
                        <div class="row g-2 align-items-center mb-2">
                            <div class="col-12">
                                <div class="d-flex align-items-center gap-2">
                                    <input type="time" class="form-control form-control-sm flex-grow-1" 
                                           id="startTime_${abbrDay}" placeholder="Start">
                                    <span class="text-muted fw-bold">-</span>
                                    <input type="time" class="form-control form-control-sm flex-grow-1" 
                                           id="endTime_${abbrDay}" placeholder="End">
                                </div>
                            </div>
                        </div>
                        
                        <!-- Buttons Row -->
                        <div class="row g-2 align-items-center">
                            <div class="col-8">
                                <div class="d-flex gap-2">
                                    <button class="btn btn-sm btn-primary flex-fill" id="addTime_${abbrDay}">
                                        <i class="bi bi-plus-circle me-1"></i>Add
                                    </button>
                                    <button class="btn btn-sm btn-outline-danger" id="clear_${abbrDay}">
                                        <i class="bi bi-eraser"></i>
                                    </button>
                                </div>
                            </div>
                            <div class="col-4">
                                <div class="form-check form-switch mb-0">
                                    <input class="form-check-input" type="checkbox" id="freeDay_${abbrDay}">
                                    <label class="form-check-label small text-muted" for="freeDay_${abbrDay}">
                                        All day
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Help Text -->
                    <div class="mt-2">
                        <small class="text-muted">
                            <i class="bi bi-info-circle me-1"></i>
                            Add multiple time slots as needed
                        </small>
                    </div>
                </div>
            </div>
        `;

        column.appendChild(accordionItem);
        gridContainer.appendChild(column);
    }
}

function generateAccordionItems_grid2() {
    accordionContainer.innerHTML = '';

    // Create responsive grid container
    const gridContainer = document.createElement('div');
    gridContainer.className = 'row g-3';
    accordionContainer.appendChild(gridContainer);

    for (let i = 0; i < 7; i++) {
        const dayIndex = i;
        const fullDayName = daysOfWeek[dayIndex];
        const abbrDay = daysOfWeek_abbr[dayIndex];

        // Create column for each accordion item
        const column = document.createElement('div');
        column.className = 'col-12 col-md-6 col-lg-6'; // Responsive columns

        const accordionItem = document.createElement('div');
        accordionItem.className = 'accordion-item border-0 shadow-sm h-100';
        accordionItem.innerHTML = `
            <h6 class="accordion-header" id="heading_${abbrDay}">
                <button class="accordion-button collapsed rounded-3 bg-light w-100 d-flex align-items-center" 
                        type="button" data-bs-toggle="collapse" data-bs-target="#collapse_${abbrDay}" 
                        aria-expanded="false" aria-controls="collapse_${abbrDay}">
                    <i class="bi bi-calendar-check me-2 text-primary flex-shrink-0"></i>
                    <span class="fw-semibold text-truncate me-2">${fullDayName}</span>
                </button>
            </h6>
            <div id="collapse_${abbrDay}" class="accordion-collapse collapse" 
                 aria-labelledby="heading_${abbrDay}">
                <div class="accordion-body p-3">
                    <!-- Time Slots Container -->
                    <div id="timeSlots_${abbrDay}" class="time-slots-container mb-3" style="max-height: 120px; overflow-y: auto;"></div>
                    
                    <!-- ALL CONTROLS IN SINGLE ROW -->
                    <div class="controls-row">
                        <!-- Time Inputs -->
                        <div class="time-inputs">
                            <input type="time" class="form-control form-control-sm time-input" 
                                   id="startTime_${abbrDay}" placeholder="Start">
                            <span class="time-separator">-</span>
                            <input type="time" class="form-control form-control-sm time-input" 
                                   id="endTime_${abbrDay}" placeholder="End">
                        </div>
                        
                        <!-- Action Buttons -->
                        <div class="action-buttons">
                            <button class="btn btn-sm btn-primary add-btn" id="addTime_${abbrDay}" 
                                    title="Add time slot">
                                <i class="bi bi-plus-circle"></i>
                            </button>
                            <button class="btn btn-sm btn-outline-danger clear-btn" id="clear_${abbrDay}" 
                                    title="Clear all slots">
                                <i class="bi bi-eraser"></i>
                            </button>
                        </div>
                        
                        <!-- Free Day Toggle -->
                        <div class="free-day-toggle">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" id="freeDay_${abbrDay}">
                                <label class="form-check-label" for="freeDay_${abbrDay}" title="Mark as free all day">
                                    <i class="bi bi-clock"></i>
                                </label>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Help Text -->
                    <div class="mt-2 text-center">
                        <small class="text-muted">
                            <i class="bi bi-info-circle me-1"></i>
                            Add multiple time slots
                        </small>
                    </div>
                </div>
            </div>
        `;

        column.appendChild(accordionItem);
        gridContainer.appendChild(column);
    }
}

// Helper function to format the time in local time zone (HH:MM)
function formatLocalTime(date) {
    const hours = String(date.getHours()).padStart(2, '0');
    const minutes = String(date.getMinutes()).padStart(2, '0');
    return `${hours}:${minutes}`;
}

// Handle accordion events
function handleAccordionEvents(event) {
    const target = event.target;

    // Handle "Add Time" button clicks
    if (target.id && target.id.startsWith('addTime_')) {
        const day = target.id.replace('addTime_', '');
        addNewTimeSlot(day);
    }

    // Handle "Clear" button clicks
    if (target.id && target.id.startsWith('clear_')) {
        const day = target.id.replace('clear_', '');
        removeTimeSlots(day);
    }

    // Handle free day checkbox clicks
    if (target.id && target.id.startsWith('freeDay_')) {
        const day = target.id.replace('freeDay_', '');
        freeDay(day);
    }
}


//---------------------------------- Provider POPUP START ------------------------------------
// This function checks if selectedSessions and waitToDeleteTimeSlots are empty or not
function isChangedWeek() {
    return (waitToDeleteTimeSlots.length > 0 || newTimeSlots.length > 0);
}


let currentCallback = null;

// Define the event handler functions
function handleYesClick() {
    const modal = bootstrap.Modal.getInstance(document.getElementById('confirmWeek'));
    modal.hide(); // Hide the modal
    const shouldSubmit = true;
    if (currentCallback) currentCallback(shouldSubmit); // Proceed with the action and trigger submit
}

function handleNoClick() {
    const modal = bootstrap.Modal.getInstance(document.getElementById('confirmWeek'));
    modal.hide(); // Hide the modal
    const shouldSubmit = false;
    if (currentCallback) currentCallback(shouldSubmit); // Proceed with the action without triggering submit
}

// Add event listener for Yes button
const btnYes = document.getElementById('btnYes');
btnYes.addEventListener('click', handleYesClick);

// Add event listener for No button
const btnNo = document.getElementById('btnNo');
btnNo.addEventListener('click', handleNoClick);

//-------------------------- Provider POPUP END -----------------------------

// Function to add available time slots to the accordion
function addAvailableTimeSlot(tsId, day, startTime, endTime) {
    // Create a new time slot
    const existedTimeSlot = document.createElement('div');

    existedTimeSlot.innerHTML = `
      <div class="d-flex justify-content-between align-items-center mb-2">
        <div class="position-relative time-slots">
          <span  class="btn btn-primary btn-round btn-sm mb-0 stretched-link position-static"><i class="fas fa-calendar-check"></i></span>
          <span class="ms-2 mb-0 h6 fw-light">${day}</span>
          <span class="ms-2 mb-0 h6 fw-light">${startTime} - ${endTime}</span>
          <input type="hidden" value="${tsId}"> <!-- Add a hidden input to store the ID -->
        </div>
        <div>
          <button class="btn btn-sm btn-danger-soft btn-round mb-0" onclick="deleteTimeSlot(this)"><i class="fas fa-fw fa-times"></i></button>
        </div>
      </div>
    `;

    // Append the new time slot to the accordion area
    const timeSlotsContainer = document.getElementById(`timeSlots_${day}`);
    timeSlotsContainer.appendChild(existedTimeSlot);
}

function addAvailableTimeSlot2(tsId, day, startTime, endTime) {
    const timeSlotsContainer = document.getElementById(`timeSlots_${day}`);

    const timeSlotItem = document.createElement('div');
    timeSlotItem.className = 'time-slot-item d-flex justify-content-between align-items-center';
    timeSlotItem.innerHTML = `
        <div class="time-range">
            <span class="fw-medium">${startTime}</span> - <span class="fw-medium">${endTime}</span>
        </div>
        <button class="btn btn-sm btn-link text-danger p-0" onclick="deleteTimeSlot(this)">
            <i class="bi bi-x-circle"></i>
        </button>
    `;

    timeSlotItem.setAttribute('data-ts-id', tsId);
    timeSlotsContainer.appendChild(timeSlotItem);

    // Update badge count
    updateDayBadge(day, timeSlotsContainer.children.length);
}

function updateDayBadge(day, count) {
    const badge = document.getElementById(`badge_${day}`);
    if (badge) {
        badge.textContent = count;
        badge.className = `badge ${count > 0 ? 'bg-primary-soft text-primary' : 'bg-secondary-soft text-secondary'} ms-auto`;
    }
}

// Enhanced button functionality
function setupButtonInteractions() {
    // Add hover effects
    const buttons = document.querySelectorAll('.add-btn, .clear-btn');
    buttons.forEach(btn => {
        btn.addEventListener('mouseenter', function () {
            this.style.transform = 'translateY(-2px)';
            this.style.boxShadow = '0 4px 12px rgba(0, 0, 0, 0.15)';
        });

        btn.addEventListener('mouseleave', function () {
            this.style.transform = 'translateY(0)';
            this.style.boxShadow = '0 2px 6px rgba(0, 0, 0, 0.1)';
        });
    });

    // Add click animations
    buttons.forEach(btn => {
        btn.addEventListener('click', function () {
            this.style.transform = 'translateY(1px)';
            setTimeout(() => {
                this.style.transform = 'translateY(0)';
            }, 150);
        });
    });

    // Add keyboard shortcuts
    document.addEventListener('keydown', function (e) {
        if (e.altKey) {
            const focusedElement = document.activeElement;
            if (focusedElement.classList.contains('time-input')) {
                const day = focusedElement.id.split('_')[1];

                if (e.key === 'Enter') {
                    e.preventDefault();
                    document.getElementById(`addTime_${day}`).click();
                }

                if (e.key === 'Delete') {
                    e.preventDefault();
                    document.getElementById(`clear_${day}`).click();
                }
            }
        }
    });

    // Add input validation
    const timeInputs = document.querySelectorAll('.time-input');
    timeInputs.forEach(input => {
        input.addEventListener('change', function () {
            validateTimeInput(this);
        });

        input.addEventListener('focus', function () {
            this.select();
        });
    });
}

// The rest of your existing functions (addNewTimeSlot, freeDay, removeTimeSlots, etc.)
// will work with minimal changes, mainly updating UI elements to match the new style

async function fetchSettings_MAIN() {
    const url = `/schedule/fetch-appointment-settings/`;
    try {
        const response = await fetch(url);
        if (!response.ok) throw new Error('Failed to fetch settings data');
        const data = await response.json();
        sessionLength = parseInt(data.session_length);
        userTimezone = data.user_timezone;
        class_type = data.class_type;
        // console.log("Fetched data:", data);
    } catch (error) {
        console.error('Error fetching settings:', error);
    }
}