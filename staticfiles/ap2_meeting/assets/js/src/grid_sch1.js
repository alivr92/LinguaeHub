var itemsSchedule = [
  {
    keyfrom: "sf",
    keyto: "sff",
    text: "Event 1",
    bg: "red",
    days:['sunday']
  }
  ,{
    keyfrom: "st",
    keyto: "eff",
    text: "Event 2",
    bg: "blue",
    days:['sunday']
  }
  ,{
    keyfrom: "nt",
    keyto: "nff",
    text: "Event x S",
    bg: "green",
    days:['sunday']
  }
  ,{
    keyfrom: "s",
    keyto: "sf",
    text: "Wake up",
    bg: "green",
    days:['monday', 'tuesday', 'wednesday', 'thursday','friday']
  }  
  ,{
    keyfrom: "sf",
    keyto: "sff",
    text: "Event for monday",
    bg: "yellow",
    days:['monday']
  }
  ,{
    keyfrom: "eff",
    keyto: "nf",
    text: "Event for monday",
    bg: "purple",
    days:['monday']
  }
  ,{
    keyfrom: "n",
    keyto: "nff",
    text: "Event for wednesday",
    bg: "blue",
    days:['wednesday']
  }
  ,{
    keyfrom: "sf",
    keyto: "st",
    text: "Event for w",
    bg: "red",
    days:['wednesday']
  }
  ,{
    keyfrom: "st",
    keyto: "e",
    text: "Event for thursday",
    bg: "yellow",
    days:['thursday']
  }
  ,{
    keyfrom: "eff",
    keyto: "n",
    text: "Event x th",
    bg: "yellow",
    days:['thursday']
  }
  ,{
    keyfrom: "e",
    keyto: "eff",
    text: "Event x friday",
    bg: "purple",
    days:['friday']
  }
  ,{
    keyfrom: "n",
    keyto: "nff",
    text: "Event x saturday",
    bg: "red",
    days:['saturday']
  }
]

itemsSchedule.forEach(function(sitem,index){
  // console.log(index,sitem)
  sitem.days.forEach(function(sday, dindex){
    // console.log(sday, dindex)
    $(".schedule").append(
      '<div class="schedule-item'
      +' schedule-'+ sday
      +' time-from-'+ sitem.keyfrom
      +' time-to-'+sitem.keyto
      +' nt bg-'+sitem.bg+'">'
        +sitem.text
      +'</div>'
     )
  })
})

 // buildItemTemplate({
 //      day: sday,
 //      keyfrom: sitem.keyfrom,
 //      keyto: sitem.keyto,
 //      bg: sitem.bg,
 //      text: sitem.text
 //    })
// function buildItemTemplate(args){
//   return ''.concat(
//     '<div class="schedule-item'
//       ,' schedule-', args.day
//       ,' time-from-', args.keyfrom
//       ,' time-to-',args.keyto
//       ,' nt bg-',args.bg,'">'
//     ,args.text
//     ,'</div>'
//   )     
// }