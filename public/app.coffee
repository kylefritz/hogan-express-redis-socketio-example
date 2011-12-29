socket = io.connect(document.location.protocol + "//" + document.location.hostname)
socket.on "message:new", (data) ->
  console.log "got", data
  $("#message-tmpl").tmpl(data).appendTo "#messages"
  window.scrollTo(0, document.body.scrollHeight)

socket.on "message:jagger", (data) ->
  console.log "got jagger!"
  snd = new Audio("/moves.mp3")
  snd.play()

$ ->
  $("#chat-name").val("Some Dude " + parseInt(Math.random() * 100))
  $("#send-message").submit((e) ->
    data =
      from: $("#chat-name").val()
      message: $("#new-message").val()

    socket.emit "message:send", data
    console.log "sent", data
    $("#new-message").val ""
    e.preventDefault()
  )

  $("#sms-message").submit (e) ->
    socket.emit "sms:send",
      to: $("#sms-to").val()
      message: $("#new-sms").val()

    $("#new-sms").val ""
    e.preventDefault()

  $dlg = $("#new-delivery").dialog(
    modal: true
    autoOpen: false
    width: "460px"
    title:"Request a Delivery"
  )
  $("#request").click ->
    $dlg.dialog "open"

  $("#request-it").submit (e) ->
    $form = $(this)
    $.post "/delivery",
      requestingNumber: $("#requesting-number").val()
      bid:              $("#bid").val()
      from:             $("#from").val()
      to:               $("#to").val()
      drivers:          $("#drivers").val()
    , -> $dlg.dialog "close"
    $dlg.dialog "close"

    e.preventDefault()
