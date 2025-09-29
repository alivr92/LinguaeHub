document.addEventListener('DOMContentLoaded', function () {
    let isGeocoding = false; // track request state
    const saveBtn = document.querySelector('#btnSave_method');

    // Initialize map
    const initialLat = parseFloat(document.getElementById('osmLat').value) || 0;
    const initialLng = parseFloat(document.getElementById('osmLng').value) || 0;
    const initialZoom = (initialLat && initialLng) ? 12 : 2;

    const map = L.map('osmMap', {
        zoomControl: false,
        scrollWheelZoom: false // 🚫 disable zoom on scroll
    }).setView([initialLat, initialLng], initialZoom);

    // Disable normal scroll wheel zoom
    map.scrollWheelZoom.disable();
// map.on('focus', () => map.scrollWheelZoom.enable());
// map.on('blur', () => map.scrollWheelZoom.disable());

// Listen to wheel events over the map
    map.getContainer().addEventListener('wheel', function (e) {
        if (e.ctrlKey) { // Only zoom if Ctrl is pressed
            map.scrollWheelZoom.enable();
        } else {
            map.scrollWheelZoom.disable();
        }
    });


    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>'
    }).addTo(map);

    L.control.zoom({position: 'topright'}).addTo(map);

    const marker = L.marker([initialLat, initialLng], {
        draggable: true,
        icon: L.divIcon({
            html: '<i class="bi bi-geo-alt-fill" style="font-size: 28px; color: #dc3545;"></i>',
            iconSize: [24, 24],
            className: 'bg-transparent'
        })
    }).addTo(map);

    const geocoder = L.Control.Geocoder.nominatim();
    const searchControl = L.Control.geocoder({
        position: 'topleft',
        placeholder: 'Search cities...',
        defaultMarkGeocode: false,
        geocoder: geocoder,
        showResultIcons: true,
        collapsed: false, // 👈 this keeps the search bar open
        collapseAfterResult: false,
    }).addTo(map);

    function setLoadingState(loading) {
        saveBtn.disabled = loading;
        saveBtn.innerHTML = loading ? "Loading location..." : `<i class="bi bi-save me-1"></i> Save`;
        // saveBtn.textContent = loading ? "Loading location..." : `Save`;
    }

    function updateLocation(latLng, placeName = '') {
        document.getElementById('osmLat').value = latLng.lat.toFixed(6);
        document.getElementById('osmLng').value = latLng.lng.toFixed(6);
        document.getElementById('coordinatesDisplay').textContent =
            `${latLng.lat.toFixed(4)}, ${latLng.lng.toFixed(4)}`;

        if (placeName) {
            document.getElementById('displayCity').textContent = placeName.city;
            document.getElementById('mapCity').value = placeName.city;
            document.getElementById('displayCountry').textContent = placeName.country;
            document.getElementById('mapCountry').value = placeName.country;
            return;
        }

        isGeocoding = true;
        setLoadingState(true);

        fetch(`https://nominatim.openstreetmap.org/reverse?format=json&lat=${latLng.lat}&lon=${latLng.lng}&zoom=10&addressdetails=1`)
            .then(response => response.json())
            .then(data => {
                const address = data.address;
                const city = address?.city || address?.town || address?.village ||
                    address?.municipality || address?.county || '';
                const country = address?.country || '';

                if (city) {
                    document.getElementById('displayCity').textContent = city;
                    document.getElementById('mapCity').value = city;
                }
                if (country) {
                    document.getElementById('displayCountry').textContent = country;
                    document.getElementById('mapCountry').value = country;
                }
            })
            .catch(console.error)
            .finally(() => {
                isGeocoding = false;
                setLoadingState(false);
            });
    }

    document.querySelector('form').addEventListener('submit', function (e) {
        if (isGeocoding) {
            e.preventDefault();
            alert("Please wait until location details are loaded.");
        }
    });

    map.on('click', function (e) {
        marker.setLatLng(e.latlng);
        updateLocation(e.latlng);
    });

    marker.on('dragend', function () {
        updateLocation(marker.getLatLng());
    });

    searchControl.on('markgeocode', function (e) {
        const {center, name} = e.geocode;
        map.setView(center, 12);
        marker.setLatLng(center);
        updateLocation(center, name);
    });

    document.getElementById('resetLocation').addEventListener('click', function () {
        map.setView([0, 0], 2);
        marker.setLatLng(map.getCenter());
        document.getElementById('coordinatesDisplay').textContent = 'Not set';
        document.getElementById('displayCity').textContent = 'Not detected';
        document.getElementById('displayCountry').textContent = 'Not detected';
        document.getElementById('osmLat').value = '';
        document.getElementById('osmLng').value = '';
        document.getElementById('mapCity').value = '';
        document.getElementById('mapCountry').value = '';
    });

    if (initialLat && initialLng) {
        updateLocation({lat: initialLat, lng: initialLng});
    }
});
// =================================================================

// =================================================================

// ---------------------- Google Map ----------------------
// Initialize Map
// function initMap() {
//     const defaultLocation = { lat: 51.505, lng: -0.09 }; // London as fallback
//     const map = new google.maps.Map(document.getElementById("locationMap"), {
//         center: defaultLocation,
//         zoom: 12,
//         streetViewControl: false,
//         mapTypeControl: false
//     });
//
//     const marker = new google.maps.Marker({
//         map: map,
//         draggable: true,
//         title: "Drag to adjust"
//     });
//
//     // Search Box Integration
//     const searchBox = new google.maps.places.SearchBox(document.getElementById("locationSearch"));
//     map.addListener("bounds_changed", () => searchBox.setBounds(map.getBounds()));
//
//     // Update marker position on search
//     searchBox.addListener("places_changed", () => {
//         const places = searchBox.getPlaces();
//         if (!places.length) return;
//
//         const place = places[0];
//         updateLocation(place.geometry.location, place.address_components);
//         map.fitBounds(place.geometry.viewport || new google.maps.LatLngBounds(place.geometry.location, place.geometry.location));
//     });
//
//     // Update on marker drag
//     marker.addListener("dragend", () => {
//         const geocoder = new google.maps.Geocoder();
//         geocoder.geocode({ location: marker.getPosition() }, (results, status) => {
//             if (status === "OK" && results[0]) {
//                 updateLocation(marker.getPosition(), results[0].address_components);
//             }
//         });
//     });
//
//     // Reset button
//     document.getElementById("resetLocation").addEventListener("click", () => {
//         map.setCenter(defaultLocation);
//         marker.setPosition(defaultLocation);
//         updateLocation(defaultLocation, null);
//     });
//
//     // Helper function
//     function updateLocation(latLng, addressComponents) {
//         marker.setPosition(latLng);
//         document.getElementById("latitude").value = latLng.lat();
//         document.getElementById("longitude").value = latLng.lng();
//         document.getElementById("coordinatesDisplay").textContent = `${latLng.lat().toFixed(4)}, ${latLng.lng().toFixed(4)}`;
//
//         // Extract city from address components
//         if (addressComponents) {
//             const cityComponent = addressComponents.find(comp =>
//                 comp.types.includes('locality') || comp.types.includes('administrative_area_level_2')
//             );
//             const city = cityComponent ? cityComponent.long_name : 'Unknown';
//             document.getElementById("mapCity").value = city;
//             document.getElementById("displayCity").value = city;
//         }
//     }
// }
