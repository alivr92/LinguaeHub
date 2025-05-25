document.addEventListener('DOMContentLoaded', function () {
    const container = document.getElementById('skills-container');
    const reviewContainer = document.getElementById('review-skills-container');
    const template = document.getElementById('skill-row-template');
    const reviewTemplate = document.getElementById('review-row-template');
    const applicant_video_intro = document.getElementById('applicant_video_intro');
    const applicantUId = parseInt(document.getElementById('applicantUId').value);
    const maxSkills = 3; // Set your max skills limit
    const validVideoTypes = ['mp4'];
    const validCertificateTypes = ['pdf', 'doc', 'docx', 'png', 'jpg', 'jpeg'];
    const alertLimitMessage = document.querySelector('#skillLimitAlert');

    let submitTimeout;

    // Initialize with existed skills
    showExistedSkills();
    // Initialize with one row
    addSkillRow();
    initTooltips();

    // Add skill row
    document.getElementById('btnAddSkill').addEventListener('click', function () {
        if (checkSkillLimit()) return;
        else addSkillRow();
    });

    async function showExistedSkills() {
        if (!applicantUId) {
            console.error('No applicantUId found!');
            return;
        }

        const url = `/tutor/get-existed-skills/?applicantUId=${applicantUId}`;
        try {
            const response = await fetch(url);
            if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`);

            const data = await response.json();
            console.log('Received data:', data);

            // Clear container safely
            while (container.firstChild) {
                container.removeChild(container.firstChild);
            }

            // Process skills
            if (data.existed_uSkill_list && Array.isArray(data.existed_uSkill_list)) {
                data.existed_uSkill_list.forEach(uSkill => {
                    console.log('Processing skill:', uSkill);
                    addExistedSkillRow(
                        uSkill.uSkillId,
                        uSkill.skill,    // Make sure this is the ID
                        uSkill.level,    // Make sure this is the ID
                        uSkill.video,
                        uSkill.certificate,
                        uSkill.status
                    );
                });

                //set video_intro if exists
                // const video_intro = data.video_intro;
                // if (applicant_video_intro && video_intro) {
                //     const videoLabel = document.createElement('p');
                //     videoLabel.className = 'text-muted small mb-1';
                //     videoLabel.textContent = `Existing: ${video_intro.split('/').pop()}`;
                //     videoInput.parentNode.insertBefore(videoLabel, videoInput);
                // }
                // Handle video intro - NEW CODE
                const videoIntroInput = document.querySelector('[name="video_intro"]');
                if (videoIntroInput && data.video_intro) {
                    const videoLabel = document.createElement('p');
                    videoLabel.className = 'text-muted small mb-1';
                    videoLabel.textContent = `Existing: ${data.video_intro.split('/').pop()}`;

                    // Insert before the file input
                    videoIntroInput.parentNode.insertBefore(videoLabel, videoIntroInput);

                    // Optional: Add a hidden field to track existing video
                    const hiddenInput = document.createElement('input');
                    hiddenInput.type = 'hidden';
                    hiddenInput.name = 'existing_video_intro';
                    hiddenInput.value = data.video_intro;
                    videoIntroInput.parentNode.appendChild(hiddenInput);
                }


            } else {
                console.error('Invalid data format:', data);
            }
        } catch (error) {
            console.error('Error fetching skills:', error);
        }
    }


    function checkSkillLimit() {
        if (container.querySelectorAll('.skill-row').length >= maxSkills) {
            if (alertLimitMessage) alertLimitMessage.classList.remove('d-none');
            showBootstrapAlert(`Maximum ${maxSkills} skills allowed`, 'danger', 5000);
            return true; // means limit reached
        } else {
            if (alertLimitMessage) alertLimitMessage.classList.add('d-none');
            return false; // means we can add more skills yet!
        }
    }

    // fill other fields like applicant_video_intro

    //fill existed skills
    function addExistedSkillRow(uSkillId, skillId, levelId, video, certificate, status) {
        console.log('Adding row with:', {uSkillId, skillId, levelId, video, certificate, status});

        if (!template) {
            console.error('Template not found!');
            return;
        }

        const newRow = template.content.cloneNode(true);
        container.appendChild(newRow);

        // Get the newly added row (now in DOM)
        const addedRow = container.lastElementChild;

        // SAFELY set select values
        const skillSelect = addedRow.querySelector('[name="skill"]');
        if (skillSelect) {
            console.log('Setting skill to:', skillId);
            skillSelect.value = skillId;
        } else {
            console.error('Skill select not found!');
        }

        const levelSelect = addedRow.querySelector('[name="level"]');
        if (levelSelect) {
            console.log('Setting level to:', levelId);
            levelSelect.value = levelId;
        } else {
            console.error('Level select not found!');
        }

        // Initialize Choices.js AFTER setting values
        if (typeof Choices !== 'undefined') {
            if (skillSelect) {
                new Choices(skillSelect, {
                    searchEnabled: true,
                    removeItemButton: true,
                    shouldSort: false
                });
            }
            if (levelSelect) {
                new Choices(levelSelect, {
                    searchEnabled: true,
                    removeItemButton: true,
                    shouldSort: false
                });
            }
        }

        console.log(skillSelect._choicesjs);
        // Handle file videoInput
        const videoInput = addedRow.querySelector('[name="skill_video"]');
        if (videoInput && video) {
            // Create a wrapper for the label + edit icon
            const videoDisplay = document.createElement('div');
            videoDisplay.className = 'd-flex align-items-center gap-2';

            // Show the existing/uploaded filename
            const videoLabel = document.createElement('span');
            videoLabel.className = 'text-secondary small';
            // videoLabel.textContent = video.split('/').pop();
            videoLabel.textContent = "Video Uploaded";

            // Edit icon (clicking it brings back the file input)
            const btnEdit = document.createElement('a');


            btnEdit.className = 'btn btn-sm btn-success-soft px-2 me-1 mb-1 mb-md-0';
            btnEdit.innerHTML=`<i class="far fa-fw fa-edit"></i>`;
            btnEdit.title = 'Change video';
            btnEdit.onclick = () => {
                videoDisplay.replaceWith(videoInput); // Replace label with file input
                videoInput.style.display = 'block';  // Ensure it's visible
            };

            videoDisplay.appendChild(videoLabel);
            videoDisplay.appendChild(btnEdit);

            // Hide the original file input and show our label + icon
            videoInput.style.display = 'none';
            videoInput.parentNode.insertBefore(videoDisplay, videoInput);
        }



        const certificateInput = addedRow.querySelector('[name="certificate"]');
        if (certificateInput && certificate) {
            // const certLabel = document.createElement('p');
            // certLabel.className = 'text-muted small mb-1';
            // certLabel.textContent = `Existing: ${certificate.split('/').pop()}`;
            // certificateInput.parentNode.insertBefore(certLabel, certificateInput);

            // Create a wrapper for the label + edit icon
            const certificateDisplay = document.createElement('div');
            certificateDisplay.className = 'd-flex align-items-center gap-2';

            // Show the existing/uploaded filename
            const certLabel = document.createElement('span');
            certLabel.className = 'text-secondary small';
            // certLabel.textContent = certificate.split('/').pop();
            certLabel.textContent = "Certificate Uploaded";

            // Edit icon (clicking it brings back the file input)
            const btnEdit = document.createElement('a');


            btnEdit.className = 'btn btn-sm btn-success-soft px-2 me-1 mb-1 mb-md-0';
            btnEdit.innerHTML=`<i class="far fa-fw fa-edit"></i>`;
            btnEdit.title = 'Change Certificate';
            btnEdit.onclick = () => {
                certificateDisplay.replaceWith(certificateInput); // Replace label with file input
                certificateInput.style.display = 'block';  // Ensure it's visible
            };

            certificateDisplay.appendChild(certLabel);
            certificateDisplay.appendChild(btnEdit);

            // Hide the original file input and show our label + icon
            certificateInput.style.display = 'none';
            certificateInput.parentNode.insertBefore(certificateDisplay, certificateInput);

        }

        // Add remove handler
        addedRow.querySelector('.remove-skill').addEventListener('click', function () {
            this.closest('.skill-row').remove();
            initTooltips();
            checkSkillLimit();
        });

        initTooltips();
    }


    function addSkillRow() {
        const newRow = template.content.cloneNode(true);
        const rowId = Date.now();

        // Update names with unique IDs
        newRow.querySelectorAll('[name]').forEach(el => {
            const originalName = el.name;
            el.name = `${originalName}_${rowId}`;
            el.id = `id_${originalName}_${rowId}`;
        });

        // Add remove handler
        newRow.querySelector('.remove-skill').addEventListener('click', function () {
            this.closest('.skill-row').remove();
            initTooltips();
            checkSkillLimit();
        });

        container.appendChild(newRow);
        initSelects();
        initTooltips();
    }

    // Initialize select2/choices.js
    function initSelects() {
        if (typeof Choices !== 'undefined') {
            document.querySelectorAll('.js-choice:not([data-choicejs])').forEach(select => {
                new Choices(select, {
                    searchEnabled: true,
                    removeItemButton: true,
                    classNames: {
                        containerInner: 'choices__inner bg-transparent',
                        listDropdown: 'choices__list--dropdown'
                    },
                    shouldSort: false
                });
                select.setAttribute('data-choicejs', 'true');
            });
        }
    }

    // Initialize tooltips
    function initTooltips() {
        if (typeof bootstrap !== 'undefined') {
            document.querySelectorAll('[data-bs-toggle="tooltip"]').forEach(el => {
                new bootstrap.Tooltip(el);
            });
        }
    }


    container.addEventListener('change', function () {
        generateReviewFromCurrentSkills();
    });

    function generateReviewFromCurrentSkills() {
        // Clear previous content
        reviewContainer.innerHTML = '';

        const rows = reviewContainer.querySelectorAll('.skill-row');

        rows.forEach(row => {
            const skillSelect = row.querySelector('[name^="skill"]');
            const levelSelect = row.querySelector('[name^="level"]');
            const videoInput = row.querySelector('[name^="skill_video"]');
            const certificateInput = row.querySelector('[name^="certificate"]');

            // const skillName = skillSelect.options[skillSelect.selectedIndex]?.text || '';
            const skillName = skillSelect.innerHTML = `Ali`;
            const levelName = levelSelect.options[levelSelect.selectedIndex]?.text || '';
            const videoFile = videoInput?.files[0]?.name || '';
            const certFile = certificateInput?.files[0]?.name || '';

            // Clone and populate a row using reviewTemplate
            const newRow = reviewTemplate.content.cloneNode(true);
            const addedRow = newRow.querySelector('.review-row');

            if (addedRow) {
                addedRow.querySelector('.review-skill-name').textContent = skillName;
                addedRow.querySelector('.review-level-name').textContent = levelName;
                if (videoFile) addedRow.querySelector('.review-video-file').textContent = `Video: ${videoFile}`;
                if (certFile) addedRow.querySelector('.review-cert-file').textContent = `Certificate: ${certFile}`;

                reviewContainer.appendChild(addedRow);
            }
        });
    }


    // Form submission with validation
    document.getElementById('btnSubmitSkills').addEventListener('click', function (e) {
        e.preventDefault();

        // Client-side validation
        if (!validateForm()) {
            return;
        }

        const btn = this;
        const formData = new FormData();
        const rows = container.querySelectorAll('.skill-row');

        // Set timeout (15 seconds)
        submitTimeout = setTimeout(() => {
            btn.disabled = false;
            btn.innerHTML = '<i class="bi bi-save me-2"></i>Save Skills';
            showBootstrapAlert('Request timed out. Please try again.', 'danger', 5000);
        }, 15000);

        // Collect skills data
        rows.forEach(row => {
            const skill = row.querySelector('[name^="skill"]');
            const level = row.querySelector('[name^="level"]');
            const skillVideo = row.querySelector('[name^="skill_video"]');
            const certificate = row.querySelector('[name^="certificate"]');

            formData.append('skills', skill.value);
            formData.append('levels', level.value);

            if (skillVideo.files[0]) {
                formData.append('skill_videos', skillVideo.files[0]);
            }
            if (certificate.files[0]) {
                formData.append('certificates', certificate.files[0]);
            }
        });

        // Add video intro
        const videoIntro = document.querySelector('[name="video_intro"]');
        if (videoIntro.files[0]) {
            formData.append('video_intro', videoIntro.files[0]);
        }

        // Add CSRF token
        formData.append('csrfmiddlewaretoken', document.querySelector('[name=csrfmiddlewaretoken]').value);

        // AJAX submission
        const url = `/tutor/save-skills/`;
        fetch(url, {
            method: 'POST',
            body: formData,
            headers: {
                'X-Requested-With': 'XMLHttpRequest'
            }
        })
            .then(response => response.text()) // Use text temporarily
            .then(text => {
                console.log("Server responded with text:", text);
                const data = JSON.parse(text); // Try parsing it manually
                if (data.success) {
                    showBootstrapAlert('success', 'Skills saved successfully!');
                } else {
                    showBootstrapAlert(data.error || 'Error saving skills', 'danger', 5000);
                }
            })
            .catch(error => {
                console.error("JSON Parse or Network error", error);
                clearTimeout(submitTimeout);
                showBootstrapAlert('Network error occurred', 'danger', 5000);
            })
            .finally(() => {
                btn.disabled = false;
                btn.innerHTML = '<i class="bi bi-save me-2"></i>Save Skills';
            });


    });


    // Client-side validation
    function validateForm() {
        const rows = container.querySelectorAll('.skill-row');
        const videoIntro = document.querySelector('[name="video_intro"]');
        let isValid = true;
        let errSkills = [];
        let errLevels = [];

        // Check max skills
        if (rows.length > maxSkills) {
            showBootstrapAlert(`Maximum ${maxSkills} skills allowed`, 'danger', 5000);
            return false;
        }

        // Validate each row
        rows.forEach((row, index) => {
            const skill = row.querySelector('[name^="skill"]');
            const level = row.querySelector('[name^="level"]');
            const skillVideo = row.querySelector('[name^="skill_video"]');
            const certificate = row.querySelector('[name^="certificate"]');

            const skillName = skill.options[skill.selectedIndex]?.text || 'Unknown Skill';
            const rowNumber = index + 1;

            // Required fields
            if (!skill.value) {
                errSkills.push(`Row ${rowNumber}`);
                isValid = false;
            }
            if (!level.value) {
                errLevels.push(`Row ${rowNumber} (${skillName})`);
                isValid = false;
            }
            // if (!skillVideo.files[0]) {
            //     showBootstrapAlert(`Please upload a video for row ${index + 1}`, 'danger', 5000);
            //     isValid = false;
            // }
            // File type validation
            if (skillVideo.files[0] && !validateFileType(skillVideo.files[0], validVideoTypes)) {
                showBootstrapAlert(`Invalid video format for row ${index + 1}. Only  ${validVideoTypes} are allowed.`, 'danger', 5000);
                isValid = false;
            }
            if (certificate.files[0] && !validateFileType(certificate.files[0], validCertificateTypes)) {
                showBootstrapAlert(`Invalid certificate format for row ${index + 1}`, 'danger', 5000);
                isValid = false;
            }
        });

        if (errSkills.length > 0) {
            showBootstrapAlert(`Please select a skill for: ${errSkills.join(', ')}`, 'danger', 5000);
        }

        if (errLevels.length > 0) {
            showBootstrapAlert(`Please select a level for: ${errLevels.join(', ')}`, 'danger', 5000);
        }


        // Validate video intro
        if (!videoIntro.files[0]) {
            showBootstrapAlert('Introduction video is required', 'danger', 5000);
            isValid = false;
        } else if (!validateFileType(videoIntro.files[0], validVideoTypes)) {
            showBootstrapAlert(`Invalid video format. Only ${validVideoTypes.join(', ')} are allowed.`, 'danger', 5000);
            isValid = false;
        }

        return isValid;
    }

    // Validate file type
    function validateFileType(file, allowedExtensions) {
        const extension = file.name.split('.').pop().toLowerCase();
        return allowedExtensions.includes(extension);
    }

    // Initialize on load
    initSelects();
    initTooltips();
    generateReviewFromCurrentSkills();
});