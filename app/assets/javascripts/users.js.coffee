# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  
  $("#student_list").live "change", ->
    $("#submit_student_list").click()
    

  $("#select_subject").dropdownchecklist
    emptyText: "Please select subjects."
    firstItemChecksAll: true
    width: 190
    maxDropHeight: 200
    icon: {placement:'right'}
     
  $('#select_subject').live "change", ->
    $("#submit_subject_list").click()
    
  $('#start_month').live "change", ->
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
    
  $('#end_month').live "change", ->
    $('#submit_date_range').click()
  
