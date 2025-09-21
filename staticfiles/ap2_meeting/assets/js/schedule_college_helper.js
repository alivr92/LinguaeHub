var entries = [];
var courseMap = {};
var courses = [];
var exampleSchedules = [
  ["70003"],
  ["70003"],
  ["70816", "70815", "73755", "71009", "71624"]
];
var start = standardTimeToMinutes("8:00 AM");
var end = standardTimeToMinutes("3:00 PM");

var dayFromLetter = {
  "M": "Mon",
  "T": "Tue",
  "W": "Wed",
  "R": "Thu",
  "F": "Fri",
  "S": "Sat",
  "U": "Sun"
};

function parseDataToCourse(data) {
  var timesProp = data.times;
  var times = [];
  for (var i = 0; i < timesProp.length; i++) {
    var prop = timesProp[i].split(",");

    if (prop[1] == " TBA") {
      return;
    }

    var moments = prop[1].split("-");
    var startMoment = moments[0].split(" ");
    var isPm = startMoment[2] == "pm";
    startMoment = startMoment[1].split(":");
    startMoment = parseInt(startMoment[0] + startMoment[1] - 1) % 1200 + (isPm ? 1201 : 1);
    var endMoment = moments[1].split(" ");
    isPm = endMoment[1] == "pm";
    endMoment = endMoment[0].split(":")
    endMoment = parseInt(endMoment[0] + endMoment[1] - 1) % 1200 + (isPm ? 1201 : 1);

    var days = prop[0];
    for (var j = 0; j < days.length; j++) {
      var day = dayFromLetter[days.charAt(j)];
      var start = {"day":day, time:startMoment};
      var end = {"day":day, time:endMoment};
      times.push(new CourseJS.Time(start, end));
    }
  }
  var timeSet = new CourseJS.TimeSet(times);

  var courseInfo = new CourseJS.CourseInfo(data.info.searchable, data.info.regular, data.info.hidden, data.classInfo.number, data.classInfo.section, data.classInfo.abbreviation);

  var course = new CourseJS.Course(data.alias, timeSet, courseInfo);
  return course;
}

$('select').material_select();

$('#crn-submit').click(() => {
  entries = [];
  if ($('#examples').val() !== "") {
    exampleSchedules[$('#examples').val()-1].forEach((crn)=>{
      entries.push(courseMap[crn]);
    });
  } else {
    $('.crn').each(function () {
      courseMap[$(this).val()] && entries.push(courseMap[$(this).val()]);
    })
  }
  start = standardTimeToMinutes($("#start").val());
  end = standardTimeToMinutes($("#end").val());
  courses = entries.map((entry) => {return parseDataToCourse(entry)});
  render();
});

$.getJSON( "https://rawgit.com/cazinge/college-schedule-helper/master/data/lmu/json/Spring_2017.json", function(data) {
  courseMap = data;
  $("#crn-submit").prop("disabled", false);
});

function render () {
  ReactDOM.render(
  <Schedule start={start} end={end} courses={courses}/>,
  document.getElementById('react-schedule')
);
}

render();