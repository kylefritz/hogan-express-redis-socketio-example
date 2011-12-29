(function() {
  var socket;

  socket = io.connect(document.location.protocol + "//" + document.location.hostname);

  socket.on("message:new", function(data) {
    console.log("got", data);
    $("#message-tmpl").tmpl(data).appendTo("#messages");
    return window.scrollTo(0, document.body.scrollHeight);
  });

  socket.on("message:jagger", function(data) {
    var snd;
    console.log("got jagger!");
    snd = new Audio("/moves.mp3");
    return snd.play();
  });

  $(function() {
    var $dlg;
    $("#chat-name").val("Some Dude " + parseInt(Math.random() * 100));
    $("#send-message").submit(function(e) {
      var data;
      data = {
        from: $("#chat-name").val(),
        message: $("#new-message").val()
      };
      socket.emit("message:send", data);
      console.log("sent", data);
      $("#new-message").val("");
      return e.preventDefault();
    });
    $("#sms-message").submit(function(e) {
      socket.emit("sms:send", {
        to: $("#sms-to").val(),
        message: $("#new-sms").val()
      });
      $("#new-sms").val("");
      return e.preventDefault();
    });
    $dlg = $("#new-delivery").dialog({
      modal: true,
      autoOpen: false,
      width: "460px",
      title: "Request a Delivery"
    });
    $("#request").click(function() {
      return $dlg.dialog("open");
    });
    return $("#request-it").submit(function(e) {
      var $form;
      $form = $(this);
      $.post("/delivery", {
        requestingNumber: $("#requesting-number").val(),
        bid: $("#bid").val(),
        from: $("#from").val(),
        to: $("#to").val(),
        drivers: $("#drivers").val()
      }, function() {
        return $dlg.dialog("close");
      });
      $dlg.dialog("close");
      return e.preventDefault();
    });
  });

}).call(this);
