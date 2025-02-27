document.addEventListener('DOMContentLoaded', () => {
  const tableHead = document.querySelector('#schedule-table thead tr');
  const tableBody = document.querySelector('#schedule-table tbody');
  const daysOfWeek = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
  const period = 2; // Adjust this for different periods (e.g., 2, 3, 4)
  const submitButton = document.getElementById('submit-button');
  const clearButton = document.getElementById('clear-button');
  const tutorId = document.getElementById('tutor_id').value;
  let selectedCells = [];
  let selectedSessions = [];


  //------------------------------------------- TIMEZONE START -------------------------------------------------------
  const timeZones = Intl.supportedValuesOf('timeZone');
  const timezoneSelect = document.getElementById('timezone-select'); // Time zone dropdown
  timeZones.forEach(zone => {
    const option = document.createElement('option');
    option.value = zone;
    option.text = zone;
    timezoneSelect.appendChild(option);
  });

  // Default to user's system time zone (in Dashboard must get the tutor's timezone)
  let userTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;

  // Set the dropdown to the user's system time zone if it exists in the options
  const timezoneOptions = Array.from(timezoneSelect.options).map(option => option.value);
  if (timezoneOptions.includes(userTimezone)) {
    timezoneSelect.value = userTimezone;
  }

  // Event listener for time zone changes
  timezoneSelect.addEventListener('change', () => {
    userTimezone = timezoneSelect.value;
    generateTableHeader(startDate);
    generateTableBody();
    showBootstrapAlert(`Note: Calendar is showing based on ${userTimezone} time zone.`, 'primary');
  });

  // Helper function to convert UTC time to local time
  function convertUTCToLocal(utcTime, timezone) {
    const utcDate = new Date(utcTime);
    const localTime = utcDate.toLocaleString('en-US', {timeZone: timezone});
    return new Date(localTime);
  }

  //------------------------------------------- TIMEZONE END ---------------------------------------------------------

  //--------------------------------- Date & Time (Client) START -------------------------------------------------------
  //---------- Initialize table with current week START ------------
  const startDayOfWeekObj = document.getElementById('startDayOfWeek');
  let startDayOfWeek = parseInt(startDayOfWeekObj.value); // Initialize with the current value

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
  startDayOfWeekObj.addEventListener('change', () => {
    startDayOfWeek = parseInt(startDayOfWeekObj.value);
    console.log('startDayOfWeek: ', startDayOfWeek);
    startDate = calculateStartDate(today, startDayOfWeek);
    generateTableHeader(startDate);
    generateTableBody();
  });

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

  // GET date for client (simple. with NO radio button)
  function getDate(cell) {
    const date = tableHead.cells[cell.cellIndex].innerText.split(' ')[1]; // Get date from header
    return `${date}`; // date
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
  //--------------------------------- Date & Time (Client) END ---------------------------------------------------------

  generateTableHeader(startDate);
  generateTableBody();

  // Generate table header with dates (to use the selected time zone)
  function generateTableHeader(startDate) {
    while (tableHead.children.length > 1) {
      tableHead.removeChild(tableHead.lastChild);
    }

    for (let i = 0; i < 7; i++) {
      const currentDate = new Date(startDate);
      currentDate.setDate(startDate.getDate() + i);
      const th = document.createElement('th');
      th.innerText = `${daysOfWeek[currentDate.getDay()]} ${currentDate.toLocaleDateString('en-US', {timeZone: userTimezone})}`;
      th.style.height = '2px';
      th.style.textAlign = 'center';
      th.style.padding = '2px';
      if (isToday(currentDate)) {
        th.classList.add('current-date');
      }
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
      timeCell.style.height = '2px';
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
          td.addEventListener('mouseover', handleMouseOver);
          td.addEventListener('mouseout', handleMouseOut);

          //---------------------------------------------------------------------- Bootstrap TOOLTIP START
          const weekDay = tableHead.cells[i + 1].innerText.split(' ')[0]; // Adjust index if needed
          const date = tableHead.cells[i + 1].innerText.split(' ')[1]; // Adjust index if needed
          const timeStart = time.split(' - ')[0]
          const timeEnd = time.split(' - ')[1]
          // const title = `${weekDay} ${time}`;
          const title = `${weekDay} ${timeStart} - ${timeEnd}`;
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

    //--------------------------------------- Initialize Bootstrap TOOLTIP START---------------------------------
    // Initialize Bootstrap tooltips for dynamically added elements
    const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]');
    const tooltipList = [...tooltipTriggerList].map(tooltipTriggerEl => new bootstrap.Tooltip(tooltipTriggerEl));
    //--------------------------------------- Initialize Bootstrap TOOLTIP END ----------------------------------

    // Show available times after and booked sessions after generating the table
    showAvailableTimes(localStartDate);
    showBookedTimes(localStartDate);
  }

  //---------------------------------- Navigate week Buttons (Client) START ---------------------------------------------------
  document.getElementById('prev-week').addEventListener('click', () => {
    const newStartDate = new Date(startDate);
    newStartDate.setDate(startDate.getDate() - 7);
    startDate = newStartDate;
    // Check if the new week has at least one available day
    if (!hasAvailableDays(startDate)) {
      // primary, secondary, success, danger, warning, info, light, dark
      showBootstrapAlert('This previous week has no available days and cannot be accessed.', 'info');
      return; // Stop further execution
    }
    if (isChangedWeek()) {
      saveCurrentWeekSelectedSessions((shouldSubmit) => {
        if (shouldSubmit) {
          submitButton.click(); // Execute the submit button logic if shouldSubmit is true
        }
        handleWeekChange(startDate);
      });
    } else {
      handleWeekChange(startDate);
    }
  });
  document.getElementById('next-week').addEventListener('click', async () => {
    const nextWeekStartDate = new Date(startDate);
    nextWeekStartDate.setDate(startDate.getDate() + 7);
    startDate = nextWeekStartDate;
    const hasAvailability = await checkAvailability(startDate);
    if (hasAvailability) {
      if (isChangedWeek()) {
        saveCurrentWeekSelectedSessions((shouldSubmit) => {
          if (shouldSubmit) {
            submitButton.click(); // Execute the submit button logic if shouldSubmit is true
          }
          handleWeekChange(startDate);
        });
      } else {
        handleWeekChange(startDate);
      }
    } else {
      // primary, secondary, success, danger, warning, info, light, dark
      showBootstrapAlert('This next week has no available days and cannot be accessed.', 'info');
    }
  });
  document.getElementById('current-week').addEventListener('click', () => {
    startDate = calculateStartDate(today, startDayOfWeek);
    if (isChangedWeek()) {
      saveCurrentWeekSelectedSessions((shouldSubmit) => {
        if (shouldSubmit) {
          submitButton.click(); // Execute the submit button logic if shouldSubmit is true
        }
        handleWeekChange(startDate);
      });
    } else {
      handleWeekChange(startDate);
    }
  });
  //---------------------------------- Navigate week Buttons (Client) END -----------------------------------------------------

  //---------------------------------- Client POPUP START ----------------------------------
  //This function checks if selectedSessions and waitToDeleteTimeSlots are empty or not
  function isChangedWeek() {
    return (selectedSessions.length > 0);
  }

  function handleWeekChange(startDate) {
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
  function saveCurrentWeekSelectedSessions(callback) {
    const modal = new bootstrap.Modal(document.getElementById('confirmWeek'));
    modal.show(); // Show the modal dialog
    currentCallback = callback; // Set the current callback
    return;
  }

  //---------------------------------- POPUP END ----------------------------------

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
    if (cell.classList.contains('booked') || cell.classList.contains('disabled') ||
      (!cell.classList.contains('tutor-available-cell') &&
        !cell.classList.contains('tutor-available-cell-start') &&
        !cell.classList.contains('tutor-available-cell-end'))
    ) {
      return; // Only allow selection for tutor-available, NOT booked and NOT disabled cells
    }

    const rowIndex = cell.parentElement.rowIndex - 1; // Get row index
    const cellIndex = cell.cellIndex; // Get column index

    // Check if the clicked cell belongs to any session in selectedSessions
    const sessionIndex = selectedSessions.findIndex(session => session.cells.includes(cell));

    if (sessionIndex !== -1) {
      // If the cell belongs to a session, deselect all cells in that session
      const session = selectedSessions[sessionIndex];
      session.cells.forEach(cell => {
        cell.classList.remove('selected');
      });

      // Remove the session from selectedSessions
      selectedSessions.splice(sessionIndex, 1);
    } else {
      // If the cell does not belong to any session, get continuous cells for the selected period
      const continuousCells = getContinuousCells(rowIndex, cellIndex, period, true);

      // Check if the number of continuous cells matches the period
      if (continuousCells.length === period) {
        // Check if any of the continuous cells are already part of another session
        const isOverlapping = continuousCells.some(cell =>
          selectedSessions.some(session => session.cells.includes(cell))
        );

        if (!isOverlapping) {
          // Select all cells in the group
          continuousCells.forEach(cell => {
            cell.classList.add('selected');
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

  function handleMouseOver(event) {
    const cell = event.target;
    const rowIndex = cell.parentElement.rowIndex - 1;
    const cellIndex = cell.cellIndex;
    const continuousCells = getContinuousCells(rowIndex, cellIndex, period, false);

    // Add tooltip -- BASIC TOOLTIP -------------------------------------------------------[CHECKED]
    const date = tableHead.cells[cellIndex].innerText.split(' ')[1];
    const time = cell.parentElement.cells[0].innerText;
    // cell.title = `${date} ${time}`;
    // Add tooltip -- BASIC TOOLTIP End ------------------------------------------------------------

    if (continuousCells.length === period) {
      continuousCells.forEach(cell => cell.classList.add('highlight'));
    }
  }

  function handleMouseOut(event) {
    const highlightedCells = document.querySelectorAll('.highlight');
    highlightedCells.forEach(cell => cell.classList.remove('highlight'));
  }

  function getContinuousCells(startRowIndex, startCellIndex, period, allowSelected) {
    const continuousCells = [];
    const rows = tableBody.getElementsByTagName('tr');

    for (let i = 0; i < period; i++) {
      const currentRow = rows[startRowIndex + i];
      if (currentRow) {
        // we get the column number as startCellIndex
        const currentCell = currentRow.cells[startCellIndex];
        if (currentCell && (!currentCell.classList.contains('selected') || allowSelected) &&
          !currentCell.classList.contains('disabled') &&
          (currentCell.classList.contains('tutor-available-cell') ||
            currentCell.classList.contains('tutor-available-cell-start') ||
            currentCell.classList.contains('tutor-available-cell-end'))
        ) {
          continuousCells.push(currentCell);
        } else {
          return [];
        }
      } else {
        return [];
      }
    }
    // console.log('continuousCells: ', continuousCells)
    return continuousCells;
  }

  function isOverlapping(cells) {
    return cells.some(cell => cell.classList.contains('selected'));
  }

  // Clear selected cells
  clearButton.addEventListener('click', () => {
    clearSelectedCells();
  });

  function clearSelectedCells() {
    const selected = tableBody.querySelectorAll('.selected');
    selected.forEach(cell => cell.classList.remove('selected'));
    selectedCells = []; // Reset the array
    selectedSessions = []; // Reset the array
    console.log('selectedSessions: ', selectedSessions)
  }

  async function showAvailableTimes(startDate) {
    const url = `/schedule/get-availability/?tutorId=${tutorId}&startDate=${startDate.toISOString().split('T')[0]}`;
    try {
      const response = await fetch(url);
      if (!response.ok) throw new Error('Failed to fetch availability data');
      const data = await response.json();

      // Clear previous highlights
      const highlightedCells = document.querySelectorAll('.tutor-available-cell, .tutor-available-cell-start, .tutor-available-cell-end');
      highlightedCells.forEach(cell => cell.classList.remove('.tutor-available-cell, .tutor-available-cell-start, .tutor-available-cell-end'));

      // Highlight available cells
      data.availability.forEach(availability => {
          const startTimeUTC = availability.start_time_utc;
          const endTimeUTC = availability.end_time_utc;

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
                if (cell && !cell.classList.contains('disabled-cell') && !cell.classList.contains('booked') && !cell.classList.contains('booked-start') && !cell.classList.contains('booked-end') ) {
                  if (rowDate.getTime() === startTime.getTime()) {
                    cell.classList.add('tutor-available-cell-start');
                  } else if (rowDate.getTime() === (endTime.getTime() - 30 * 60 * 1000)) { // 30 minutes before endTime
                    cell.classList.add('tutor-available-cell-end');
                  } else {
                    cell.classList.add('tutor-available-cell');
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

  async function showBookedTimes(startDate) {
    const url = `/schedule/get-booked/?tutorId=${tutorId}&startDate=${startDate.toISOString().split('T')[0]}`;
    try {
      const response = await fetch(url);
      if (!response.ok) throw new Error('Failed to fetch booked sessions data');
      const data = await response.json();

      // Clear previous highlights
      const highlightedCells = document.querySelectorAll('.booked');
      highlightedCells.forEach(cell => cell.classList.remove('booked'));

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
                    cell.classList.remove('tutor-available-cell');
                    cell.classList.remove('tutor-available-cell-start');
                    // cell.classList.add('booked');
                    cell.classList.add('booked-start');
                    cell.style.pointerEvents = 'none';
                  // } else if (rowDate.getTime() === (endTime.getTime())) {
                    } else if (rowDate.getTime() === (endTime.getTime() - 30 * 60 * 1000)) { // 30 minutes before endTime
                    cell.classList.remove('tutor-available-cell');
                    cell.classList.remove('tutor-available-cell-end');
                    // cell.classList.add('booked');
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


  submitButton.addEventListener('click', () => {
    const periods = selectedSessions.map(session => ({
      startTime: session.start, // Start date and time of the session
      endTime: session.end, // End date and time of the session
      timezone: userTimezone, // User's timezone
      tutorId: tutorId, // Tutor ID
    }));

    if (periods.length > 0) {
      console.log('Periods:', periods); // Debugging line
      sendToBackend(periods);
      clearSelectedCells();
    } else {
      console.warn('No valid selections to send');
    }
  });

  function sendToBackend(periods) {
    const url = `/schedule/reserve-sessions/`;
    fetch(url, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRFToken': getCookie('csrftoken'),
      },
      body: JSON.stringify({periods: periods}), // Send the periods array
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


  function refreshTable() {
    // generateTableHeader(startDate);
    clearSelectedCells(); // Clear selected cells
    generateTableBody();
    // showAvailableTimes(startDate);
    // showBookedTimes(startDate);
  }

  function sendToBackend_previous(data) {
    const url = `/schedule/reserve-sessions/`;
    fetch(url, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRFToken': getCookie('csrftoken')
      },
      body: JSON.stringify({periods: data})
    }).then(response => {
      if (!response.ok) {
        return response.json().then(err => {
          throw err;
        });
      }
      return response.json();
    }).then(data => console.log(data))
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

  // Checking Booked Sessions ***************************************************************** CHECK ? date, startDate
  async function isBookedCell(date) {
    const url = `/schedule/get-booked/?tutorId=${tutorId}&startDate=${date.toISOString().split('T')[0]}`;
    try {
      const response = await fetch(url);
      if (!response.ok) {
        throw new Error('Failed to fetch booked session data');
      }
      const data = await response.json();
      console.log('Fetched booked session data for next week:', data);

      // Check if there is any availability
      return data.booked_sessions.length > 0;
    } catch (error) {
      console.error('Error fetching booked sessions:', error);
      return false;
    }
  }

  async function checkBookedInWeek(startDate) {
    const url = `/schedule/get-booked/?tutorId=${tutorId}&startDate=${startDate.toISOString().split('T')[0]}`;
    try {
      const response = await fetch(url);
      if (!response.ok) {
        throw new Error('Failed to fetch booked session data');
      }
      const data = await response.json();
      console.log('Fetched booked session data for next week:', data);

      // Check if there is any availability
      return data.booked_sessions.length > 0;
    } catch (error) {
      console.error('Error fetching booked sessions:', error);
      return false;
    }
  }

  //============================================================================================
});