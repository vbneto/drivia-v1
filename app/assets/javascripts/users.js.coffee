# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $("#select_subject").dropdownchecklist({ emptyText: "Please select subjects.", firstItemChecksAll: true, width: 190, maxDropHeight: 200, icon: {placement:'right'}})
  
  
  $("#student_list").change ->
    $.get('/users/change_student?id='+$(this).val())

  

  
  
