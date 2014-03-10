# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  $("#select_id").dropdownchecklist({ emptyText: "Please select subjects.", firstItemChecksAll: true, width: 190, maxDropHeight: 200, icon: {placement:'right'}})
  return
  
