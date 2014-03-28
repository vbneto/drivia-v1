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
    
  $('#date_end').live "change", ->
    start = parseInt($('#date_start').find(":selected").val())
    end = parseInt($('#date_end').find(":selected").val())
    if start > end
      alert("From month can not be greater than end month")
      return
    $('#submit_date_range').click()
      
  
