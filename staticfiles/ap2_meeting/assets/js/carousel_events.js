(function($) {
  'use strict';
  $(function () {
    //Event carousel
    $("#events").owlCarousel({
      loop:true,
      margin:0,
      autoPlay: 3000,
      responsive:{
        0:{
          items:1
        },
        768:{
          items:2
        },
        979:{
          items:3
        },
        1199:{
          items:4
        }
      },
      singleItem : false,
      dots: false,
      nav: true,
      navText : ["",""]
    });
    $(".btn-event-show").collapse();
    //Events: Tooltip
    $('.event-user').tooltip({ boundary: 'window' });
    feather.replace();
  });
})(jQuery);