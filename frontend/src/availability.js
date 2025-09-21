import {utcTimeToLocalTime, localTimeToUtcTime} from './timeUtils.js';
import {showAlert} from './utils.js';

// Constants and variables
const accordionContainer = document.getElementById('AccordionWeekDays');
const daysOfWeek = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
const daysOfWeek_abbr = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
const btnFreeWeek = document.getElementById('freeWeek');
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
        showAvailableTimeSlots(userTimezone);
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
                                <div class="bg-light rounded p-3">
                                    <!-- Time Inputs Row -->
                                    <div class="row g-2 align-items-center mb-2">
                                        <div class="col-12">
                                            <div class="d-flex align-items-center gap-2">
                                                <input type="time" class="form-control form-control-sm flex-grow-1" 
                                                       id="startTime_${abbrDay}" placeholder="Start" step="1800">
                                                <span class="text-muted fw-bold">-</span>
                                                <input type="time" class="form-control form-control-sm flex-grow-1" 
                                                       id="endTime_${abbrDay}" placeholder="End" step="1800">
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

    try {
        const url = `/schedule/save-available-rule-times/`;
        const response = await fetch(url, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRFToken': getCookie('csrftoken'),
            },
            body: JSON.stringify(requestData),
        });

        const data = await response.json();

        if (!response.ok) {
            throw new Error(data.message || 'Failed to save availability');
        }

        if (data.status === 'success') {
            // Reset counters and arrays after successful save
            newTimeSlots = [];
            waitToDeleteTimeSlots = [];
            newTimeSlotCounter = 0;
            return {success: true};
        } else {
            return {
                success: false,
                error: data.message || 'Error saving availability'
            };
        }
    } catch (error) {
        console.error('Error:', error);
        return {
            success: false,
            error: 'Error saving availability. Please try again.'
        };
    }
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
    // Handle 24:00 edge case - convert to 23:59 for validation but keep original for display
    const isEndTime24 = endTime === '24:00';
    const normalizedStart = startTime === '24:00' ? '23:59' : startTime;
    const normalizedEnd = isEndTime24 ? '23:59' : endTime;

    // Check if minutes are 00 or 30 (allow 59 for 24:00 case)
    const isValidMinutes = (time) => {
        if (time === '24:00') return true; // Special case
        const minutes = time.split(':')[1];
        return minutes === '00' || minutes === '30' || (isEndTime24 && minutes === '59');
    };

    if (!isValidMinutes(startTime) || !isValidMinutes(endTime)) {
        showAlert('Please enter times with minutes rounded to 00 or 30 (e.g., 10:00, 10:30).', 'error');
        return false;
    }

    // Special case: if start is 24:00, it's invalid
    if (startTime === '24:00') {
        showAlert('Start time cannot be 24:00. Please use 00:00 instead.', 'error');
        return false;
    }

    // Check if endTime is after startTime
    if (normalizedStart >= normalizedEnd) {
        showAlert('End time must be after start time.', 'error');
        return false;
    }

    return true;
}

function isOverlapping(day, newStart, newEnd) {
    const timeSlotsContainer = document.getElementById(`timeSlots_${day}`);
    const timeSlots = Array.from(timeSlotsContainer.children);

    // Normalize times for comparison (handle 24:00 edge case)
    const normalizeTime = (time) => time === '24:00' ? '23:59' : time;
    const normNewStart = normalizeTime(newStart);
    const normNewEnd = normalizeTime(newEnd);

    for (const slot of timeSlots) {
        const timeRange = slot.querySelector('span:nth-child(3)')?.textContent.trim();
        if (timeRange) {
            let [startTime, endTime] = timeRange.split(' - ');

            // Handle next day notation in end time
            if (endTime.length > 5) {
                endTime = '24:00';
            }

            // Normalize existing times
            const normStartTime = normalizeTime(startTime);
            const normEndTime = normalizeTime(endTime);

            if (
                (normNewStart >= normStartTime && normNewStart < normEndTime) ||
                (normNewEnd > normStartTime && normNewEnd <= normEndTime) ||
                (normNewStart <= normStartTime && normNewEnd >= normEndTime)
            ) {
                return true; // Overlapping found
            }
        }
    }

    return false; // No overlapping
}

//Clear All Arrays
function clearAllArrays() {
    newTimeSlots = [];
    existedTimeSlots = [];
    waitToDeleteTimeSlots = [];
    allTimeSlots = [];
}

//Remove timeSlots of one special Day in HTML not in array (allTimeSlots)
function removeTimeSlots(day) {
    const timeSlotsContainer = document.getElementById(`timeSlots_${day}`);
    const timeSlots = Array.from(timeSlotsContainer.children);

    timeSlots.forEach(slot => {
        const input = slot.querySelector('input[type="hidden"]');
        if (input) {
            const tsId = input.value;
            if (tsId.startsWith('newTS_')) {
                // Remove from newTimeSlots array
                newTimeSlots = newTimeSlots.filter(slot => slot.tsId !== tsId);
            } else {
                // Add to the deletion queue
                waitToDeleteTimeSlots.push(tsId);
            }
        }
    });

    existedTimeSlots = existedTimeSlots.filter(slot => slot.day !== day);
    timeSlotsContainer.innerHTML = '';
}

//Remove All Time slots
function removeAllTimeSlots() {
    daysOfWeek_abbr.forEach(day => {
        const timeSlotsContainer = document.getElementById(`timeSlots_${day}`);
        if (timeSlotsContainer) timeSlotsContainer.innerHTML = '';
    });
    clearAllArrays();
}

// Function to delete a time slot
window.deleteTimeSlot = function (button) {
    const timeSlotDiv = button.closest('.d-flex');
    const input = timeSlotDiv.querySelector('input[type="hidden"]');

    if (input) {
        const tsId = input.value;

        // Remove the time slot from the DOM
        timeSlotDiv.remove();

        // Check if the time slot is new or existing
        if (tsId.startsWith('newTS_')) {
            // Remove from newTimeSlots array
            newTimeSlots = newTimeSlots.filter(slot => slot.tsId !== tsId);
        } else {
            // Remove from existedTimeSlots array and add to waitToDeleteTimeSlots
            existedTimeSlots = existedTimeSlots.filter(slot => slot.tsId != tsId);
            waitToDeleteTimeSlots.push(tsId);
        }
    }
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

            // Also get session length and class type
            sessionLength = parseInt(data.session_length) || 2;
            class_type = data.class_type;
        }
    } catch (error) {
        console.error('Error fetching timezone:', error);
        // Fallback to browser timezone
        userTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;
        timezoneSelect.value = userTimezone;
    }
}

// Update your initAvailabilityWizard function:
async function initAvailabilityWizard_MAIN() {
    await fetchSettings(); // Initialize timezone first
    setupEventListeners();
    generateAccordionItems();
    setupAccordionInteractions();
    showAvailableTimeSlots();
}


// When fetching availability, pass the viewer's timezone
// In your script.js file, replace the showAvailableTimeSlots function:
async function showAvailableTimeSlots_MAIN(viewerTimezone = null) {
    let url = `/schedule/get-available-rules/?providerUId=${providerUId}`;

    // Add viewer's timezone if provided
    if (viewerTimezone) {
        url += `&timezone=${encodeURIComponent(viewerTimezone)}`;
    }

    try {
        const response = await fetch(url);
        if (!response.ok) throw new Error('Failed to fetch availability data');
        const data = await response.json();

        if (data.status !== 'success') {
            throw new Error(data.message || 'Failed to load availability');
        }

        // Clear existing time slots
        daysOfWeek_abbr.forEach(day => {
            const container = document.getElementById(`timeSlots_${day}`);
            if (container) container.innerHTML = '';
        });

        existedTimeSlots = [];

        // Display availability
        data.availability.forEach(availability => {
            const availId = availability.availId;
            const isFullDay = availability.is_full_day;
            const weekday = availability.weekday;

            const dayAbbr = daysOfWeek_abbr[weekday];
            const startTime = availability.start_time_local;
            const endTime = availability.end_time_local;

            if (dayAbbr) {
                addAvailableTimeSlot(availId, dayAbbr, startTime, endTime, isFullDay);

                // Also store in existedTimeSlots array
                existedTimeSlots.push({
                    tsId: availId,
                    day: dayAbbr,
                    start: startTime,
                    end: endTime,
                    isFullDay: isFullDay
                });
            }
        });

        console.log('Availability loaded successfully:', data.availability);

    } catch (error) {
        console.error('Error fetching availability:', error);
        showAlert('Failed to load availability: ' + error.message, 'error');
    }
}

function addAvailableTimeSlot_MAIN(tsId, day, startTime, endTime, isFullDay = false) {
    const timeSlotsContainer = document.getElementById(`timeSlots_${day}`);

    if (!timeSlotsContainer) {
        console.error(`Time slots container for ${day} not found`);
        return;
    }

    // Check for duplicates
    const existingSlots = timeSlotsContainer.querySelectorAll('input[type="hidden"]');
    for (const input of existingSlots) {
        if (input.value === tsId.toString()) return;
    }

    const timeSlot = document.createElement('div');
    timeSlot.innerHTML = `
      <div class="d-flex justify-content-between align-items-center mb-2 ${isFullDay ? 'full-day-slot' : ''}">
        <div class="position-relative time-slots">
          <span class="btn ${isFullDay ? 'btn-success' : 'btn-primary'} btn-round btn-sm mb-0 stretched-link position-static">
            <i class="fas ${isFullDay ? 'fa-calendar-day' : 'fa-calendar-check'}"></i>
          </span>
          <span class="ms-2 mb-0 h6 fw-light">${day}</span>
          <span class="ms-2 mb-0 h6 fw-light">${startTime} - ${endTime}</span>
          <input type="hidden" value="${tsId}">
          ${isFullDay ? '<span class="badge bg-info ms-2">All Day</span>' : ''}
        </div>
        <div>
          <button class="btn btn-sm btn-danger-soft btn-round mb-0" onclick="deleteTimeSlot(this)">
            <i class="fas fa-fw fa-times"></i>
          </button>
        </div>
      </div>
    `;

    timeSlotsContainer.appendChild(timeSlot);
}


// Function to add a NEW time slot
function addNewTimeSlot1(day) {
    const startTimeInput = document.getElementById(`startTime_${day}`);
    const endTimeInput = document.getElementById(`endTime_${day}`);
    const startTime = startTimeInput.value;
    const endTime = endTimeInput.value;

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
          <span class="btn btn-primary btn-round btn-sm mb-0 stretched-link position-static"><i class="fas fa-calendar-check"></i></span>
          <span class="ms-2 mb-0 h6 fw-light">${day}</span>
          <span class="ms-2 mb-0 h6 fw-light">${startTime} - ${endTime}</span>
          <input type="hidden" value="${tsId}">
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
        providerUId: providerUId,
        timezone: userTimezone,
        day: day,
        startTime: startTime,
        endTime: endTime,
    };

    newTimeSlots.push(timeSlot);

    // Clear the input fields
    startTimeInput.value = '';
    endTimeInput.value = '';
}

function addNewTimeSlot_MAIN(day) {
    const startTimeInput = document.getElementById(`startTime_${day}`);
    const endTimeInput = document.getElementById(`endTime_${day}`);
    const startTime = startTimeInput.value;
    const endTime = endTimeInput.value;

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
    //========================================


    //========================================
    // Create a new time slot
    const newTimeSlot = document.createElement('div');
    // In the addNewTimeSlot function, after validation
// Use the original times (not normalized ones) for display and storage
    const displayEndTime = endTime === '23:59' ? '24:00' : endTime;
// Create a new time slot with the display time
    newTimeSlot.innerHTML = `
  <div class="d-flex justify-content-between align-items-center mb-2">
    <div class="position-relative time-slots">
      <span class="btn btn-primary btn-round btn-sm mb-0 stretched-link position-static"><i class="fas fa-calendar-check"></i></span>
      <span class="ms-2 mb-0 h6 fw-light">${day}</span>
      <span class="ms-2 mb-0 h6 fw-light">${startTime} - ${displayEndTime}</span>
      <input type="hidden" value="${tsId}">
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
    // Store the original times in the array
    const timeSlot = {
        tsId: tsId,
        providerUId: providerUId,
        timezone: userTimezone,
        day: day,
        startTime: startTime,
        endTime: endTime === '23:59' ? '24:00' : endTime, // Store as 24:00 if it was 23:59
    };

    newTimeSlots.push(timeSlot);

    // Clear the input fields
    startTimeInput.value = '';
    endTimeInput.value = '';
}

// checkbox to indicate a special day of week is free or not!
function freeDay_MAIN(day, isProgrammatic = false) {
    const freeDayCheckbox = document.getElementById(`freeDay_${day}`);
    const timeSlotsContainer = document.getElementById(`timeSlots_${day}`);

    if (!freeDayCheckbox || !timeSlotsContainer) {
        console.error(`Checkbox or time slots container for ${day} not found!`);
        return;
    }

    // If the function is called programmatically, check the checkbox
    if (isProgrammatic) {
        freeDayCheckbox.checked = true;
    }

    if (freeDayCheckbox.checked) {
        // Store the current time slots before clearing them
        previousTimeSlots[day] = timeSlotsContainer.innerHTML;

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
            tsId: `newTS_Full_${day}`,
            providerUId: providerUId,
            timezone: userTimezone,
            day: day,
            startTime: '00:00',
            endTime: '24:00',
        };

        // Remove any existing full day slot for this day
        newTimeSlots = newTimeSlots.filter(slot => !(slot.day === day && slot.tsId.startsWith('newTS_Full_')));
        newTimeSlots.push(timeSlot);

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

        // Remove any full day slot from newTimeSlots
        newTimeSlots = newTimeSlots.filter(slot => !(slot.day === day && slot.tsId.startsWith('newTS_Full_')));

        // Retrieve and display the previous time slots
        if (previousTimeSlots[day]) {
            timeSlotsContainer.innerHTML = previousTimeSlots[day];

            // Reattach event listeners to delete buttons
            timeSlotsContainer.querySelectorAll('.btn-danger-soft').forEach(btn => {
                btn.onclick = function () {
                    deleteTimeSlot(this);
                };
            });
        } else {
            timeSlotsContainer.innerHTML = '';
        }
    }
}

// ================================================================================
async function showAvailableTimeSlots(viewerTimezone = null) {
    let url = `/schedule/get-available-rules/?providerUId=${providerUId}`;

    if (viewerTimezone) {
        url += `&timezone=${encodeURIComponent(viewerTimezone)}`;
    }

    try {
        const response = await fetch(url);
        if (!response.ok) throw new Error('Failed to fetch availability data');
        const data = await response.json();

        if (data.status !== 'success') {
            throw new Error(data.message || 'Failed to load availability');
        }

        // Clear existing time slots
        daysOfWeek_abbr.forEach(day => {
            const container = document.getElementById(`timeSlots_${day}`);
            if (container) container.innerHTML = '';
        });

        existedTimeSlots = [];

        // Display availability and check "All day" checkboxes for full days
        data.availability.forEach(availability => {
            const availId = availability.availId;
            const isFullDay = availability.is_full_day;
            const isPartialDay = availability.is_partial_day || false;
            const weekday = availability.weekday;
            const originalWeekday = availability.original_weekday;

            // Convert weekday number to abbreviation (0 = SUN, 1 = MON, etc.)
            const dayAbbr = daysOfWeek_abbr[parseInt(weekday)];
            const startTime = availability.start_time_local;
            const endTime = availability.end_time_local;

            if (dayAbbr) {
                // Check "All day" checkbox if it's a full day in the original timezone
                if (isFullDay && !isPartialDay && weekday === originalWeekday) {
                    const freeDayCheckbox = document.getElementById(`freeDay_${dayAbbr}`);
                    if (freeDayCheckbox) {
                        freeDayCheckbox.checked = true;
                        toggleDayInputs(dayAbbr, true);
                    }
                }

                addAvailableTimeSlot(availId, dayAbbr, startTime, endTime, isFullDay, isPartialDay, originalWeekday);

                // Store in existedTimeSlots array
                existedTimeSlots.push({
                    tsId: availId,
                    day: dayAbbr,
                    start: startTime,
                    end: endTime,
                    isFullDay: isFullDay,
                    isPartialDay: isPartialDay,
                    originalWeekday: originalWeekday
                });
            }
        });

    } catch (error) {
        console.error('Error fetching availability:', error);
        showAlert('Failed to load availability: ' + error.message, 'error');
    }
}

// Enhanced addAvailableTimeSlot function
function addAvailableTimeSlot(tsId, day, startTime, endTime, isFullDay = false, isPartialDay = false, originalWeekday = null) {
    const timeSlotsContainer = document.getElementById(`timeSlots_${day}`);

    if (!timeSlotsContainer) {
        console.error(`Time slots container for ${day} not found`);
        return;
    }

    // Check for duplicates
    const existingSlots = timeSlotsContainer.querySelectorAll('input[type="hidden"]');
    for (const input of existingSlots) {
        if (input.value === tsId.toString()) return;
    }

    let tooltip = '';
    if (isPartialDay && originalWeekday !== null) {
        const originalDay = daysOfWeek_abbr[parseInt(originalWeekday)];
        tooltip = `Part of ${originalDay}'s availability in tutor's timezone`;
    }

    const timeSlot = document.createElement('div');
    timeSlot.innerHTML = `
      <div class="d-flex justify-content-between align-items-center mb-2 ${isFullDay ? 'full-day-slot' : ''} ${isPartialDay ? 'partial-day-slot' : ''}"
           ${tooltip ? `data-bs-toggle="tooltip" title="${tooltip}"` : ''}>
        <div class="position-relative time-slots">
          <span class="btn ${isFullDay ? 'btn-success' : (isPartialDay ? 'btn-warning' : 'btn-primary')} btn-round btn-sm mb-0 stretched-link position-static">
            <i class="fas ${isFullDay ? 'fa-calendar-day' : (isPartialDay ? 'fa-clock' : 'fa-calendar-check')}"></i>
          </span>
          <span class="ms-2 mb-0 h6 fw-light">${day}</span>
          <span class="ms-2 mb-0 h6 fw-light">${startTime} - ${endTime}</span>
          <input type="hidden" value="${tsId}">
          ${isFullDay ? '<span class="badge bg-info ms-2">All Day</span>' : ''}
          ${isPartialDay ? '<span class="badge bg-warning ms-2">Timezone Adjusted</span>' : ''}
        </div>
        <div>
          <button class="btn btn-sm btn-danger-soft btn-round mb-0" onclick="deleteTimeSlot(this)">
            <i class="fas fa-fw fa-times"></i>
          </button>
        </div>
      </div>
    `;

    timeSlotsContainer.appendChild(timeSlot);

    // Initialize tooltips if any
    if (tooltip) {
        new bootstrap.Tooltip(timeSlot);
    }
}
// ----------------------------------------------------------
// Enhanced freeDay function with input disabling
function freeDay(day, isProgrammatic = false) {
    const freeDayCheckbox = document.getElementById(`freeDay_${day}`);
    const timeSlotsContainer = document.getElementById(`timeSlots_${day}`);

    if (!freeDayCheckbox || !timeSlotsContainer) {
        console.error(`Checkbox or time slots container for ${day} not found!`);
        return;
    }

    if (isProgrammatic) {
        freeDayCheckbox.checked = true;
    }

    if (freeDayCheckbox.checked) {
        // Store current time slots
        previousTimeSlots[day] = timeSlotsContainer.innerHTML;

        // Clear all existing time slots
        removeTimeSlots(day);
        timeSlotsContainer.innerHTML = '';

        // Add full day slot
        const newTimeSlot = document.createElement('div');
        newTimeSlot.innerHTML = `
          <div class="d-flex justify-content-between align-items-center mb-2 full-day-slot">
              <div class="position-relative time-slots">
                  <span class="btn btn-success btn-round btn-sm mb-0 stretched-link position-static"><i class="fas fa-calendar-day"></i></span>
                  <span class="ms-2 mb-0 h6 fw-light">${day}</span>
                  <span class="ms-2 mb-0 h6 fw-light">00:00 - 24:00</span>
                  <input type="hidden" value="newTS_Full_${day}">
                  <span class="badge bg-info ms-2">All Day</span>
              </div>
              <div>
                <button class="btn btn-sm btn-danger-soft btn-round mb-0" onclick="deleteTimeSlot(this)">
                  <i class="fas fa-fw fa-times"></i>
                </button>
              </div>
          </div>
        `;
        timeSlotsContainer.appendChild(newTimeSlot);

        // Add to newTimeSlots array
        const timeSlot = {
            tsId: `newTS_Full_${day}`,
            providerUId: providerUId,
            timezone: userTimezone,
            day: day,
            startTime: '00:00',
            endTime: '24:00',
            isFullDay: true
        };

        // Remove any existing slots for this day
        newTimeSlots = newTimeSlots.filter(slot => slot.day !== day);
        newTimeSlots.push(timeSlot);

        // Disable inputs for this day
        toggleDayInputs(day, true);
    } else {
        // Enable inputs for this day
        toggleDayInputs(day, false);

        // Remove full day slot
        newTimeSlots = newTimeSlots.filter(slot => !(slot.day === day && slot.isFullDay));

        // Restore previous time slots if any
        if (previousTimeSlots[day]) {
            timeSlotsContainer.innerHTML = previousTimeSlots[day];
            timeSlotsContainer.querySelectorAll('.btn-danger-soft').forEach(btn => {
                btn.onclick = function () {
                    deleteTimeSlot(this);
                };
            });
        } else {
            timeSlotsContainer.innerHTML = '';
        }
    }
}

// Helper function to toggle day inputs
function toggleDayInputs(day, disabled) {
    document.getElementById(`addTime_${day}`).disabled = disabled;
    document.getElementById(`clear_${day}`).disabled = disabled;
    document.getElementById(`startTime_${day}`).disabled = disabled;
    document.getElementById(`endTime_${day}`).disabled = disabled;
}

// Enhanced deleteTimeSlot function
window.deleteTimeSlot = function (button) {
    const timeSlotDiv = button.closest('.d-flex');
    const input = timeSlotDiv.querySelector('input[type="hidden"]');

    if (input) {
        const tsId = input.value;

        // Remove from DOM
        timeSlotDiv.remove();

        // Check if it's a full day slot
        const isFullDay = timeSlotDiv.classList.contains('full-day-slot');

        if (isFullDay) {
            // Uncheck the "All day" checkbox
            const day = timeSlotDiv.querySelector('.h6.fw-light').textContent;
            const freeDayCheckbox = document.getElementById(`freeDay_${day}`);
            if (freeDayCheckbox) {
                freeDayCheckbox.checked = false;
                toggleDayInputs(day, false);
            }
        }

        // Remove from appropriate arrays
        if (tsId.startsWith('newTS_')) {
            newTimeSlots = newTimeSlots.filter(slot => slot.tsId !== tsId);
        } else {
            existedTimeSlots = existedTimeSlots.filter(slot => slot.tsId != tsId);
            waitToDeleteTimeSlots.push(tsId);
        }
    }
};

// Enhanced addNewTimeSlot function with full-day check
function addNewTimeSlot(day) {
    // Check if this day already has a full-day slot
    const freeDayCheckbox = document.getElementById(`freeDay_${day}`);
    if (freeDayCheckbox && freeDayCheckbox.checked) {
        showAlert(`Cannot add time slots when "${day}" is set to "All day". Please uncheck "All day" first.`, 'error');
        return;
    }

    const startTimeInput = document.getElementById(`startTime_${day}`);
    const endTimeInput = document.getElementById(`endTime_${day}`);
    const startTime = startTimeInput.value;
    const endTime = endTimeInput.value;

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

    const tsId = `newTS_${newTimeSlotCounter++}`;
    const displayEndTime = endTime === '23:59' ? '24:00' : endTime;

    const newTimeSlot = document.createElement('div');
    newTimeSlot.innerHTML = `
      <div class="d-flex justify-content-between align-items-center mb-2">
        <div class="position-relative time-slots">
          <span class="btn btn-primary btn-round btn-sm mb-0 stretched-link position-static"><i class="fas fa-calendar-check"></i></span>
          <span class="ms-2 mb-0 h6 fw-light">${day}</span>
          <span class="ms-2 mb-0 h6 fw-light">${startTime} - ${displayEndTime}</span>
          <input type="hidden" value="${tsId}">
        </div>
        <div>
          <button class="btn btn-sm btn-danger-soft btn-round mb-0" onclick="deleteTimeSlot(this)"><i class="fas fa-fw fa-times"></i></button>
        </div>
      </div>
    `;

    const timeSlotsContainer = document.getElementById(`timeSlots_${day}`);
    timeSlotsContainer.appendChild(newTimeSlot);

    const timeSlot = {
        tsId: tsId,
        providerUId: providerUId,
        timezone: userTimezone,
        day: day,
        startTime: startTime,
        endTime: endTime === '23:59' ? '24:00' : endTime,
        isFullDay: false
    };

    newTimeSlots.push(timeSlot);
    startTimeInput.value = '';
    endTimeInput.value = '';
}

// Add CSS for partial days
const style = document.createElement('style');
style.textContent = `
.full-day-slot {
    background-color: #f0f9ff;
    border-left: 4px solid #0d6efd;
    padding-left: 8px;
    border-radius: 4px;
}
.partial-day-slot {
    background-color: #fff3cd;
    border-left: 4px solid #ffc107;
    padding-left: 8px;
    border-radius: 4px;
}
.time-slots-container {
    max-height: 200px;
    overflow-y: auto;
}
`;
document.head.appendChild(style);

// ================================================================================
async function initAvailabilityWizard() {
    await fetchSettings();
    setupEventListeners();
    generateAccordionItems();
    setupAccordionInteractions();

    // Show availability in the user's own timezone initially
    showAvailableTimeSlots(userTimezone);
}

document.addEventListener('DOMContentLoaded', async () => {
    // Event delegation for accordion interactions
    accordionContainer.addEventListener('click', (event) => {
        const target = event.target;
        const button = target.closest('button');

        if (!button) return;

        // Handle "Add Time" button clicks
        if (button.id && button.id.startsWith('addTime_')) {
            const day = button.id.replace('addTime_', '');
            addNewTimeSlot(day);
        }

        // Handle "Clear" button clicks
        if (button.id && button.id.startsWith('clear_')) {
            const day = button.id.replace('clear_', '');
            removeTimeSlots(day);
        }
    });

    // Event delegation for checkbox changes
    accordionContainer.addEventListener('change', (event) => {
        const target = event.target;

        // Handle free day checkbox changes
        if (target.id && target.id.startsWith('freeDay_')) {
            const day = target.id.replace('freeDay_', '');
            freeDay(day);
        }
    });

    // Free week checkbox
    if (btnFreeWeek) {
        btnFreeWeek.addEventListener('change', () => {
            const isChecked = btnFreeWeek.checked;
            daysOfWeek_abbr.forEach(day => {
                const freeDayCheckbox = document.getElementById(`freeDay_${day}`);
                if (freeDayCheckbox) {
                    freeDayCheckbox.checked = isChecked;
                    freeDay(day, true);
                }
            });
        });
    }

    // Submit button
    // if (btnSubmitTimes) {
    //     btnSubmitTimes.addEventListener('click', () => {
    //         if (validateAvailability()) {
    //             submitTimes();
    //         }
    //     });
    // }

    // Initialize the wizard
    initAvailabilityWizard();
});