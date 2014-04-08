# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  
  $(document).on "change", "#student_list", ->
    $("#submit_student_list").click()
  
  $("#select_subject").multiselect
    onChange: (element, checked) ->
      $.post("/users/change_subjects",$("#select_subject_form").serialize());
    includeSelectAllOption: true
    
  $(document).on "change", "#date_year", ->
    $('#submit_date_range').click()
    
  $(document).on "change", "#start_month", ->
    monthNames = [ "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December" ];
    start_month = monthNames.indexOf($('#start_month').find(":selected").val());
    end_month = monthNames.indexOf($('#end_month').find(":selected").val());
    i = end_month
    while i >= 0  
      $("#end_month option[value="+monthNames[i]+"]").prop("disabled",false);
      i--
    i = 0
    while i < start_month
      $("#end_month option[value="+monthNames[i]+"]").prop("disabled","true");
      i++

    if end_month < start_month
      $('#end_month').val(monthNames[start_month]);   
    $('#submit_date_range').click()
    
    $(document).on "change", "#end_month", ->
      $('#submit_date_range').click()
  
