// document.addEventListener('DOMContentLoaded', function() {
//     // Method selection with dynamic guidance
//     const methodCards = document.querySelectorAll('.method-card');
//     const methodHint = document.getElementById('methodHint');
//
//     methodCards.forEach(card => {
//         card.addEventListener('click', function() {
//             const method = this.getAttribute('data-method');
//
//             // Update active state
//             methodCards.forEach(c => c.classList.remove('active'));
//             this.classList.add('active');
//
//             // Check the radio button
//             document.getElementById(`method_${method}`).checked = true;
//
//             // Toggle in-person section
//             if (method === 'online') {
//                 document.getElementById('inPersonLocationSection').style.display = 'none';
//             } else {
//                 document.getElementById('inPersonLocationSection').style.display = 'block';
//             }
//
//             // Update method hint based on selection
//             if (method === 'hybrid') {
//                 methodHint.innerHTML = `
//                     <i class="bi bi-lightbulb-fill me-2 fs-5 text-warning"></i>
//                     <div>
//                         <strong>Hybrid Teaching - Maximize Your Opportunities</strong>
//                         <ul class="benefit-list mt-2 mb-0">
//                             <li><span class="highlight">Appear in both online and local searches</span> - double your visibility to potential students</li>
//                             <li><span class="highlight">Flexibility to accept both remote and local students</span> based on your schedule and preferences</li>
//                             <li><span class="highlight">Automatic fallback option</span> - if local students aren't available, you'll still get online opportunities</li>
//                             <li><span class="highlight">Higher acceptance rate</span> - students prefer tutors with multiple options</li>
//                         </ul>
//                         <p class="mt-2 mb-0">
//                             <small>Tutors who choose hybrid typically get their first student <span class="highlight">2x faster</span> and maintain <span class="highlight">40% more consistent bookings</span>.</small>
//                         </p>
//                     </div>
//                 `;
//             } else if (method === 'online') {
//                 methodHint.innerHTML = `
//                     <i class="bi bi-lightbulb-fill me-2 fs-5 text-warning"></i>
//                     <div>
//                         <strong>Online Teaching - Global Reach</strong>
//                         <ul class="benefit-list mt-2 mb-0">
//                             <li><span class="highlight">Teach students from anywhere in the world</span> - no geographical limitations</li>
//                             <li><span class="highlight">Higher student volume</span> - access to a much larger pool of potential students</li>
//                             <li><span class="highlight">No travel time or expenses</span> - teach from the comfort of your home</li>
//                             <li><span class="highlight">Flexible scheduling</span> - easier to accommodate different time zones</li>
//                         </ul>
//                         <p class="mt-2 mb-0">
//                             <small>Online tutors typically build their student base <span class="highlight">30% faster</span> but may face more competition on pricing.</small>
//                         </p>
//                     </div>
//                 `;
//             } else if (method === 'in_person') {
//                 methodHint.innerHTML = `
//                     <i class="bi bi-lightbulb-fill me-2 fs-5 text-warning"></i>
//                     <div>
//                         <strong>In-Person Teaching - Local Expertise</strong>
//                         <ul class="benefit-list mt-2 mb-0">
//                             <li><span class="highlight">Premium pricing potential</span> - in-person sessions typically command higher rates</li>
//                             <li><span class="highlight">Stronger student relationships</span> - face-to-face interaction builds better connections</li>
//                             <li><span class="highlight">Less competition</span> - you'll only compete with tutors in your local area</li>
//                             <li><span class="highlight">Specialized local knowledge</span> - understand local curriculum and requirements</li>
//                         </ul>
//                         <p class="mt-2 mb-0">
//                             <small>In-person tutors often achieve <span class="highlight">higher student retention rates</span> but may take longer to build their initial client base.</small>
//                         </p>
//                     </div>
//                 `;
//             }
//         });
//     });
//
//     // Initialize with current method
//     const currentMethod = document.querySelector('input[name="meeting_method"]:checked');
//     if (currentMethod) {
//         const currentCard = document.querySelector(`.method-card[data-method="${currentMethod.value}"]`);
//         if (currentCard) {
//             currentCard.click();
//         }
//     } else {
//         // Default to hybrid
//         document.querySelector('.method-card[data-method="hybrid"]').click();
//     }
// });

//=======================================================================
document.addEventListener('DOMContentLoaded', function () {
    // ===== TEACHING METHOD SELECTION LOGIC =====
    const methodRadios = document.querySelectorAll('input[name="meeting_method"]');
    const methodCards = document.querySelectorAll('.method-card');
    const locationSection = document.getElementById('inPersonLocationSection');
    const privacyHint = document.getElementById('privacyHint');
    const methodHint = document.getElementById('methodHint');

    // Method hints content
    const methodHints = {
        online: `
            <i class="bi bi-lightbulb-fill me-2 fs-5 text-warning"></i>
            <div>
                <strong>Online Only Teaching</strong>
                <ul class="benefit-list mt-2 mb-0">
                    <li>Teach students from anywhere in the world</li>
                    <li>Maximum scheduling flexibility</li>
                    <li>No travel time or location constraints</li>
                    <li>Access to global student base</li>
                </ul>
            </div>
        `,
        hybrid: `
            <i class="bi bi-lightbulb-fill me-2 fs-5 text-warning"></i>
            <div>
                <strong>Hybrid Teaching - Recommended</strong>
                <ul class="benefit-list mt-2 mb-0">
                    <li><span class="highlight">Appear in both online and local searches</span> - double your visibility</li>
                    <li>Flexibility to accept both remote and local students</li>
                    <li>Automatic fallback option if local students aren't available</li>
                    <li>Higher acceptance rate from students</li>
                </ul>
                <p class="mt-2 mb-0"><small>Tutors who choose hybrid typically get their first student <span class="highlight">2x faster</span>.</small></p>
            </div>
        `,
        in_person: `
            <i class="bi bi-lightbulb-fill me-2 fs-5 text-warning"></i>
            <div>
                <strong>In-Person Only Teaching</strong>
                <ul class="benefit-list mt-2 mb-0">
                    <li>Face-to-face interaction with local students</li>
                    <li>Potential for premium pricing</li>
                    <li>Stronger personal connections</li>
                    <li><span class="highlight">Note:</span> Limited to students in your geographical area</li>
                </ul>
            </div>
        `
    };

    function toggleLocationSection() {
        const selectedMethod = document.querySelector('input[name="meeting_method"]:checked').value;
        locationSection.classList.toggle('d-none', selectedMethod === 'online');
        privacyHint.classList.toggle('d-none', selectedMethod === 'online');
    }

    function updateMethodHint(method) {
        methodHint.innerHTML = methodHints[method];
    }

    function updateMethodSelection() {
        const selectedMethod = document.querySelector('input[name="meeting_method"]:checked').value;

        // Update card styles
        methodCards.forEach(card => {
            if (card.dataset.method === selectedMethod) {
                card.classList.add('selected');
            } else {
                card.classList.remove('selected');
            }
        });

        // Update hint and section visibility
        updateMethodHint(selectedMethod);
        toggleLocationSection();
    }

    // Add event listeners to method cards
    methodCards.forEach(card => {
        card.addEventListener('click', function () {
            const method = this.dataset.method;
            document.querySelector(`#method_${method}`).checked = true;
            updateMethodSelection();
        });
    });

    // Add event listeners to radio buttons
    methodRadios.forEach(radio => {
        radio.addEventListener('change', updateMethodSelection);
    });

    // Initialize teaching method section
    updateMethodSelection();

    // Initialize tooltips
    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });

    // ===== MAP INITIALIZATION LOGIC =====
    let isGeocoding = false;
    const saveBtn = document.querySelector('#btnSave_method');
    let map, marker;

    // Wait a bit longer for the DOM to be fully ready
    setTimeout(initializeMap, 300);

    function initializeMap() {
        // Check if map container exists and is visible
        const mapContainer = document.getElementById('osmMap');
        if (!mapContainer) {
            console.error('Map container not found');
            return;
        }

        const initialLat = parseFloat(document.getElementById('osmLat').value) || 0;
        const initialLng = parseFloat(document.getElementById('osmLng').value) || 0;
        const initialZoom = (initialLat && initialLng) ? 12 : 2;

        console.log('Initializing map with coordinates:', initialLat, initialLng);

        // Remove any existing map instance
        if (map) {
            map.remove();
        }

        // Initialize map with proper options
        map = L.map('osmMap', {
            zoomControl: false,
            scrollWheelZoom: false,
            fadeAnimation: false,
            markerZoomAnimation: false
        });

        // Add tile layer
        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>',
            noWrap: true
        }).addTo(map);

        // Add zoom control
        L.control.zoom({ position: 'topright' }).addTo(map);

        // Create marker
        marker = L.marker([initialLat, initialLng], {
            draggable: true,
            icon: L.divIcon({
                html: '<i class="bi bi-geo-alt-fill" style="font-size: 28px; color: #dc3545;"></i>',
                iconSize: [24, 24],
                className: 'bg-transparent'
            })
        }).addTo(map);

        // CRITICAL: Fix map rendering with proper timing
        setTimeout(() => {
            map.invalidateSize(true);
            map.setView([initialLat, initialLng], initialZoom, { animate: false });

            setTimeout(() => {
                map.invalidateSize(true);
                marker.setLatLng([initialLat, initialLng]);

                // Force a tiny movement to trigger proper rendering
                setTimeout(() => {
                    if (initialLat && initialLng) {
                        map.panBy([0.0001, 0], { duration: 0 });
                    }
                }, 100);
            }, 150);
        }, 200);

        // Scroll wheel handling
        map.scrollWheelZoom.disable();
        map.getContainer().addEventListener('wheel', function (e) {
            if (e.ctrlKey) {
                map.scrollWheelZoom.enable();
                setTimeout(() => map.scrollWheelZoom.disable(), 1000);
            } else {
                map.scrollWheelZoom.disable();
            }
        });

        // Search control
        const searchControl = L.Control.geocoder({
            position: 'topleft',
            placeholder: 'Search cities...',
            defaultMarkGeocode: false,
            geocoder: L.Control.Geocoder.nominatim(),
            showResultIcons: true,
            collapsed: false,
            collapseAfterResult: false,
        }).addTo(map);

        function setLoadingState(loading) {
            if (saveBtn) {
                saveBtn.disabled = loading;
                saveBtn.innerHTML = loading ? "Loading location..." : `<i class="bi bi-save me-1"></i> Save`;
            }
        }

        function updateLocation(latLng, placeName = '') {
            const lat = latLng.lat.toFixed(6);
            const lng = latLng.lng.toFixed(6);

            document.getElementById('osmLat').value = lat;
            document.getElementById('osmLng').value = lng;
            document.getElementById('coordinatesDisplay').textContent = `${latLng.lat.toFixed(4)}, ${latLng.lng.toFixed(4)}`;

            if (placeName) {
                let city = '', country = '';

                if (typeof placeName === 'string') {
                    const parts = placeName.split(',');
                    city = parts[0] || '';
                    country = parts[parts.length - 1] || '';
                } else if (typeof placeName === 'object') {
                    city = placeName.city || '';
                    country = placeName.country || '';
                }

                document.getElementById('displayCity').textContent = city || 'Not detected';
                document.getElementById('mapCity').value = city || '';
                document.getElementById('displayCountry').textContent = country || 'Not detected';
                document.getElementById('mapCountry').value = country || '';
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

                    document.getElementById('displayCity').textContent = city || 'Not detected';
                    document.getElementById('mapCity').value = city || '';
                    document.getElementById('displayCountry').textContent = country || 'Not detected';
                    document.getElementById('mapCountry').value = country || '';
                })
                .catch(console.error)
                .finally(() => {
                    isGeocoding = false;
                    setLoadingState(false);
                });
        }

        // Event listeners
        map.on('click', function (e) {
            marker.setLatLng(e.latlng);
            updateLocation(e.latlng);
        });

        marker.on('dragend', function () {
            updateLocation(marker.getLatLng());
        });

        searchControl.on('markgeocode', function (e) {
            const { center, name } = e.geocode;
            map.setView(center, 12);
            marker.setLatLng(center);
            updateLocation(center, name);

            setTimeout(() => map.invalidateSize(true), 100);
        });

        document.getElementById('resetLocation').addEventListener('click', function () {
            const resetView = [0, 0];
            const resetZoom = 2;

            map.setView(resetView, resetZoom);
            marker.setLatLng(resetView);
            document.getElementById('coordinatesDisplay').textContent = 'Not set';
            document.getElementById('displayCity').textContent = 'Not detected';
            document.getElementById('displayCountry').textContent = 'Not detected';
            document.getElementById('osmLat').value = '';
            document.getElementById('osmLng').value = '';
            document.getElementById('mapCity').value = '';
            document.getElementById('mapCountry').value = '';

            setTimeout(() => map.invalidateSize(true), 100);
        });

        // Update location display if we have initial coordinates
        if (initialLat && initialLng) {
            setTimeout(() => {
                updateLocation({ lat: initialLat, lng: initialLng });
            }, 500);
        }

        // Handle window resize
        window.addEventListener('resize', function() {
            setTimeout(() => {
                if (map) {
                    map.invalidateSize(true);
                }
            }, 100);
        });

        // Handle form submission
        document.querySelector('form').addEventListener('submit', function (e) {
            if (isGeocoding) {
                e.preventDefault();
                alert("Please wait until location details are loaded.");
            }
        });
    }
});