Meteor.Router.add
  '/':'alarms'
  '/setAlarm':'setAlarm'
  '/nextAlarm':'nextAlarm'
  '/alarms':'alarms'
  '/testA': 'testA'
  '/testB': 'testB'
  '/testC': 'testC'
  '*': 'not_found'

# Template.home.rendered = ()->

Template.setAlarm.events
  'click .timeSet':(e)->
    playTime =  document.getElementById("timeValue").value;
    playTime = humanToTime(playTime);
    playTime = parseInt(playTime)

    d = new Date();
    loadTime = Math.floor(d.getTime()/1000)
    console.log playTime

    Alarms.insert
      playTime:playTime
      loadTime:loadTime

# Template.setAlarm.rendered = ()->
#   console.log "setAlarm"
#   console.log "find ", this.find("#timeValue")

Template.setAlarm.now = ->
  t = Math.floor(new Date().getTime()/1000) + 60
  return timeToHuman t

Template.alarms.items = ()->
  return Alarms.find({offTime:{$exists:true}},{sort:{loadTime:-1}})
  # return Alarms.find({},{sort:{loadTime:-1}})

timeToHuman = (time)->
  # if not obj[key]
  #   return "-"

  d = new Date(time * 1000)
  dateStr =
  d.getFullYear().toString() + "-" +
  d.getMonth().toString() + "-" +
  d.getDate().toString() + " " +
  d.getHours().toString() + ":" +
  d.getMinutes().toString() + ":" +
  d.getSeconds().toString();
  return dateStr

humanToTime = (ht)->
  date = new Date(ht)
  return date.getTime()

Template.alarms.humanPlayTime = ()->
  return timeToHuman this.playTime

Template.alarms.humanLoadTime = ()->
  return timeToHuman this.loadTime

Template.nextAlarm.nextAlarm = ()->
  # return Alarms.find().sort({_id:1}).limit(1);
  alarm = Alarms.getNext()
  return null if not alarm
  alarm.humanTime = timeToHuman alarm.playTime/1000
  return alarm


Template.testA.rendered = ()->
  console.log "render", Meteor.Router.page()

  p = d3.select("#mainContainer").select(".span10").selectAll("p")
  .data([40, 80, 15, 16, 23, 42])
  .text( (d)-> "I'm number #{d}!")

  p.enter().append("p")
  .text( (d)-> "I'm number #{d}!")
  .style( "font-size", (d)-> d*0.3 + "px")
  .style( "line-height", (d)-> d*0.08 + "px")
  .style( "color", (d,i)-> "hsl(#{i*200+180},30%,50%)")

  p.exit().remove();

  p.transition()
  .duration(2000)
  .delay((d, i)-> Math.random()*1000 )
  .style( "font-size", (d)-> d + "px")
  .style( "line-height", (d)-> d*0.8 + "px")
  .style( "color", (d,i)-> "hsl(#{i*200+50},30%,50%)")



Template.testB.rendered = ()->
  console.log "render", Meteor.Router.page()

  data = ( Math.random() * 100 for num in [0 ... 100] )

  p = d3.select("#mainContainer").select("svg").selectAll("circle")
  .data(data)
  # .text( (d)-> "I'm number #{d}!")

  p.enter().append("circle")
  .attr("r", (d)-> Math.sqrt(d * 0.1) )
  .attr("cx", (d,i)-> i%10 * 50 + 200)
  .attr("cy", (d,i)-> Math.floor(i/10) *  50 + 100)
  .attr( "fill", (d,i)-> "hsl(20, #{d+60}%, #{80-d*0.4}%)")
  # .attr( "fill", (d,i)-> "hsl(#{Math.random()*150}, 70%, 45%)")
  .transition()
  .duration(3000)
  .delay((d, i)-> Math.random()*3000 )
  .attr("r", (d)-> Math.sqrt(d * 5) )
  # .attr("r", (d)-> 25 )

Template.testC.rendered = ()->
  console.log "render", Meteor.Router.page()

  data = ( Math.random() * 100 for num in [0 ... 100] )

  p = d3.select("#mainContainer").select("svg").selectAll("circle")
  .data(data)
  # .text( (d)-> "I'm number #{d}!")

  p.enter().append("rect")
  .attr("width", (d)-> 50 )
  .attr("height", (d)-> 50 )
  .attr("x", (d,i)-> i%10 * 50 + 200)
  .attr("y", (d,i)-> Math.floor(i/10) *  50 + 100)
  .attr( "fill", (d,i)-> "hsl(10, #{d+60}%, #{80-d*0.4}%)")
  # .attr( "fill", (d,i)-> "hsl(#{Math.random()*150}, 70%, 45%)")
  .transition()
  .duration(2000)
  .delay((d, i)-> Math.random()*2000 )
  .attr( "fill", (d,i)-> "hsl(200, #{d+60}%, #{80-d*0.4}%)")

Template.mainNavItem.selected = -> if Meteor.Router.page() is this._id then "active" else ''

Template.mainNav.items = [

  {
    _id:"setAlarm"
    label:"Set Alarm"
  }
  {
    _id:"alarms"
    label:"Alarms"
  }
  {
    _id:"nextAlarm"
    label:"Next Alarm"
  }
  # {
  #   _id:"testA"
  #   label:"Test A"
  # }
  {
    _id:"testB"
    label:"Test B"
  }
  {
    _id:"testC"
    label:"Test C"
  }
]
