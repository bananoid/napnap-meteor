Meteor.startup ()->
  console.log "Meteor.startup"

  collectionApi = new CollectionAPI
    apiPath:'api'
    standAlone: false

  collectionApi.addCollection Alarms, "alarms",
    methods: ['POST','GET','PUT','DELETE']

  collectionApi.start()
