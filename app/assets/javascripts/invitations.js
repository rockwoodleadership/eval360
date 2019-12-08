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

function validateEmail(input) {
  if (!input.checkValidity()){
    $(input).addClass('invalid-email');
    $(input).closest('.email').next('.invalid-email-text').removeClass('hide');
    return false;
  } else {
    $(input).removeClass('invalid-email');
    $(input).closest('.email').next('.invalid-email-text').addClass('hide');
    return true;
  }
}


$("input[type='email']").on('change', function(e) {
  validateEmail(e.target);
});

$('form').on('submit', function(e) {
  var invalidCount = 0;
  $("input[type='email']").each( function(){
    if (!validateEmail(this)) {
      invalidCount++;
    }

  });
  if (invalidCount > 0)
    e.preventDefault();
});







