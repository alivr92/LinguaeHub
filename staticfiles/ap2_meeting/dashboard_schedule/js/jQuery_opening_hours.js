var rangeTimes = [];

$(".range-slider").slider({
  range: true,
  min: 0,
  max: 1440,
  values: [540, 1080],
  step:30,
  slide: slideTime,
  change: updateOpeningHours
});

function slideTime(event, ui){
  if (event && event.target) {
    var $rangeslider = $(event.target);
    var $rangeday = $rangeslider.closest(".range-day");
    var rangeday_d = parseInt($rangeday.data('day'));
    var $rangecheck = $rangeday.find(":checkbox");
    var $rangetime = $rangeslider.next(".range-time");
  }

  if ($rangecheck.is(':checked')) {
    $rangeday.removeClass('range-day-disabled');
    $rangeslider.slider('enable');

    if (ui!==undefined) {
      var val0 = ui.values[0],
        val1 = ui.values[1];
    } else {
      var val0 = $rangeslider.slider('values', 0),
        val1 = $rangeslider.slider('values', 1);
    }

    var minutes0 = parseInt(val0 % 60, 10),
      hours0 = parseInt(val0 / 60 % 24, 10),
      minutes1 = parseInt(val1 % 60, 10),
      hours1 = parseInt(val1 / 60 % 24, 10);
    if (hours1==0) hours1=24;

    rangeTimes[rangeday_d] = [getTime(hours0, minutes0),getTime(hours1, minutes1)];

    $rangetime.text(rangeTimes[rangeday_d][0] + ' - ' + rangeTimes[rangeday_d][1]);

  } else {
    $rangeday.addClass('range-day-disabled');
    $rangeslider.slider('disable');

    rangeTimes[rangeday_d] = [];

    $rangetime.text('Closed');
  }
}

function updateOpeningHours() {
  if ($('#schedule').length) {
    $('#schedule tbody').empty();
  } else {
    $('body').append('<br>\
      <table id="schedule">\
	    <thead>\
		    <tr>\
          <th>Day</th>\
			    <th>Start Time</th>\
			    <th>End Time</th>\
		    </tr>\
	    </thead>\
	    <tbody>\
	    </tbody>\
      </table>');
  }
  for (d=1; d<=7; d++) {
    $('#schedule tbody').append('<tr>'+
      '<td>'+d+'</td>'+
      '<td>'+(rangeTimes[d][0]===undefined?'Closed':rangeTimes[d][0])+'</td>'+
      '<td>'+(rangeTimes[d][1]===undefined?'':rangeTimes[d][1])+'</td>'+
      '</tr>');
  }
}

function getTime(hours, minutes) {
  var time = null;
  minutes = minutes + "";
  if (minutes.length == 1) {
    minutes = "0" + minutes;
  }
  return hours + ":" + minutes;
}

$('.range-checkbox').on('change', function(){
  var $rangecheck = $(this);
  var $rangeslider = $rangecheck.closest('.range-day').find('.range-slider');
  slideTime({target:$rangeslider});
  updateOpeningHours();
});

$("#scheduleSubmit").on('click', updateOpeningHours);

slideTime({target:$('#range-slider-1')});
slideTime({target:$('#range-slider-2')});
slideTime({target:$('#range-slider-3')});
slideTime({target:$('#range-slider-4')});
slideTime({target:$('#range-slider-5')});
slideTime({target:$('#range-slider-6')});
slideTime({target:$('#range-slider-7')});
updateOpeningHours();
