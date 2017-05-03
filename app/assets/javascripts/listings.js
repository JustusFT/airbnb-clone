$(document).on("turbolinks:load ready", function() {
  $(".checkboxradio input[type=checkbox]").checkboxradio({
    icon: false
  });

  //
  // INDEX
  //
  $(".filter-datepicker").datepicker({
    dateFormat: "yy-mm-dd",
    minDate: 0
  });

  // ensure that check in is before check out
  $("#check_in").on("change", function() {
    $("#check_out").datepicker("option", "minDate", $(this).datepicker("getDate"));
  });

  $("#check_out").on("change", function() {
    $("#check_in").datepicker("option", "maxDate", $(this).datepicker("getDate"));
  });

  //
  // NEW
  //
  var current_date = new Date;
  // convert array of taken dates above to JS
  var takenDates = $("#data-attributes").data("taken-dates");
  var listingPrice = $("#data-attributes").data("listing-price");

  // getter functions for dates
  var checkInDate = function() {
    return $("#check_in").datepicker("getDate");
  }
  var checkOutDate = function() {
    return $("#check_out").datepicker("getDate");
  }

  // destroy previous datePicker setup, so that you can reset the valid dates
  $(".booking-datepicker").datepicker( "destroy" );
  $(".booking-datepicker").datepicker({
    dateFormat: "yy-mm-dd",
    minDate: 0,
    beforeShowDay: function(date) {
      var string = $.datepicker.formatDate('yy-mm-dd', date);
      return [takenDates.indexOf(string) === -1];
    }
  }).on("change", function() {
    // display pricing of date range
    var date_difference = (checkOutDate() - checkInDate()) / (1000 * 3600 * 24);
    if (checkInDate() === null || checkOutDate() === null) return;
    $("#total-price").html("$" + listingPrice * date_difference);
  });

});
