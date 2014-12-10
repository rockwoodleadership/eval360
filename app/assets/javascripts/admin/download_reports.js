$('#send-btn').on('click', function() {
  var data = {};
  data.email = $('input#email').val();
  $.post("/trainings/"+ training_id + "/email_reports", data, function() {
    window.location.reload();
  }, "html");
  //todo
});
