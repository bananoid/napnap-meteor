Alarms = new Meteor.Collection("alarms");

Alarms.getNext = ()->
  return this.findOne({},{sort:{loadTime:-1}})

Alarms.sendWakeUp = (data)->
  this.update data._id,
    '$set':
      offTime:data.reactionTime
      intensity:data.int
