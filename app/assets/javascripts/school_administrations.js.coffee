# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('.student_details').hide()
  $('.parent_details').hide()
  
  $('#student_from_excel_student_statuses_attributes_0_current_grade').on "change", ->
    $.get "/school_administrations/grade_class_of_current_grade?current_grade="+$(this).val(), (data) ->
      $el = $("#student_from_excel_student_statuses_attributes_0_grade_class")
      $el.empty() 
      i = 0
      while i < data.length
        $el.append $("<option></option>").attr("value", data[i]).text(data[i])
        i++
      
  $("#grade").on "change", ->
    $("#submit_filters").click()
  
  $("#first_access").on "change", ->
    $("#submit_filters").click()
  
  $("#parent_number").on "change", ->
    $("#submit_filters").click()  
  
  $("#active").on "change", ->
    $("#submit_filters").click()    

  $("#student_number").on "change", ->
    $("#submit_parent_filters").click()
    
  $("a[data-toggle='tab']").on "shown.bs.tab", (e) ->
    localStorage.setItem "lastTab", $(e.target).attr("href")
    
  lastTab = localStorage.getItem("lastTab")
  if lastTab
    $("#tabs a[href='"+lastTab+"']").tab "show"  
      
  
  
