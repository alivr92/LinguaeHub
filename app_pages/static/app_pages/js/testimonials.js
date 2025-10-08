document.addEventListener('DOMContentLoaded', function () {
    let isPlaying = true;

    // Play/Pause functionality
    document.getElementById('playAllScrolling').addEventListener('click', function () {
        const contents = document.querySelectorAll('.scrolling-content');
        contents.forEach(content => {
            content.classList.remove('paused');
            content.style.animationPlayState = 'running';
        });
        isPlaying = true;
    });

    document.getElementById('pauseAllScrolling').addEventListener('click', function () {
        const contents = document.querySelectorAll('.scrolling-content');
        contents.forEach(content => {
            content.classList.add('paused');
            content.style.animationPlayState = 'paused';
        });
        isPlaying = false;
    });

    // Pause on card hover
    const items = document.querySelectorAll('.scrolling-item');
    items.forEach(item => {
        item.addEventListener('mouseenter', function () {
            const content = this.closest('.scrolling-content');
            if (content) {
                content.classList.add('paused');
                content.style.animationPlayState = 'paused';
            }
        });

        item.addEventListener('mouseleave', function () {
            const content = this.closest('.scrolling-content');
            if (content && isPlaying) {
                content.classList.remove('paused');
                content.style.animationPlayState = 'running';
            }
        });
    });

    // Duplicate content for seamless looping
    function duplicateContentForSeamlessLoop() {
        const contents = document.querySelectorAll('.scrolling-content');
        contents.forEach(content => {
            const items = content.querySelectorAll('.scrolling-item');
            const firstHalf = Array.from(items).slice(0, Math.ceil(items.length / 2));

            firstHalf.forEach(item => {
                const clone = item.cloneNode(true);
                content.appendChild(clone);
            });
        });
    }

    duplicateContentForSeamlessLoop();
});