$( document ).ready( function() {
  $("#evaluation-edit textarea, #evaluation-edit input[type='radio']").on('change', function() {
    var textRegEx, base, data, answer, answer_id;
    textRegEx = /\[text_response\]/;
    base = $(this).attr('name').split(textRegEx);
    data = {};
    answer = {};
    
    if (base.length < 2) {
      base = $(this).attr('name').split(/\[numeric_response\]/);
      answer.numeric_response = $(this).val();
    } else {
      answer.text_response = $(this).val();
    }
    
    data.answer = answer

    answer_id = $("input[name='" + base[0] + "[id]'").val();

    $.post("/answers/"+ answer_id +"/update", data);
  });
});

