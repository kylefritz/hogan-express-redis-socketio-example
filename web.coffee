util = require("util")
datetime = require("datetime")
_ = require("underscore")
express = require("express")
hogan = require('hogan.js')
http = require('http')


#
#redis setup
#
redis = null
if process.env.REDISTOGO_URL
  rtg = require("url").parse(process.env.REDISTOGO_URL)
  redis = require("redis").createClient(rtg.port, rtg.hostname)
  redis.auth rtg.auth.split(":")[1]
else
  redis = require("redis").createClient()


#app setup
app = express.createServer()
app.configure ->
  app.use express.logger()
  app.use app.router
  app.use express.methodOverride()
  app.use express.bodyParser()
  #compile less and coffeescript
  app.use express.compiler(
    src: __dirname + '/public'
    enable: ['coffeescript','less']
  )
  #serve static assets
  app.use express.static(__dirname + '/public')
  #show stack trace since internal
  app.use express.errorHandler({ dumpExceptions: true, showStack: true })
  #use mustache for view engine
  app.set 'views', __dirname + '/views'
  #view engine has to match file extension
  app.set 'view engine', 'mustache'
  #setup mustache to be rendered by hogan
	app.register('mustache',require('./hogan-express.js').init(hogan))


#socket setup
io = require("socket.io").listen(app)
io.set "log level", 0

#routes
#
app.get "/", (req, res) ->

  #redis.get "deliveryo:state:#{from}", (err,state) ->
  #redis.hgetall "deliveryo:orders:#{orderid}", (err,order) ->
  res.render('app', {
     title: 'Lets go!'
   });
  
#
#sockets
#
io.sockets.on "connection", (socket) ->
  socket.emit "message:new",
    message: "welcome!"
  socket.on "message:send", (data) ->
    io.sockets.emit "message:new",
      message: "broadcast!"

#start app
port = process.env.PORT or 5000
app.listen port, ->
  console.log "listening on " + port
