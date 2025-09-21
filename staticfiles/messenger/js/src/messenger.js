document.addEventListener('DOMContentLoaded', function() {
    // Real-time messaging with WebSockets
    const threadId = window.location.pathname.split('/').filter(Boolean).pop();
    if (threadId && !isNaN(threadId)) {
        const socket = new WebSocket(
            `ws://${window.location.host}/ws/messaging/thread/${threadId}/`
        );

        socket.onmessage = function(e) {
            const data = JSON.parse(e.data);
            const messageList = document.getElementById('message-list');
            const isSender = data.sender_id === '{{ request.user.id }}';

            const messageHtml = `
                <div class="message ${isSender ? 'sent' : 'received'}">
                    <div class="message-content">
                        <p>${data.message}</p>
                        <small class="message-time">
                            Just now
                            ${isSender ? '<i class="bi bi-check-all read-receipt"></i>' : ''}
                        </small>
                    </div>
                </div>
            `;

            messageList.insertAdjacentHTML('beforeend', messageHtml);
            messageList.scrollTop = messageList.scrollHeight;
        };

        // Handle form submission
        const messageForm = document.getElementById('message-form');
        if (messageForm) {
            messageForm.addEventListener('submit', function(e) {
                e.preventDefault();
                const content = this.querySelector('textarea').value;

                // Send via WebSocket
                socket.send(JSON.stringify({
                    'message': content,
                    'sender_id': '{{ request.user.id }}'
                }));

                // Clear input
                this.querySelector('textarea').value = '';
            });
        }
    }

    // Username validation
    const usernameInput = document.getElementById('id_recipient_username');
    if (usernameInput) {
        usernameInput.addEventListener('input', function() {
            if (this.value.length < 3) return;

            fetch('/messaging/check_username/', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'X-CSRFToken': document.querySelector('[name=csrfmiddlewaretoken]').value
                },
                body: `recipient_username=${encodeURIComponent(this.value)}`
            })
            .then(response => response.json())
            .then(data => {
                const feedback = document.getElementById('username-feedback');
                if (data.valid) {
                    feedback.textContent = data.message;
                    feedback.className = 'form-text text-success';
                } else {
                    feedback.textContent = data.message;
                    feedback.className = 'form-text text-danger';
                }
            });
        });
    }
});