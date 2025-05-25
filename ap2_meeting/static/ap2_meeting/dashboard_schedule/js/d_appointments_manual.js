document.addEventListener('DOMContentLoaded', async () => {
  const accordionWeekDays = document.querySelector('#AccordionWeekDays');
  const daysOfWeek = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
  const daysOfWeek_abbr = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
  // const clearButton = document.getElementById('clear-button');
  const accordionContainer = document.getElementById('AccordionWeekDays');
  const btnPrevWeek = document.getElementById('prev-week');
  const btnCurrentWeek = document.getElementById('current-week');
  const btnNextWeek = document.getElementById('next-week');
  const btnFreeWeek = document.getElementById('freeWeek');
  const btnSubmitTimes = document.getElementById('submitTimes');
  // const tutorId = document.getElementById('tutor_id').value;
  const providerUId = document.getElementById('providerUId').value;
  const previousTimeSlots = {}; // Object to store previous time slots for each day
  let userTimezone;
  let weekDayDates = [];
  let allTimeSlots = [];
  let newTimeSlots = [];
  let newTimeSlotCounter = 0; // Global counter for unique IDs
  let existedTimeSlots = [];
  let waitToDeleteTimeSlots = [];
  let sessionLength = 2; // set a default sessionLength (1=30 min,  2=60 min, 3=90 min , 4=120 min, 6=180 min)
  let startDayOfWeek; // Initialize with the current value
  let class_type;


  //--------------------------------- Fetch Tutor Appointment Settings START -----------------------------------------
  //-------------- Initializing variables (startDayOfWeek, sessionLength, userTimezone, class_type) ------------------
  async function fetchSettings() {
    const url = `/schedule/fetch-appointment-settings/`;
    try {
      const response = await fetch(url);
      if (!response.ok) throw new Error('Failed to fetch settings data');
      const data = await response.json();
      startDayOfWeek = data.week_start;
      sessionLength = parseInt(data.session_length);
      userTimezone = data.user_timezone;
      class_type = data.class_type;
      console.log("Fetched data:", data);
    } catch (error) {
      console.error('Error fetching settings:', error);
    }
  }

  // Wait for settings to be fetched
  await fetchSettings();
  //--------------------------------- Fetch Settings END ---------------------------------------------------
  console.log("Fetched data after:", startDayOfWeek, sessionLength, userTimezone, class_type);


  //------------------------------------------- TIMEZONE START -------------------------------------------------------

  // Helper function to convert UTC time to local time
  function convertUTCToLocal(utcTime, timezone) {
    const utcDate = new Date(utcTime);
    const localTime = utcDate.toLocaleString('en-US', {timeZone: timezone});
    return new Date(localTime);
  }

  //------------------------------------------- TIMEZONE END ---------------------------------------------------------

  //--------------------------------- Date & Time (Provider) START ---------------------------------------------------
  //---------- Initialize table with current week START ------------

  const today = new Date();
  // Calculate the initial start date
  let startDate = calculateStartDate(today, startDayOfWeek);

  // Function to calculate the start date based on the selected start day of the week
  function calculateStartDate(today, startDayOfWeek) {
    let startDate = new Date(today);
    const dayOfWeek = today.getDay();
    const dayOfMonth = today.getDate();

    // Adjust startDate to the start of the current week containing "today"
    startDate.setDate(dayOfMonth - (dayOfWeek < startDayOfWeek ? dayOfWeek + 7 - startDayOfWeek : dayOfWeek - startDayOfWeek));

    return startDate;
  }

  // Helper function to check if a date is before today
  function isBeforeToday(date) {
    const today = new Date();
    today.setHours(0, 0, 0, 0); // Reset time part to compare only dates
    return date < today;
  }

  // Check if a week has at least one available day
  function hasAvailableDays(startDate) {
    for (let i = 0; i < 7; i++) {
      const currentDate = new Date(startDate);
      currentDate.setDate(startDate.getDate() + i);
      if (!isBeforeToday(currentDate)) {
        return true; // At least one day is available
      }
    }
    return false; // No available days in the week
  }


  //--------------------------------- Date & Time (Provider) END -----------------------------------------------------

  //---------------------------------- Navigate week Buttons START ---------------------------------------------------
  btnPrevWeek.addEventListener('click', () => {
    const newStartDate = new Date(startDate);
    newStartDate.setDate(startDate.getDate() - 7);

    if (!hasAvailableDays(newStartDate)) {
      showBootstrapAlert('This previous week has no available days and cannot be accessed.', 'info');
      return; // Stop further execution
    }
    if (isChangedWeek()) {
      saveCurrentWeekTimes((shouldSubmit) => {
        if (shouldSubmit) {
          startDate = newStartDate;
          btnSubmitTimes.click(); // Execute the submit button logic if shouldSubmit is true
          handleWeekChange(startDate); // IT NEEDS CHECKING ------------------------------------------->>>>>>> ?????????
        }
        startDate = newStartDate;
        handleWeekChange(newStartDate);
      });
    } else {
      startDate = newStartDate;
      handleWeekChange(newStartDate);
    }
  });
  btnNextWeek.addEventListener('click', async () => {
    const newStartDate = new Date(startDate);
    newStartDate.setDate(startDate.getDate() + 7);

    if (isChangedWeek()) {
      saveCurrentWeekTimes((shouldSubmit) => {
        if (shouldSubmit) {
          startDate = newStartDate;
          btnSubmitTimes.click(); // Execute the submit button logic if shouldSubmit is true
          handleWeekChange(startDate); // IT NEEDS CHECKING ------------------------------------------->>>>>>> ?????????
        }
        startDate = newStartDate;
        handleWeekChange(startDate);
      });
    } else {
      startDate = newStartDate;
      handleWeekChange(startDate);
    }
  });
  btnCurrentWeek.addEventListener('click', () => {
    if (isChangedWeek()) {
      saveCurrentWeekTimes((shouldSubmit) => {
        if (shouldSubmit) {
          startDate = calculateStartDate(today, startDayOfWeek);
          btnSubmitTimes.click(); // Execute the submit button logic if shouldSubmit is true
        }
        startDate = calculateStartDate(today, startDayOfWeek);
        handleWeekChange(startDate);
      });
    } else {
      startDate = calculateStartDate(today, startDayOfWeek);
      handleWeekChange(startDate);
    }
  });
  //---------------------------------- Navigate week Buttons END -----------------------------------------------------

  //---------------------------------- Provider POPUP START ----------------------------------------------------------
  //This function checks if selectedSessions and waitToDeleteTimeSlots are empty or not ????-> change to {allTimeSlot list}
  function isChangedWeek() {
    return (waitToDeleteTimeSlots.length > 0 || newTimeSlots.length > 0);
  }

  function handleWeekChange(startDate) {
    btnFreeWeek.checked = false;
    generateAccordionItems(startDate);
    removeAllTimeSlots();
    showAvailableTimeSlots(startDate);
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


  // This function will show the modal box to get confirmation from user to save the selections or not
  function saveCurrentWeekTimes(callback) {
    // Show the modal dialog
    const modal = new bootstrap.Modal(document.getElementById('confirmWeek'));
    modal.show();
    // Set the current callback
    currentCallback = callback;
    return;
  }

  //---------------------------------- Provider POPUP END ---------------------------------------------------------------------

  function showBootstrapAlert(message, type = 'info') {
    // Create the alert div
    const alertDiv = document.createElement('div');
    alertDiv.classList.add('alert', `alert-${type}`, 'alert-dismissible', 'fade', 'show');
    alertDiv.setAttribute('role', 'alert');

    // Add the message
    alertDiv.innerHTML = `
    ${message}
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
  `;

    // Append the alert to the container
    const alertContainer = document.getElementById('alert-container');
    alertContainer.appendChild(alertDiv);

    // Automatically remove the alert after 5 seconds (optional)
    setTimeout(() => {
      alertDiv.classList.remove('show');
      alertDiv.classList.add('fade');
      setTimeout(() => alertDiv.remove(), 150); // Wait for fade-out animation
    }, 5000);
  }

// ================================================================================================================
// ------------------------------------- DASHBOARD TIME FORMAT HANDLING -------------------------------------------
// ================================================================================================================
  // let currentStartDate = new Date(); // Initialize with the current date


  // Function to generate accordion items
  function generateAccordionItems(startDate) {
    console.log('generateAccordionItems CALLED.');
    accordionContainer.innerHTML = ''; // Clear existing items
    const today = new Date();
    today.setHours(0, 0, 0, 0); // Normalize today's date

    for (let i = 0; i < 7; i++) {
      const currentDate = new Date(startDate);
      currentDate.setDate(startDate.getDate() + i);
      // const date = formatLocalDate(currentDate.toLocaleDateString());
      const date = formatLocalDate(currentDate); // Use a helper function to format the date
      const fullDayName = daysOfWeek[currentDate.getDay()];
      const abbrDay = daysOfWeek[currentDate.getDay()].slice(0, 3).toUpperCase();
      const isPastDate = currentDate < today;
      const isToday = currentDate.toDateString() === today.toDateString();

      const accordionItem = document.createElement('div');
      accordionItem.className = `accordion-item ${isPastDate ? 'disabled-date' : ''} ${isToday ? 'current-date' : ''}`;
      accordionItem.innerHTML = `
                <h6 class="accordion-header font-base" id="heading_${abbrDay}">
                    <button class="accordion-button rounded collapsed" type="button" data-bs-toggle="collapse"
                            data-bs-target="#collapse_${abbrDay}" aria-expanded="false" aria-controls="collapse_${abbrDay}" ${isPastDate ? 'disabled' : ''}>
                        <span class="fw-bold me-3 ${isToday ? 'text-orange' : 'text-primary'}" id="date_${abbrDay}">${date}</span>
                        <span class="fw-bold me-3 ${isToday ? 'text-orange' : ''}">| ${fullDayName}</span>
                    </button>
                </h6>
                <div id="collapse_${abbrDay}" class="accordion-collapse collapse" aria-labelledby="heading_${abbrDay}"
                     data-bs-parent="#AccordionWeekDays">
                    <div class="accordion-body mt-3">
                        <div id="timeSlots_${abbrDay}" class="time-slots-container"></div>
                        <hr>
                        <div class="d-flex justify-content-between align-items-center">
                            <div class="d-flex align-items-center gap-2 h-100">
                                <input type="time" class="form-control form-control-sm h-100" id="startTime_${abbrDay}" ${isPastDate ? 'disabled' : ''}>
                                <span class="fw-bold">-</span>
                                <input type="time" class="form-control form-control-sm h-100" id="endTime_${abbrDay}" ${isPastDate ? 'disabled' : ''}>
                            </div>
                            <div class="d-flex align-items-center gap-2 h-100">
                                <button class="btn btn-sm btn-dark h-100" id="addTime_${abbrDay}" ${isPastDate ? 'disabled' : ''}> 
                                    <i class="bi bi-plus-circle me-2"></i>Add time
                                </button>
                                <button class="btn btn-sm btn-danger h-100" id="clear_${abbrDay}" ${isPastDate ? 'disabled' : ''}>
                                    <i class="bi bi-eraser me-2"></i>Clear ${abbrDay}
                                </button>
                            </div>
                            <div class="form-check form-check-md">
                                <input class="form-check-input" type="checkbox" value="" id="freeDay_${abbrDay}" ${isPastDate ? 'disabled' : ''} >
                                <label class="form-check-label" for="freeDay_${abbrDay}">Free whole ${fullDayName}</label>
                            </div>
                        </div>
                    </div>
                </div>
            `;
      accordionContainer.appendChild(accordionItem);
    }
  }

  // Function to add a NEW time slot
  function addNewTimeSlot(day) {

    const startTime = document.getElementById(`startTime_${day}`).value;
    const endTime = document.getElementById(`endTime_${day}`).value;
    if (!startTime || !endTime) {
      showBootstrapAlert('Please fill in both start and end times.', 'danger');
      return;
    }
    if (!validateTimeRange(startTime, endTime)) {
      return;
    }
    if (isOverlapping(day, startTime, endTime)) {
      showBootstrapAlert(`This time slot overlaps with an existing one. Please choose a different time in ${day}.`, 'danger');
      return;
    }
    // Get the weekday from the button's text content
    const weekDayDate = document.querySelector(`#date_${day}`).textContent.trim();

    // const weekDay = document.querySelector(`#heading_${day} .accordion-button span`).textContent.trim();

    // const weekDayDate = getWeekdayDates(day); // Get the date for the day
    console.log('weekDayDate: ', weekDayDate);
    if (!weekDayDate) {
      console.error(`No date found for ${day}`);
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
          <span class="ms-2 mb-0 h6 fw-light">${weekDayDate}</span>
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
      startTime: `${weekDayDate} ${startTime}`,
      endTime: `${weekDayDate} ${endTime}`,
    };

    newTimeSlots.push(timeSlot);
    console.log('newTimeSlots', newTimeSlots);

    // Clear the input fields
    document.getElementById(`startTime_${day}`).value = '';
    document.getElementById(`endTime_${day}`).value = '';
  }

  function isSameDate(startDate, endDate) {
    return (startDate === endDate);
  }

  // Function to add available time slots to the accordion
  function addAvailableTimeSlot(tsId, day, startDate, endDate, startTime, endTime) {
    if (!startDate) {
      console.error(`No date found for ${day}`);
      return;
    }

    // Create a new time slot
    const existedTimeSlot = document.createElement('div');

    existedTimeSlot.innerHTML = `
      <div class="d-flex justify-content-between align-items-center mb-2">
        <div class="position-relative time-slots">
          <span  class="btn btn-primary btn-round btn-sm mb-0 stretched-link position-static"><i class="fas fa-calendar-check"></i></span>
          <span class="ms-2 mb-0 h6 fw-light">${isSameDate(startDate, endDate) ? `${startDate}` : `<b>${startDate}</b>`}</span>
          <span class="ms-2 mb-0 h6 fw-light">${day}</span>
          <span class="ms-2 mb-0 h6 fw-light">${startTime} - ${endTime} ${isSameDate(startDate, endDate) ? '' : `<b class="text-danger inline">(${endDate})</b>`}</span>
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

  //===============================  Event Delegation START [Very Important]  check line by line FOR MYSELF ???????????????? ?????????????? ==========================================
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

  //=================================== Event Delegation END ===========================================================

  btnFreeWeek.addEventListener('change', () => {
    const isChecked = btnFreeWeek.checked; // Get the state of the "Free Week" checkbox
    console.log('isChecked: ', isChecked);

    daysOfWeek_abbr.forEach(day => {
      const freeDayCheckbox = document.getElementById(`freeDay_${day}`);
      freeDayCheckbox.checked = isChecked; // Update the state of the individual day checkbox
      // Call the `freeDay` function to handle the logic for each day
      freeDay(day, isChecked); // Pass `true` to indicate programmatic call
    });
  });



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
    console.log(`Checkbox state for ${day}:`, freeDay.checked);

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
      const weekDayDate = document.querySelector(`#date_${day}`).textContent.trim();
      const newTimeSlot = document.createElement('div');
      newTimeSlot.innerHTML = `
          <div class="d-flex justify-content-between align-items-center mb-2">
              <div class="position-relative time-slots">
                  <span class="btn btn-primary btn-round btn-sm mb-0 stretched-link position-static"><i class="fas fa-calendar-check"></i></span>
                  <span class="ms-2 mb-0 h6 fw-light">${weekDayDate}</span>
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
        startTime: `${weekDayDate} 00:00`,
        endTime: `${weekDayDate} 24:00`,
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
        // console.log(`Retrieving time slots for ${day}:`, previousTimeSlots[day]); // Debugging line

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

      const date = slot.querySelector('span:nth-child(2)')?.textContent.trim();
      const timeRange = slot.querySelector('span:nth-child(4)')?.textContent.trim();
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
            startTime: `${date} ${startTime}`, // Adjust format as needed
            endTime: `${date} ${endTime}`, // Adjust format as needed
          };
          newTimeSlots.push(timeSlot);
        } else {
          const timeSlot = {
            tsId: parseInt(tsId), // Generate a unique ID if needed
            // tutorId: tutorId, // Tutor ID
            // timezone: userTimezone, // User's timezone
            day: day, // Day of the week
            startTime: `${date} ${startTime}`, // Adjust format as needed
            endTime: `${date} ${endTime}`, // Adjust format as needed
          };
          existedTimeSlots.push(timeSlot);
          waitToDeleteTimeSlots = waitToDeleteTimeSlots.filter(item => item !== tsId);
        }


      } else {
        console.error('ERROR, [startTime, endTime] didnt find! ');
      }
    });

    console.log('Updated newTimeSlots:', newTimeSlots);
    console.log('Updated existedTimeSlots:', existedTimeSlots);
    console.log('Updated waitToDeleteTimeSlots:', waitToDeleteTimeSlots);
  }


  //Remove All Time slots
  function removeAllTimeSlots() {
    console.log('removeAllTimeSlots CALLED.');
    daysOfWeek_abbr.forEach(day => {
      const timeSlotsContainer = document.getElementById(`timeSlots_${day}`);
      timeSlotsContainer.innerText = '';
    });
    clearAllArrays();
  }

  //Clear All Arrays
  function clearAllArrays() {
    newTimeSlots = [];
    existedTimeSlots = [];
    waitToDeleteTimeSlots = [];
    allTimeSlots = [];
    console.log('All arrays cleared!');
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

    console.log('waitToDeleteTimeSlots', waitToDeleteTimeSlots);
    console.log('newTimeSlots', newTimeSlots);
    console.log('RemoveALL-existedTimeSlots', existedTimeSlots);

  }

  // Function to delete a time slot------------------------------------------------------ALMOST DONE BUT DO FINAL CHECK!
  window.deleteTimeSlot = function (button) {
    const timeSlotDiv = button.closest('.d-flex');
    const input = timeSlotDiv.querySelector('input[type="hidden"]');
    if (input) {
      const tsId = input.value; // Get the value of the hidden input
      console.log('Deleting time slot with ID:', tsId);

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

    console.log('newTimeSlots', newTimeSlots);
    console.log('existedTimeSlots-AVR: ', existedTimeSlots);
    console.log('allTimeSlots', allTimeSlots);
    console.log('waitToDeleteTimeSlots', waitToDeleteTimeSlots);
  };

  // Get all newTS and WaitToDelete to submit this skips existed TimeSlots

  // Function to submit time slots via AJAX
  function submitTimes() {
    // AJAX request to submit time slots
    const url = `/schedule/save-available-provider-times/`;
    fetch(url, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRFToken': getCookie('csrftoken'),
      },
      body: JSON.stringify({available_sessions: newTimeSlots, DeletableTimeSlots: waitToDeleteTimeSlots}), // Send TimeSlots array
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
        console.log(data);
        // Call functions after successful submission
        handleWeekChange(startDate); // after successful submission
      })
      .catch(error => console.error('Error:', error));
  }

  // Event listener for submit button
  btnSubmitTimes.addEventListener('click', () => {
    if (newTimeSlots.length > 0 || waitToDeleteTimeSlots.length > 0) {
      console.log('btnSubmitTimes clicked.');
      submitTimes();
    } else {
      console.warn('No valid Time slots to send');
    }
  });

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

  // Initial generation of accordion items
  generateAccordionItems(startDate);
  showAvailableTimeSlots(startDate);

  function validateTimeRange(startTime, endTime) {
    // Check if minutes are 00 or 30
    const isValidMinutes = (time) => {
      const minutes = time.split(':')[1];
      return minutes === '00' || minutes === '30';
    };

    if (!isValidMinutes(startTime) || !isValidMinutes(endTime)) {
      showBootstrapAlert('Please enter times with minutes rounded to 00 or 30 (e.g., 10:00, 10:30).', 'danger');
      return false;
    }

    // Special case: 24:00 is 00:00 (next day)
    if (endTime === '00:00') {
      return true;
    }

    // Check if endTime is after startTime
    if (startTime >= endTime) {
      showBootstrapAlert('End time must be after start time.', 'danger');
      return false;
    }

    return true;
  }

  // Function to display available time slots in the accordion
  async function showAvailableTimeSlots(startDate) {
    console.log('showAvailableTimeSlots CALLED.');
    const url = `/schedule/get-availability/?providerUId=${providerUId}&startDate=${startDate.toISOString().split('T')[0]}`;
    try {
      const response = await fetch(url);
      if (!response.ok) throw new Error('Failed to fetch availability data');
      const data = await response.json();

      const dateDayMap = {};

      // Create a dictionary to map dates to days of the week
      daysOfWeek_abbr.forEach(day => {
        const dateString = document.querySelector(`#date_${day}`).textContent.trim();
        const date = new Date(dateString);
        const localDate = new Date(date.getTime() - (date.getTimezoneOffset() * 60000)).toISOString().split('T')[0];

        dateDayMap[localDate] = day;
        // console.log('dateDayMap[localDate] = day: ', localDate, day);
      });

      // Highlight available cells and add them to the accordion
      data.availability.forEach(availability => {
        const availId = availability.availId;
        // const tutorTimezone = availability.tutor_timezone;
        // console.log('tutorTimezone', tutorTimezone);

        const startTimeUTC = availability.start_time_utc;
        const endTimeUTC = availability.end_time_utc;

        // Convert UTC times to the provider's time zone
        const startTime = new Date(convertUTCToLocal(startTimeUTC, userTimezone));
        const endTime = new Date(convertUTCToLocal(endTimeUTC, userTimezone));

        // Extract date and time in the desired format (using local time zone)
        const startDate = formatLocalDate(startTime); // Use a helper function to format the date
        const endDate = formatLocalDate(endTime); // Use a helper function to format the date

        const startTimeFormatted = formatLocalTime(startTime); // HH:MM
        const endTimeFormatted = formatLocalTime(endTime); // HH:MM

        const day = dateDayMap[startDate];

        if (day) {
          addAvailableTimeSlot(availId, day, startDate, endDate, startTimeFormatted, endTimeFormatted);
        }

        const availTimeSlot = {
          tsId: availId,
          day: day,
          start: startTime,
          end: endTime,
        };
        existedTimeSlots.push(availTimeSlot);
      });


      console.log('existedTimeSlots: ', existedTimeSlots);
    } catch (error) {
      console.error('Error fetching availability:', error);
    }
  }

  // Helper function to format the date in local time zone (YYYY-MM-DD)
  function formatLocalDate(date) {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0'); // Months are 0-indexed
    const day = String(date.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
  }

// Helper function to format the time in local time zone (HH:MM)
  function formatLocalTime(date) {
    const hours = String(date.getHours()).padStart(2, '0');
    const minutes = String(date.getMinutes()).padStart(2, '0');
    return `${hours}:${minutes}`;
  }

  function isOverlapping(day, newStart, newEnd) {
    const timeSlotsContainer = document.getElementById(`timeSlots_${day}`);
    const timeSlots = Array.from(timeSlotsContainer.children);
    // console.log('timeSlots length: ', timeSlots.length);

    for (const slot of timeSlots) {
      const timeRange = slot.querySelector('span:nth-child(4)')?.textContent.trim();
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
        console.log('timeRange is undefined!');
      }
    }

    return false; // No overlapping
  }

  // --------------------------------------------- toggle switches START ---------------------------------------------
  // Add event listeners to all toggle switches
  document.querySelectorAll('.toggle-day').forEach(switchElement => {
    switchElement.addEventListener('change', function () {
      const day = this.dataset.day; // Get the day (e.g., SAT, SUN, etc.)
      const timeSlotsContainer = document.getElementById(`timeSlots_${day}`);
      const isDisabled = !this.checked; // Check if the switch is toggled off

      // Toggle the disabled class for all time slots
      Array.from(timeSlotsContainer.children).forEach(slot => {
        slot.classList.toggle('text-secondary', isDisabled);
      });

      // Remove or add time slots from allTimeSlots array
      updateAllTimeSlots(day, isDisabled);
    });
  });

  // Function to update allTimeSlots array
  function updateAllTimeSlots(day, isDisabled) {
    const timeSlotsContainer = document.getElementById(`timeSlots_${day}`);
    const timeSlots = Array.from(timeSlotsContainer.children);

    if (isDisabled) {
      // Remove time slots for this day from allTimeSlots
      allTimeSlots = allTimeSlots.filter(slot => slot.weekDay !== day);
    } else {
      // Add time slots for this day back to allTimeSlots
      timeSlots.forEach(slot => {
        const weekDay = slot.querySelector('span:nth-child(2)')?.textContent.trim();
        const weekDayDate = slot.querySelector('span:nth-child(3)')?.textContent.trim();
        const skill = slot.querySelector('span:nth-child(4)')?.textContent.trim();
        const timeRange = slot.querySelector('span:nth-child(5)')?.textContent.trim();
        if (timeRange) {
          const [startTime, endTime] = timeRange.split(' - ');

          if (weekDay && skill && startTime && endTime) {
            allTimeSlots.push({weekDay, weekDayDate, skill, startTime, endTime});
          }
        } else {
          console.log('timeRange is undefined!');
        }
      });
    }
  }

  // --------------------------------------------- toggle switches END -----------------------------------------------


  //-------------------------------
  // Get all TimeSlots
  function getTimeSlots() {
    daysOfWeek_abbr.forEach(day => {
      const timeSlotsContainer = document.getElementById(`timeSlots_${day}`);
      const isFree = document.getElementById(`freeDay_${day}`).checked;
      const timeSlots = Array.from(timeSlotsContainer.children);

      if (isFree) {
        // Remove time slots for this day from allTimeSlots
        // allTimeSlots = allTimeSlots.filter(slot => slot.weekDay !== day);
        console.log(`${day} is free!`);
      } else {
        // Add time slots for this day back to allTimeSlots
        timeSlots.forEach(slot => {
          const weekDayDate = slot.querySelector('span:nth-child(2)')?.textContent.trim();
          // const weekDay = slot.querySelector('span:nth-child(3)')?.textContent.trim();
          // const skill = slot.querySelector('span:nth-child(4)')?.textContent.trim();
          const timeRange = slot.querySelector('span:nth-child(4)')?.textContent.trim();
          // console.log('slot: ', slot);
          // console.log('timeRange: ', timeRange);
          if (timeRange) {
            let [startTime, endTime] = timeRange.split(' - ');
            if (endTime.length > 5) {
              endTime = endTime.substring(0, 5); // get HH:MM which has 5 chars
            }

            let tsId;
            const input = slot.querySelector('input[type="hidden"]');
            if (input) {
              tsId = input.value; // Get the value of the hidden input
              console.log('tsId: ', tsId);
            }

            // if (input && !input.value.startsWith('newTS_')) {
            //   tsId = input.value; // Get the value of the hidden input
            // } else {
            //   tsId = 'new';
            // }

            if (weekDayDate && startTime && endTime) {
              // Add the slot to allTimeSlots
              const timeSlot = {
                tsId: tsId, // TimeSlot ID
                providerUId: providerUId, // Tutor ID -> Provider User ID
                timezone: userTimezone, // User's timezone
                day: day,
                startTime: `${weekDayDate} ${startTime}`,
                endTime: `${weekDayDate} ${endTime}`,
              };
              allTimeSlots.push(timeSlot);
            }
          } else {
            console.log('timeRange is undefined!');
          }
        });
      }
    });
    console.log('allTimeSlots: ', allTimeSlots);
    return allTimeSlots;
  }

  function getWeekdayDates(day) {
    const foundDate = weekDayDates.find(wdD => wdD.split(' ')[0] === day);
    return foundDate ? foundDate.split(' ')[1] : null; // Return the date part (YYYY-MM-DD)
  }

  function getAllTimeSlots() {
    const allTimeSlots = [];
    const daysOfWeek = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];

    daysOfWeek.forEach(day => {
      const timeSlotsContainer = document.getElementById(`timeSlots_${day}`);
      if (timeSlotsContainer) {
        const timeSlotElements = timeSlotsContainer.querySelectorAll('.time-slots'); // Target the time slot elements
        timeSlotElements.forEach(slot => {
          const timeRange = slot.querySelector('span:nth-child(4)').textContent.trim(); // Get the time range (e.g., "10:00 - 12:00")
          if (timeRange) {
            const [startTime, endTime] = timeRange.split(' - '); // Split the time range into start and end times

            allTimeSlots.push({
              day: day,
              startTime: startTime,
              endTime: endTime,
              isFree: false // You can modify this if you have a way to check if the slot is marked as free
            });
          } else {
            console.log('timeRange is undefined!');
          }
        });
      }
    });

    return allTimeSlots;
  }

  // Function to format date and time in the desired format (e.g., 28-02-2025 06:00)
  function formatDateTime(dateTimeStr) {
    const date = new Date(dateTimeStr);
    const day = String(date.getDate()).padStart(2, '0');
    const month = String(date.getMonth() + 1).padStart(2, '0'); // Months are zero-based
    const year = date.getFullYear();
    const hours = String(date.getHours()).padStart(2, '0');
    const minutes = String(date.getMinutes()).padStart(2, '0');
    return `${day}-${month}-${year} ${hours}:${minutes}`;
  }

  // Add event listeners for each day's "Add Time" button
  // const addTimeButtons = {
  //   SUN: document.getElementById('addTime_SUN'),
  //   MON: document.getElementById('addTime_MON'),
  //   TUE: document.getElementById('addTime_TUE'),
  //   WED: document.getElementById('addTime_WED'),
  //   THU: document.getElementById('addTime_THU'),
  //   FRI: document.getElementById('addTime_FRI'),
  //   SAT: document.getElementById('addTime_SAT'),
  // };
  //Get date for Provider (table Header with Radio button)
  function getDate(cell) {
    const headerCell = tableHead.cells[cell.cellIndex];
    const dateText = headerCell.querySelector('br').nextSibling.textContent;// Get date from header
    // console.log('dateText type: ', typeof (dateText));
    return dateText;
  }

  function getTime(cell) {
    const time = cell.parentElement.cells[0].innerText; // Get time from the first cell in the row
    return `${time}`; // time
  }

  // Helper function to check if a date is today
  function isToday(date) {
    const today = new Date();
    return date.getDate() === today.getDate() &&
      date.getMonth() === today.getMonth() &&
      date.getFullYear() === today.getFullYear();
  }

  //-------------------------------
});