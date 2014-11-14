$("#customize-link").on('click', function() {
  if ($("#customize").hasClass("hide")) {
    $("#customize-link").text("Click here to cancel reminder email customization");
    $("#customize").removeClass("hide");
  } else {
    $("#reminder-text").val("");
    $("#customize-link").text("Click here to customize the reminder email");
    $("#customize").addClass("hide");

  }
});


$("#send-reminder-btn").on('click', function() {
  var data = {};
  if (!$("#customize").hasClass("hide")) {
    data.message= $("#reminder-text").val();
  }
  $.post("/"+ participant_id + "/send_reminders", data, function() {
    window.location.reload();
  }, "html");
});
