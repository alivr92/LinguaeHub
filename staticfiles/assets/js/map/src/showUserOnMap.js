// // Initialize map only if user has location
// document.addEventListener('DOMContentLoaded', function () {
//     // Initialize map
//     const initialLat = parseFloat(document.getElementById('osmLat').value) || 0;
//     const initialLng = parseFloat(document.getElementById('osmLng').value) || 0;
//     const radius = parseFloat(document.getElementById('radius').value) || 0;
//     var map = L.map('userLocationMap').setView([initialLat, initialLng], 11);
//
//     L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
//         // attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
//     }).addTo(map);
//
//     // Add user marker
//     var userMarker = L.marker([initialLat, initialLng]).addTo(map)
//         .bindPopup("<b>{{ user.get_full_name }}</b><br>{{ profile.city }}, {{ profile.get_country_display }}");
//
//     // Add circle for meeting radius
//     L.circle([initialLat, initialLng], {
//         color: '#0d6efd',
//         fillColor: '#0d6efd',
//         fillOpacity: 0.2,
//         radius: radius * 1000 // Convert km to meters
//     }).addTo(map);
// });

//================================================================
document.addEventListener('DOMContentLoaded', function () {
    // Initialize map
    const initialLat = parseFloat(document.getElementById('osmLat').value) || 0;
    const initialLng = parseFloat(document.getElementById('osmLng').value) || 0;
    const radius = parseFloat(document.getElementById('radius').value) || 0;

    // Get student locations
    const nearbyLocations = JSON.parse(document.getElementById('nearbyLocations').value || '[]');

    var map = L.map('userLocationMap').setView([initialLat, initialLng], 11);

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {}).addTo(map);

    // Add tutor marker (blue)
    var tutorMarker = L.marker([initialLat, initialLng], {
        icon: new L.Icon({
            iconUrl: 'https://cdn.rawgit.com/pointhi/leaflet-color-markers/master/img/marker-icon-blue.png',
            shadowUrl: 'https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.7.1/images/marker-shadow.png',
            iconSize: [25, 41],
            iconAnchor: [12, 41],
            popupAnchor: [1, -34],
            shadowSize: [41, 41]
        })
    }).addTo(map)
        .bindPopup("<b>{{ user.get_full_name }}</b><br>{{ profile.city }}, {{ profile.get_country_display }}");

    // Add circle for meeting radius
    L.circle([initialLat, initialLng], {
        color: '#0d6efd',
        fillColor: '#0d6efd',
        fillOpacity: 0.2,
        radius: radius * 1000
    }).addTo(map);

// Add red markers for each student
    nearbyLocations.forEach(location => {
        L.marker([location.lat, location.lng], {
            icon: new L.Icon({
                iconUrl: 'https://cdn.rawgit.com/pointhi/leaflet-color-markers/master/img/marker-icon-red.png',
                shadowUrl: 'https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.7.1/images/marker-shadow.png',
                iconSize: [20, 33],        // ~20% smaller
                iconAnchor: [10, 33],      // Adjusted to keep bottom point aligned
                popupAnchor: [1, -27],     // Adjusted for smaller height
                shadowSize: [33, 33]       // Scaled shadow to match
            })
        }).addTo(map)
            .bindPopup(`<b>${location.name}</b><br>${location.city}, ${location.country}<br>Distance: ${location.distance.toFixed(2)} km`);
    });


    // Optional: Adjust view to show all markers
    if (nearbyLocations.length > 0) {
        var group = new L.featureGroup([tutorMarker].concat(
            nearbyLocations.map(loc => L.latLng(loc.lat, loc.lng))
        ));
        map.fitBounds(group.getBounds().pad(0.2));
    }
});