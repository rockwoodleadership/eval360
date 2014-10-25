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
