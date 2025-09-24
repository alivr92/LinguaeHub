// MAIN SCRIPT FOR USER SIDE TABLE
document.addEventListener('DOMContentLoaded', async () => {
  const tableHead = document.querySelector('#schedule-table thead tr');
  const tableBody = document.querySelector('#schedule-table tbody');
  const daysOfWeek = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
  const daysOfWeek2 = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];

  const submitButton = document.getElementById('submit-button');
  const clearButton = document.getElementById('clear-button');
  const tutorId = document.getElementById('tutor_id').value;
  let weekDayDates = [];
  let selectedCells = [];
  let selectedSessions = [];
  let existedTimeSlots = []; // Available free times of tutor
  let waitToDeleteTimeSlots = [];
  let sessionLength = 2; // set a default sessionLength (1=30 min,  2=60 min, 3=90 min , 4=120 min, 6=180 min)
  let startDayOfWeek; // Initialize with the current value
  let userTimezone;
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
      userTimezone = data.provider_timezone;
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

  //--------------------------------------------- Session Length Listener START -----------------------------------------------
  // const sessionObj = document.getElementById('sessionLength');
  // sessionObj.addEventListener('change', () => {
  //   sessionLength = parseInt(sessionObj.value);
  //   console.log('sessionLength: ', sessionLength);
  // });
  //--------------------------------------------- Session Length END -------------------------------------------------


  //------------------------------------------- TIMEZONE START -------------------------------------------------------

  function autoDetectTimezone() {
    const timezoneSelect = document.getElementById('timezone-select'); // Time zone dropdown
    const timeZones = Intl.supportedValuesOf('timeZone');
    timeZones.forEach(zone => {
      const option = document.createElement('option');
      option.value = zone;
      option.text = zone;
      timezoneSelect.appendChild(option);
    });

    // Default to user's system time zone (in Dashboard must get the tutor's timezone)
    let autoUserTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;

    // Set the dropdown to the user's system time zone if it exists in the options
    const timezoneOptions = Array.from(timezoneSelect.options).map(option => option.value);
    if (timezoneOptions.includes(autoUserTimezone)) {
      timezoneSelect.value = autoUserTimezone;
    }
  }

  // Event listener for time zone changes
  // timezoneSelect.addEventListener('change', () => {
  //   userTimezone = timezoneSelect.value;
  //   generateTableHeader(startDate);
  //   generateTableBody();
  //   showBootstrapAlert(`Note: Calendar is showing based on ${userTimezone} time zone.`, 'primary');
  // });

  // Helper function to convert UTC time to local time
  function convertUTCToLocal(utcTime, timezone) {
    const utcDate = new Date(utcTime);
    const localTime = utcDate.toLocaleString('en-US', {timeZone: timezone});
    return new Date(localTime);
  }

  //------------------------------------------- TIMEZONE END ---------------------------------------------------------

  //--------------------------------- Date & Time (Provider) START ---------------------------------------------------
  //---------- Initialize table with current week START ------------
  // const startDayOfWeekObj = document.getElementById('startDayOfWeek');
  // let startDayOfWeek = parseInt(startDayOfWeekObj.value); // Initialize with the current value

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

  // Event listener for when the user changes the start day of the week
  // startDayOfWeekObj.addEventListener('change', () => {
  //   startDayOfWeek = parseInt(startDayOfWeekObj.value);
  //   console.log('startDayOfWeek: ', startDayOfWeek);
  //   startDate = calculateStartDate(today, startDayOfWeek);
  //   generateTableHeader(startDate);
  //   generateTableBody();
  // });

  // Helper function to check if a date is today
  function isToday(date) {
    const today = new Date();
    return date.getDate() === today.getDate() &&
      date.getMonth() === today.getMonth() &&
      date.getFullYear() === today.getFullYear();
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

  function getDate1(cell) {
    const date = tableHead.cells[cell.cellIndex].innerText.split(' ')[1]; // Get date from header
    return `${date}`; // date
  }

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

  // Generate the time slots -- we have 48 time slots for 24 hours --------------------[CHECKED]--------------------
  function generateTimeSlots() {
    const times = [];
    for (let hour = 0; hour < 24; hour++) {
      for (let minute = 0; minute < 60; minute += 30) {
        const startTime = `${hour.toString().padStart(2, '0')}:${minute.toString().padStart(2, '0')}`;
        const endMinute = (minute + 30) % 60;
        const endHour = minute + 30 >= 60 ? hour + 1 : hour;
        const endTime = `${endHour.toString().padStart(2, '0')}:${endMinute.toString().padStart(2, '0')}`;
        times.push(`${startTime} - ${endTime}`);
      }
    }
    return times;
  }

  //--------------------------------- Date & Time (Provider) END -----------------------------------------------------

  // Generate week days and the related dates of each day based on the current selected week ===CHECK LATER ??????????
  function generateWeekdayDates(startDate) {
    weekDayDates = []; // Clear the array
    for (let i = 0; i < 7; i++) {
      const currentDate = new Date(startDate);
      currentDate.setDate(startDate.getDate() + i);
      weekDayDates.push(`${daysOfWeek2[currentDate.getDay()]} ${currentDate.toLocaleDateString('en-US', {timeZone: userTimezone})}`);
    }
    console.log('weekDayDates: ', weekDayDates);
  }

  generateWeekdayDates(startDate);
  updateAccordionDate(startDate);
  generateTableHeader(startDate);
  generateTableBody();

  function updateAccordionDate(startDate) {

    for (let i = 0; i < 7; i++) {
      const currentDate = new Date(startDate);
      currentDate.setDate(startDate.getDate() + i);

      // Format the date as YYYY-MM-DD
      // const formattedDate = currentDate.toLocaleDateString('en-US', {timeZone: timezoneSelect.value});
      const formattedDate = currentDate.toLocaleDateString('en-US', {timeZone: userTimezone});

      // Update the date span for the corresponding day
      const dateSpan = document.getElementById(`date_${daysOfWeek2[i]}`);
      if (dateSpan) {
        dateSpan.textContent = formattedDate;
      }
    }
  }

  function toggleColumnClass(dayIndex) {
    // Get all rows in the table
    const rows = tableBody.getElementsByTagName('tr');

    // Iterate through each row and toggle the class for the cell in the corresponding column
    for (let row of rows) {
      const cell = row.children[dayIndex + 1]; // +1 to account for the row header if it exists
      if (cell) {
        cell.classList.toggle('inactiveDay');
      }
    }
  }

  // Generate table header with dates (to use the selected time zone)
  function generateTableHeader(startDate) {
    while (tableHead.children.length > 1) {
      tableHead.removeChild(tableHead.lastChild);
    }
    for (let i = 0; i < 7; i++) {
      const currentDate = new Date(startDate);
      currentDate.setDate(startDate.getDate() + i);

      const th = document.createElement('th');
      // th.innerText = `${daysOfWeek[currentDate.getDay()]} ${currentDate.toLocaleDateString('en-US', {timeZone: userTimezone})}`;
      const switchId = `flexSwitch_${daysOfWeek[currentDate.getDay()]}`;
      th.innerHTML = `
      <div class="form-check form-switch">
        <input class="form-check-input" type="checkbox" id="${switchId}" checked>
      </div>
      ${daysOfWeek[currentDate.getDay()]}<br>${currentDate.toLocaleDateString('en-US', {timeZone: userTimezone})}`;


      th.style.height = '2px';
      th.style.textAlign = 'center';
      th.style.padding = '2px';
      if (isToday(currentDate)) {
        th.classList.add('current-date');
      }

      // Add event listener for the switch button
      const switchElement = th.querySelector(`#${switchId}`);
      switchElement.addEventListener('change', () => toggleColumnClass(i));


      tableHead.appendChild(th);
    }
  }

  // Generate table body with time slots
  function generateTableBody() {
    tableBody.innerHTML = '';
    const times = generateTimeSlots();
    // Convert startDate to the selected time zone
    const localStartDate = convertUTCToLocal(startDate, userTimezone);

    times.forEach(time => {
      const tr = document.createElement('tr');

      // Add time slot in front of each row
      const timeCell = document.createElement('td');
      timeCell.innerText = time;
      timeCell.style.height = '4px';
      timeCell.style.textAlign = 'center';
      timeCell.style.padding = '2px';
      tr.appendChild(timeCell);

      for (let i = 0; i < 7; i++) {
        const td = document.createElement('td');
        td.style.height = '4px';

        const currentDate = new Date(localStartDate);
        currentDate.setDate(localStartDate.getDate() + i);

        if (isBeforeToday(currentDate)) {
          td.classList.add('disabled-cell');
          td.style.pointerEvents = 'none';
        } else {
          td.addEventListener('click', handleClick);
          td.addEventListener('click', handleAvailableClick); //for deselect or delete available times in db
          td.addEventListener('mouseover', handleMouseOver);
          td.addEventListener('mouseout', handleMouseOut);

          //---------------------------------------------------------------------- Bootstrap TOOLTIP START
          const weekDayDate = tableHead.cells[i + 1].innerText.split(' ')[0]; // Adjust index if needed
          // const day = weekDayDate.split(' ')[0];
          // const date = weekDayDate.split('<br>')[1];
          // const date = tableHead.cells[i + 1].innerText.split(' ')[1]; // Adjust index if needed
          const timeStart = time.split(' - ')[0];
          // let timeEnd = time.split(' - ')[1]
          let timeEnd;
          // Convert timeEnd to a Date object
          timeEnd = addMinutesToTime(timeStart, sessionLength);

          // const title = `${weekDay} ${time}`;
          const title = `${weekDayDate}, ${timeStart}`;
          // Add Bootstrap tooltip attributes
          td.setAttribute('data-bs-toggle', 'tooltip');
          td.setAttribute('data-bs-placement', 'top');  // top, right, bottom, left
          td.setAttribute('title', title);
          //---------------------------------------------------------------------- Bootstrap TOOLTIP END
        }

        tr.appendChild(td);
      }
      tableBody.appendChild(tr);
    });

    //---------- TOOLTIP Helper function for calculate the end time of session (based on sessionLength )-----------------
    function addMinutesToTime(timeEnd, sessionLength) {
      // Step 1: Convert timeEnd (string) to a Date object
      const [hours, minutes] = timeEnd.split(':').map(Number); // Split "04:30" into hours and minutes
      const date = new Date();
      date.setHours(hours, minutes, 0, 0); // Set the time to the given hours and minutes

      // Step 2: Add sessionLength * 30 minutes to the time
      date.setMinutes(date.getMinutes() + sessionLength * 30);

      // Step 3: Format the new time back into HH:MM
      const newHours = String(date.getHours()).padStart(2, '0'); // Ensure two digits for hours
      const newMinutes = String(date.getMinutes()).padStart(2, '0'); // Ensure two digits for minutes
      const newTimeEnd = `${newHours}:${newMinutes}`;

      return newTimeEnd;
    }
    //--------------------------------------- Initialize Bootstrap TOOLTIP START---------------------------------
    // Initialize Bootstrap tooltips for dynamically added elements
    const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]');
    const tooltipList = [...tooltipTriggerList].map(tooltipTriggerEl => new bootstrap.Tooltip(tooltipTriggerEl));
    //--------------------------------------- Initialize Bootstrap TOOLTIP END ----------------------------------

    // Show available times after generating the table, then show the booked sessions
    showAvailableTimesInDashboard(localStartDate);
    showBookedTimes(localStartDate);
    // showSelectedSessions(localStartDate);
  }


  //---------------------------------- Navigate week Buttons START ---------------------------------------------------
  const prevWeekButton = document.getElementById('prev-week').addEventListener('click', () => {
    const newStartDate = new Date(startDate);
    newStartDate.setDate(startDate.getDate() - 7);
    startDate = newStartDate;

    if (!hasAvailableDays(newStartDate)) {
      showBootstrapAlert('This previous week has no available days and cannot be accessed.', 'info');
      return; // Stop further execution
    }
    if (isChangedWeek()) {
      saveCurrentWeekTimes((shouldSubmit) => {
        if (shouldSubmit) {
          submitButton.click(); // Execute the submit button logic if shouldSubmit is true
        }
        handleWeekChange(newStartDate);
      });
    } else {
      handleWeekChange(newStartDate);
    }
  });
  const nextWeekButton = document.getElementById('next-week').addEventListener('click', async () => {
    const nextWeekStartDate = new Date(startDate);
    nextWeekStartDate.setDate(startDate.getDate() + 7);
    startDate = nextWeekStartDate;
    if (isChangedWeek()) {
      saveCurrentWeekTimes((shouldSubmit) => {
        if (shouldSubmit) {
          submitButton.click(); // Execute the submit button logic if shouldSubmit is true
        }
        handleWeekChange(startDate);
      });
    } else {
      handleWeekChange(startDate);
    }
  });
  const currentWeekButton = document.getElementById('current-week').addEventListener('click', () => {
    startDate = calculateStartDate(today, startDayOfWeek);
    if (isChangedWeek()) {
      saveCurrentWeekTimes((shouldSubmit) => {
        if (shouldSubmit) {
          submitButton.click(); // Execute the submit button logic if shouldSubmit is true
        }
        handleWeekChange(startDate);
      });
    } else {
      handleWeekChange(startDate);
    }
  });
  //---------------------------------- Navigate week Buttons END -----------------------------------------------------

  //---------------------------------- Provider POPUP START ----------------------------------------------------------
  //This function checks if selectedSessions and waitToDeleteTimeSlots are empty or not
  function isChangedWeek() {
    return (waitToDeleteTimeSlots.length > 0 || selectedSessions.length > 0);
  }

  function handleWeekChange(startDate) {
    generateWeekdayDates(startDate);
    updateAccordionDate(startDate);
    generateTableHeader(startDate);
    clearButton.click();
    generateTableBody();
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

  async function checkAvailability(startDate) {
    const url = `/schedule/get-availability/?tutorId=${tutorId}&startDate=${startDate.toISOString().split('T')[0]}`;
    try {
      const response = await fetch(url);
      if (!response.ok) {
        throw new Error('Failed to fetch availability data');
      }
      const data = await response.json();
      console.log('Fetched availability data for next week:', data);

      // Check if there is any availability
      return data.availability.length > 0;
    } catch (error) {
      console.error('Error fetching availability:', error);
      return false;
    }
  }

  // Event handlers for cell selection and highlighting
  function handleClick(event) {
    const cell = event.target;
    if (cell.classList.contains('disabled') || cell.classList.contains('booked') || cell.classList.contains('booked-start') ||
      cell.classList.contains('booked-end') ||
      cell.classList.contains('tutor-available-cell') ||
      cell.classList.contains('tutor-available-cell-start') ||
      cell.classList.contains('tutor-available-cell-end')) {
      return; // Only allow selection for free times, NOT booked and NOT disabled and NOT tutor-available cells
    }
    const rowIndex = cell.parentElement.rowIndex - 1; // Get row index
    const cellIndex = cell.cellIndex; // Get column index

    // Check if the clicked cell belongs to any session in selectedSessions
    const sessionIndex = selectedSessions.findIndex(session => session.cells.includes(cell));

    if (sessionIndex !== -1) {
      // If the cell belongs to a session, deselect all cells in that session
      const session = selectedSessions[sessionIndex];
      session.cells.forEach(cell => {
        cell.classList.remove('selectedByTutor');
      });

      // Remove the session from selectedSessions
      selectedSessions.splice(sessionIndex, 1);
    } else {
      // If the cell does not belong to any session, get continuous cells for the selected period/session
      const continuousCells = getContinuousCells(rowIndex, cellIndex, sessionLength, true);
      // Check if the number of continuous cells matches the sessionLength
      if (continuousCells.length === sessionLength) {
        // Check if any of the continuous cells are already part of another session
        const isOverlapping = continuousCells.some(cell =>
          selectedSessions.some(session => session.cells.includes(cell))
        );
        // Check if any of the continuous cells is already part of existed(Available) sessions
        const isOverlappingWithAvailable = continuousCells.some(cell =>
          existedTimeSlots.some(session => session.cells.includes(cell))
        );

        if (!isOverlapping && !isOverlappingWithAvailable) {
          // Select all cells in the group
          continuousCells.forEach(cell => {
            cell.classList.add('selectedByTutor');
          });

          // Find the date and the FLOOR of time for the FIRST cell of each session
          const startDate = getDate(continuousCells[0]);
          const startTimeFloor = getTime(continuousCells[0]).split(' - ')[0]; // Start time of the first cell
          const startDateTime = `${startDate} ${startTimeFloor}`;

          // Find the date and the CEIL of time for the LAST cell of each session
          const endDate = getDate(continuousCells[continuousCells.length - 1]);
          const endTimeCeil = getTime(continuousCells[continuousCells.length - 1]).split(' - ')[1]; // End time of the last cell
          const endDateTime = `${endDate} ${endTimeCeil}`;

          // Add the session to selectedSessions
          const session = {
            id: 'new',
            cells: continuousCells,
            start: startDateTime,
            end: endDateTime,
          };
          selectedSessions.push(session);
        } else {
          console.warn('Overlapping session detected. Selection blocked.');
        }
      }
    }

    console.log('Selected Sessions:', selectedSessions);
  }

  //This Listener handles the available cells to deselect on table and get the related session ids to delete in db
  function handleAvailableClick(event) {
    const cell = event.target;
    if (cell.classList.contains('tutor-available-cell')
      || cell.classList.contains('tutor-available-cell-start')
      || cell.classList.contains('tutor-available-cell-end')) {
      //  do action for available times which comes from db

      // Check if the clicked cell belongs to any session in selectedSessions
      const timeSlotIndex = existedTimeSlots.findIndex(existedTS => existedTS.cells.includes(cell));

      if (timeSlotIndex !== -1) {
        // If the cell belongs to a timeSlot, deselect all cells in that timeSlot
        const timeSlot = existedTimeSlots[timeSlotIndex];
        timeSlot.cells.forEach(cell => {
          cell.classList.remove('tutor-available-cell');
          cell.classList.remove('tutor-available-cell-start');
          cell.classList.remove('tutor-available-cell-end');
        });

        // Remove the timeSlot from existedTimeSlots
        existedTimeSlots.splice(timeSlotIndex, 1);
        //Add the timeSlot id to a waiting list to delete from db by click on submit button
        waitToDeleteTimeSlots.push(timeSlot.id);
        console.log('waitToDeleteTimeSlots: ', waitToDeleteTimeSlots);
      }
      console.log('existed TimeSlots:', existedTimeSlots);
    } else {
      return;
    }
  }

  function handleMouseOver(event) {
    const cell = event.target;
    const rowIndex = cell.parentElement.rowIndex - 1;
    const cellIndex = cell.cellIndex;
    const continuousCells = getContinuousCells(rowIndex, cellIndex, sessionLength, false);

    // Add tooltip -- BASIC TOOLTIP -------------------------------------------------------[CHECKED]
    const date = tableHead.cells[cellIndex].innerText.split(' ')[1];
    const time = cell.parentElement.cells[0].innerText;
    // cell.title = `${date} ${time}`;
    // Add tooltip -- BASIC TOOLTIP End ------------------------------------------------------------

    if (continuousCells.length === sessionLength) {
      continuousCells.forEach(cell => cell.classList.add('highlight'));
    }
  }

  function handleMouseOut(event) {
    const highlightedCells = document.querySelectorAll('.highlight');
    highlightedCells.forEach(cell => cell.classList.remove('highlight'));
  }

  function getContinuousCells(startRowIndex, startCellIndex, sessionLength, allowSelected) {
    const continuousCells = [];
    const rows = tableBody.getElementsByTagName('tr');

    for (let i = 0; i < sessionLength; i++) {
      const currentRow = rows[startRowIndex + i];
      if (currentRow) {
        // we get the column number as startCellIndex
        const currentCell = currentRow.cells[startCellIndex];
        if (currentCell && (!currentCell.classList.contains('selected') || allowSelected) && !currentCell.classList.contains('disabled') && !currentCell.classList.contains('tutor-available-cell')) {
          continuousCells.push(currentCell);
        } else {
          return [];
        }
      } else {
        return [];
      }
    }
    return continuousCells;
  }

  // Clear selected cells
  clearButton.addEventListener('click', () => {
    clearSelectedSessions();
    clearExistedTimeSlots();
  });

  function clearSelectedSessions() {
    const selected = tableBody.querySelectorAll('.selectedByTutor');
    selected.forEach(cell => cell.classList.remove('selectedByTutor'));
    selectedCells = []; // Reset the array
    selectedSessions = []; // Reset the array
    console.log('selectedSessions: ', selectedSessions)
  }

  function clearExistedTimeSlots() {
    existedTimeSlots = [];
    waitToDeleteTimeSlots = [];
    console.log('existedTimeSlots: ', existedTimeSlots)
    console.log('waitToDeleteTimeSlots: ', waitToDeleteTimeSlots)
  }

  // In DASHBOARD we assign all available as default selected sessions (to be able edit or deselect them in the future!)
  async function showAvailableTimesInDashboard(startDate) {
    const url = `/schedule/get-availability/?tutorId=${tutorId}&startDate=${startDate.toISOString().split('T')[0]}`;
    try {
      const response = await fetch(url);
      if (!response.ok) throw new Error('Failed to fetch availability data');
      const data = await response.json();

      // clear exitedTimeSlots
      clearExistedTimeSlots();
      // Clear previous highlights
      const highlightedCells = document.querySelectorAll('.tutor-available-cell, .tutor-available-cell-start, .tutor-available-cell-end');
      highlightedCells.forEach(cell => cell.classList.remove('tutor-available-cell, .tutor-available-cell-start, .tutor-available-cell-end'));

      // Highlight available cells
      data.availability.forEach(availability => {
          const availId = availability.availId;
          const startTimeUTC = availability.start_time_utc;
          const endTimeUTC = availability.end_time_utc;
          const availCells = [];

          // Convert UTC times to the tutor's time zone
          const startTime = new Date(convertUTCToLocal(startTimeUTC, userTimezone));
          const endTime = new Date(convertUTCToLocal(endTimeUTC, userTimezone));

          // Find and highlight corresponding cells
          const rows = tableBody.getElementsByTagName('tr');
          for (let i = 0; i < rows.length; i++) {
            const row = rows[i];
            const timeCell = row.cells[0];
            const rowTime = timeCell.innerText;
            for (let j = 1; j < row.cells.length; j++) { // Start from 1 to skip the time column
              const cell = row.cells[j];
              const rowDate = new Date(startDate);
              rowDate.setDate(startDate.getDate() + (j - 1)); // Adjust date for each day
              rowDate.setHours(parseInt(rowTime.split(':')[0]), parseInt(rowTime.split(':')[1]), 0, 0);


              // Check if the row time falls within the availability range
              if (rowDate >= startTime && rowDate < endTime) {
                if (cell && !cell.classList.contains('disabled-cell') && !cell.classList.contains('booked') && !cell.classList.contains('booked-start') && !cell.classList.contains('booked-end')) {
                  if (rowDate.getTime() === startTime.getTime()) {
                    cell.classList.add('tutor-available-cell-start');
                    availCells.push(cell);
                  } else if (rowDate.getTime() === (endTime.getTime() - 30 * 60 * 1000)) { // 30 minutes before endTime
                    cell.classList.add('tutor-available-cell-end');
                    availCells.push(cell);
                  } else {
                    cell.classList.add('tutor-available-cell');
                    availCells.push(cell);
                  }
                }
              }
            }
          }

          const availSession = {
            id: availId,
            cells: availCells,
            start: startTime,
            end: endTime,
          };
          existedTimeSlots.push(availSession);
        }
      );
      console.log('existedTimeSlots: ', existedTimeSlots);
    } catch (error) {
      console.error('Error fetching availability:', error);
    }
  }

  async function showBookedTimes(startDate) {
    const url = `/schedule/get-booked/?tutorId=${tutorId}&startDate=${startDate.toISOString().split('T')[0]}`;
    try {
      const response = await fetch(url);
      if (!response.ok) throw new Error('Failed to fetch booked sessions data');
      const data = await response.json();

      // Clear previous highlights
      const highlightedCells = document.querySelectorAll('.booked, .booked-start, .booked-end');
      highlightedCells.forEach(cell => cell.classList.remove('booked, .booked-start, .booked-end'));

      // Highlight booked cells
      data.booked_sessions.forEach(booked => {
          const startTimeUTC = booked.start_session_utc;
          const endTimeUTC = booked.end_session_utc;
          // const status = booked.status;

          // Convert UTC times to the student's time zone
          const startTime = new Date(convertUTCToLocal(startTimeUTC, userTimezone));
          const endTime = new Date(convertUTCToLocal(endTimeUTC, userTimezone));

          // Find and highlight corresponding cells
          const rows = tableBody.getElementsByTagName('tr');
          for (let i = 0; i < rows.length; i++) {
            const row = rows[i];
            const timeCell = row.cells[0];
            const rowTime = timeCell.innerText;
            for (let j = 1; j < row.cells.length; j++) { // Start from 1 to skip the time column
              const cell = row.cells[j];
              const rowDate = new Date(startDate);
              rowDate.setDate(startDate.getDate() + (j - 1)); // Adjust date for each day
              rowDate.setHours(parseInt(rowTime.split(':')[0]), parseInt(rowTime.split(':')[1]), 0, 0);

              // Check if the row time falls within the availability range
              if (rowDate >= startTime && rowDate < endTime) {
                if (cell && !cell.classList.contains('disabled-cell')) {
                  if (rowDate.getTime() === startTime.getTime()) {
                    cell.classList.remove('tutor-available-cell'); // for cells which they are not at START but booked
                    cell.classList.remove('tutor-available-cell-start');
                    cell.classList.add('booked-start');
                    cell.style.pointerEvents = 'none';
                    // } else if (rowDate.getTime() === (endTime.getTime())) {
                  } else if (rowDate.getTime() === (endTime.getTime() - 30 * 60 * 1000)) { // 30 minutes before endTime
                    cell.classList.remove('tutor-available-cell');// for cells which they are not at END but booked
                    cell.classList.remove('tutor-available-cell-end');
                    cell.classList.add('booked-end');
                    cell.style.pointerEvents = 'none';
                  } else {
                    cell.classList.remove('tutor-available-cell');
                    cell.classList.add('booked');
                    cell.style.pointerEvents = 'none';
                  }
                }
              }
            }
          }
        }
      );
    } catch (error) {
      console.error('Error fetching availability:', error);
    }
  }

  // In Dashboard Selected sessions will send to availabilities of Tutor
  submitButton.addEventListener('click', () => {
    const available_sessions = selectedSessions.map(session => ({
      startTime: session.start, // Start date and time of the session
      endTime: session.end, // End date and time of the session
      timezone: userTimezone, // User's timezone
      tutorId: tutorId, // Tutor ID
    }));

    if (available_sessions.length > 0 || waitToDeleteTimeSlots.length > 0) {
      console.log('available_sessions: ', available_sessions); // Debugging line
      console.log('waitToDeleteTimeSlots: ', waitToDeleteTimeSlots); // Debugging line
      sendToBackend(available_sessions, waitToDeleteTimeSlots);
      clearButton.click();
      generateTableBody();
    } else {
      console.warn('No valid selections to send');
    }
  });

  function sendToBackend(available_sessions, waitToDeleteTimeSlots) {
    const url = `/schedule/save-available-tutor-times/`;
    fetch(url, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRFToken': getCookie('csrftoken'),
      },
      body: JSON.stringify({available_sessions: available_sessions, DeletableTimeSlots: waitToDeleteTimeSlots}), // Send the available_sessions array
    })
      .then(response => {
        if (!response.ok) {
          return response.json().then(err => {
            throw err;
          });
        }
        return response.json();
      })
      .then(data => console.log(data))
      .catch(error => console.error('Error:', error));
  }


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

  function refreshTable() {
    // generateTableHeader(startDate);
    clearSelectedSessions(); // Clear selected cells
    generateTableBody();
    // showAvailableTimes(startDate);
    // showBookedTimes(startDate);
  }

// ================================================================================================================
// ------------------------------------- DASHBOARD TIME FORMAT HANDLING -------------------------------------------
// ================================================================================================================

  let allTimeSlots = [];
  // Add event listeners for each day's "Add Time" button
  const addTimeButtons = {
    SUN: document.getElementById('addTime_SUN'),
    MON: document.getElementById('addTime_MON'),
    TUE: document.getElementById('addTime_TUE'),
    WED: document.getElementById('addTime_WED'),
    THU: document.getElementById('addTime_THU'),
    FRI: document.getElementById('addTime_FRI'),
    SAT: document.getElementById('addTime_SAT'),
  };

  //-------------------------------
  function getWeekdayDates(day) {
    const foundDate = weekDayDates.find(wdD => wdD.split(' ')[0] === day);
    return foundDate ? foundDate.split(' ')[1] : null; // Return the date part (YYYY-MM-DD)
  }

  //-------------------------------

  function validateTimeRange(startTime, endTime) {
    // Check if minutes are 00 or 30
    const isValidMinutes = (time) => {
      const minutes = time.split(':')[1];
      return minutes === '00' || minutes === '30';
    };

    if (!isValidMinutes(startTime) || !isValidMinutes(endTime)) {
      alert('Please enter times with minutes rounded to 00 or 30 (e.g., 10:00, 10:30).');
      return false;
    }

    // Special case: 24:00 is 00:00 (next day)
    if (endTime === '00:00') {
      return true;
    }

    // Check if endTime is after startTime
    if (startTime >= endTime) {
      alert('End time must be after start time.');
      return false;
    }

    return true;
  }

  // Function to add a time slot
  function addTimeSlot(day) {
    console.log(`addTimeSlot function called for ${day}`);

    const startTime = document.getElementById(`startTime_${day}`).value;
    const endTime = document.getElementById(`endTime_${day}`).value;
    alert('hello');
    if (!startTime || !endTime) {
      alert('Please fill in both start and end times.');
      return;
    }

    if (!validateTimeRange(startTime, endTime)) {
      return;
    }

    if (isOverlapping(day, startTime, endTime)) {
      alert(`This time slot overlaps with an existing one. Please choose a different time in ${day}.`);
      return;
    }


    // Get the weekday from the button's text content
    const weekDay = document.querySelector(`#heading_${day} .accordion-button span`).textContent.trim();
    const weekDayDate = getWeekdayDates(day); // Get the date for the day

    if (!weekDayDate) {
      console.error(`No date found for ${day}`);
      return;
    }

    // console.log('day: ', day);
    // console.log('weekDayDate: ', weekDayDate);


    // Create a new time slot
    const newTimeSlot = document.createElement('div');
    newTimeSlot.innerHTML = `
      <div class="d-flex justify-content-between align-items-center mb-2">
        <div class="position-relative time-slots">
          <a href="#" class="btn btn-primary btn-round btn-sm mb-0 stretched-link position-static"><i class="fas fa-calendar-check"></i></a>
          <span class="ms-2 mb-0 h6 fw-light">${weekDay}</span>
          <span class="ms-2 mb-0 h6 fw-light">${weekDayDate}</span>
          <span class="ms-2 mb-0 h6 fw-light">${tutorSkill.value}</span>
          <span class="ms-2 mb-0 h6 fw-light">${startTime} - ${endTime}</span>
        </div>
        <div>
          <button class="btn btn-sm btn-success-soft btn-round me-1 mb-1 mb-md-0" onclick="editTimeSlot(this)"><i class="far fa-fw fa-edit"></i></button>
          <button class="btn btn-sm btn-danger-soft btn-round mb-0" onclick="deleteTimeSlot(this)"><i class="fas fa-fw fa-times"></i></button>
        </div>
      </div>
    `;

    // Append the new time slot to the accordion area
    const timeSlotsContainer = document.getElementById(`timeSlots_${day}`);
    timeSlotsContainer.appendChild(newTimeSlot);

    // Clear the input fields
    document.getElementById(`startTime_${day}`).value = '';
    document.getElementById(`endTime_${day}`).value = '';
  }

  // Add event listeners for each day's "Add Time" button
  for (const day in addTimeButtons) {
    if (addTimeButtons[day]) {
      addTimeButtons[day].addEventListener('click', () => addTimeSlot(day));
    }
  }

  // Function to delete a time slot
  window.deleteTimeSlot = function (button) {
    button.closest('.d-flex').remove();
  };

  // Function to edit a time slot (placeholder for now)
  window.editTimeSlot = function (button) {
    alert('Edit functionality will be added in the next step.');
  };


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
  //Submit Time Slots
  document.getElementById('submitTimes').addEventListener('click', function () {
    // Get selected week (example logic, replace with your implementation)
    let selectedWeek = 'Current Week'; // Default value
    if (prevWeekButton.classList.contains('active')) {
      selectedWeek = 'Previous Week';
    } else if (nextWeekButton.classList.contains('active')) {
      selectedWeek = 'Next Week';
    }

    // Loop through each day
    const days = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
    days.forEach(day => {
      const timeSlotsContainer = document.getElementById(`timeSlots_${day}`);
      if (!timeSlotsContainer) {
        console.error(`Container for ${day} not found!`);
        return; // Skip this day if the container doesn't exist
      }

      const timeSlots = timeSlotsContainer.querySelectorAll('.time-slots');
      if (timeSlots.length === 0) {
        console.error(`No .time-slots elements found for ${day}!`);
        return; // Skip this day if no time slots are found
      }

      console.log(`Time slots for ${day}:`, timeSlots);
      timeSlots.forEach(slot => {
        const weekDay = slot.querySelector('span:nth-child(2)')?.textContent.trim();
        const weekDayDate = slot.querySelector('span:nth-child(3)')?.textContent.trim();
        const skill = slot.querySelector('span:nth-child(4)')?.textContent.trim();
        const timeRange = slot.querySelector('span:nth-child(5)')?.textContent.trim();

        if (!weekDay || !skill || !timeRange) {
          console.error('Invalid structure for time slot:', slot);
          return; // Skip this slot if the structure is invalid
        }

        const [startTime, endTime] = timeRange.split(' - ');
        if (!startTime || !endTime) {
          console.error('Invalid time range:', timeRange);
          return; // Skip this slot if the time range is invalid
        }

        allTimeSlots.push({
          weekDay,
          weekDayDate,
          skill,
          startTime,
          endTime,
          timeZone: timezoneSelect.value,
          selectedWeek,
        });
      });
    });

    // Log or process the collected time slots
    console.log('All Time Slots:', allTimeSlots);
    // alert('Time slots submitted successfully! Check the console for details.');
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
        const [startTime, endTime] = timeRange.split(' - ');

        if (weekDay && skill && startTime && endTime) {
          allTimeSlots.push({weekDay, skill, startTime, endTime});
        }
      });
    }
  }


  function isOverlapping(day, newStartTime, newEndTime) {
    const timeSlotsContainer = document.getElementById(`timeSlots_${day}`);
    const timeSlots = Array.from(timeSlotsContainer.children);

    for (const slot of timeSlots) {
      const timeRange = slot.querySelector('span:nth-child(4)')?.textContent.trim();
      const [startTime, endTime] = timeRange.split(' - ');

      if (
        (newStartTime >= startTime && newStartTime < endTime) ||
        (newEndTime > startTime && newEndTime <= endTime) ||
        (newStartTime <= startTime && newEndTime >= endTime)
      ) {
        return true; // Overlapping found
      }
    }

    return false; // No overlapping
  }

});