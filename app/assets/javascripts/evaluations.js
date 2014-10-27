$("#evaluation-edit input[type='range']").after("<label class='output'></label>");
$("#evaluation-edit input[type='range']").after("Almost Always");
$("#evaluation-edit input[type='range']").before("<br>Not Applicable");
$input = $("input[type='range']");
var rangeValues = {
    "0": "Not Applicable",
    "1": "1 - Almost Never",
    "2": "2",
    "3": "3",
    "4": "4",
    "5": "5",
    "6": "6",
    "7": "7",
    "8": "8",
    "9": "9",
    "10": "10 - Almost Always"
};
$('#evaluation-edit .output').each(function(index) {
  $(this).text(rangeValues[$(this).siblings("input[type='range']")[0].value]);
});

$("#evaluation-edit input[type='range']").on('change', function () {
  $(this).siblings("label.output")[0].innerText = rangeValues[$(this).val()];

});

$("#evaluation-edit input[type='range']").on('change', function() {
  numRegEx = /\[numeric_response\]/;
  name = $(this).attr('name');
  base = name.split(numRegEx);
  data = {};
  answer = {};
  
  answer["numeric_response"] = $(this).val();
  
  data["answer"] = answer

  answer_id = $("input[name='" + base[0] + "[id]'").val();

  $.post("/answers/"+ answer_id +"/update", data);
});

$("#evaluation-edit textarea").on('change', function() {
  textRegEx = /\[text_response\]/;
  name = $(this).attr('name');
  base = name.split(textRegEx);
  data = {};
  answer = {};
  
  answer["text_response"] = $(this).val();
  
  data["answer"] = answer

  answer_id = $("input[name='" + base[0] + "[id]'").val();

  $.post("/answers/"+ answer_id +"/update", data);
});

