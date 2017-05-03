$(document).on("turbolinks:load", function() {
  $(".checkboxradio input[type=checkbox]").checkboxradio({
    icon: false
  });

  $(".datepicker").datepicker({
    dateFormat: "yy-mm-dd",
    minDate: 0
  });

  //ensure that check in is before check out
  $("#check_in").on("change", function() {
    $("#check_out").datepicker("option", "minDate", $(this).datepicker("getDate"));
  });

  $("#check_out").on("change", function() {
    $("#check_in").datepicker("option", "maxDate", $(this).datepicker("getDate"));
  });
});
