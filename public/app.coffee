socket = io.connect(document.location.protocol + "//" + document.location.hostname)
socket.on "message:new", (data) ->
  console.log "got", data

socket.on 'connect', ->
  data =
    from: "this window"
    message: "hi to you also"

  socket.emit "message:send", data
  console.log "sent", data
