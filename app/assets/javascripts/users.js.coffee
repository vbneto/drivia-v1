# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  
  $(document).on "change", "#student_list", ->
    $("#submit_student_list").click()
  
  $("#select_subject").multiselect
    onChange: (element, checked) ->
      $("#submit_subject_list").click()
    includeSelectAllOption: true
    
  $(document).on "change", "#start_month", ->
    start_month = new Date('1 ' + $('#start_month').find(":selected").val() + ' 1999');
    end_month = new Date('1 ' + $('#end_month').find(":selected").val() + ' 1999');
    monthNames = [ "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December" ];
    start_month = start_month.getMonth()
    end_month = end_month.getMonth()
    i = end_month
    while i >= 0  
      $("#end_month option[value="+monthNames[i]+"]").prop("disabled",false);
      i--
    i = 0
    while i < start_month
      $("#end_month option[value="+monthNames[i]+"]").prop("disabled","true");
      i++
  
  $(document).on "change", "#end_month", ->
    $('#submit_date_range').click()
  
