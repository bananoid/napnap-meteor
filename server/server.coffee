Meteor.startup ()->
  console.log "Meteor.startup"

  # collectionApi = new CollectionAPI
  #   apiPath:'api'
  #   standAlone: false

  # collectionApi.addCollection Alarms, "alarms",
  #   methods: ['POST','GET','PUT','DELETE']

  # collectionApi.start()

  mrt = __meteor_bootstrap__
  # http = mrt.require('http')
  # server = http.createServer (req,res)->
  url = mrt.require 'url'

  mrt.app.stack.unshift
    route: "/api/alarms",
    handle: (request, response)->

      body = '';

      request.on 'data', (data)->
        body += data;

      request.on 'end', ()->
        obj = JSON.parse(body);
        # console.log("PUT " , request.url, " :: ", obj );

        pUrl = url.parse request.url
        id = pUrl.pathname.split('/')[1]
        obj._id = id

        Fiber ()->
          Alarms.sendWakeUp obj
        .run()

        response.setHeader('Content-Length', body.length);
        response.setHeader('Content-Type', 'application/json');
        response.write(body);
        response.end();

  mrt.app.stack.unshift
    route: "/api/alarms/next",
    handle: (request, response)->
      Fiber ()->

        nextAlarm = Alarms.getNext()

        body =  "#{nextAlarm._id}\r\n#{nextAlarm.playTime}"

        # response.statusCode = statusCode;
        response.setHeader('Content-Length', body.length);
        response.setHeader('Content-Type', 'application/json');
        response.write(body);
        response.end();

      .run()
