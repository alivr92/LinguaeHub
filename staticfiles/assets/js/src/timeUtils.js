/**
 * Convert local time to UTC time (for sending to backend)
 * @param {string} localTime - Time string in format 'HH:MM' (e.g., '14:30')
 * @param {string} timezone - IANA timezone string (e.g., 'America/New_York')
 * @returns {string} UTC time string in format 'HH:MM'
 */
export function localTimeToUtcTime(localTime, timezone) {
     // Handle 24:00 by converting to 23:59:59.999
    if (localTime === '24:00') {
        localTime = '23:59:59.999';
    }
    // Create a date object with today's date and the local time
    const [hours, minutes] = localTime.split(':').map(Number);
    const today = new Date();
    const localDate = new Date(today.getFullYear(), today.getMonth(), today.getDate(), hours, minutes);

    // Format as ISO string with timezone
    const isoString = localDate.toLocaleString('en-US', {
        timeZone: timezone,
        hour12: false,
        year: 'numeric',
        month: '2-digit',
        day: '2-digit',
        hour: '2-digit',
        minute: '2-digit'
    });

    // Parse the formatted string back to a date object
    const [month, day, year] = isoString.split('/');
    const [timePart] = isoString.split(', ')[1].split(' ');
    const [localHours, localMinutes] = timePart.split(':');

    const localDateTime = new Date(`${year}-${month}-${day}T${localHours}:${localMinutes}:00`);

    // Convert to UTC and extract time part
    const utcHours = localDateTime.getUTCHours().toString().padStart(2, '0');
    const utcMinutes = localDateTime.getUTCMinutes().toString().padStart(2, '0');

    return `${utcHours}:${utcMinutes}`;
}

/**
 * Convert UTC time to local time (for displaying to user)
 * @param {string} utcTime - Time string in format 'HH:MM' (e.g., '18:30')
 * @param {string} timezone - IANA timezone string (e.g., 'America/New_York')
 * @returns {string} Local time string in format 'HH:MM'
 */
export function utcTimeToLocalTime(utcTime, timezone) {
    // Create a date object with today's date and the UTC time
    const [utcHours, utcMinutes] = utcTime.split(':').map(Number);
    const today = new Date();
    const utcDate = new Date(Date.UTC(today.getFullYear(), today.getMonth(), today.getDate(), utcHours, utcMinutes));

    // Convert to local time in the specified timezone
    const localTimeString = utcDate.toLocaleTimeString('en-US', {
        timeZone: timezone,
        hour12: false,
        hour: '2-digit',
        minute: '2-digit'
    });

    return localTimeString;
}

// Alternative simpler approach using Date manipulation
export function utcTimeToLocalTimeSimple(utcTime, timezone) {
    const [hours, minutes] = utcTime.split(':');
    const date = new Date();

    // Set UTC time
    date.setUTCHours(parseInt(hours), parseInt(minutes), 0, 0);

    // Convert to local time string in the specified timezone
    return date.toLocaleTimeString('en-US', {
        timeZone: timezone,
        hour12: false,
        hour: '2-digit',
        minute: '2-digit'
    });
}