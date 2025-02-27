/**
 * LinguaeHub- LMS, Tutor and Course Hub
 *
 * @author Lucas Vpr (https://www.LinguaeHub.com/)
 * @version 1.0.0
 **/


/* ===================
Table Of Content
======================
01 MESSAGE FADER
02
====================== */

$(document).ready(function() {
  setTimeout(function() {
    const message = document.querySelector('#message');
    if (message) {
      message.style.transition = 'opacity 1s';
      message.style.opacity = '0';

      // Wait for the fade-out to complete before removing the element
      setTimeout(function() {
        message.remove();
      }, 1000); // This should match the transition duration
    }
  }, 4000);
});
