# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('.student_details').hide()
  $('.parent_details').hide()
  
  $("#grade").on "change", ->
    $("#submit_filters").click()
  
  $("#first_access").on "change", ->
    $("#submit_filters").click()
  
  $("#parent_number").on "change", ->
    $("#submit_filters").click()  
  
  $("#active").on "change", ->
    $("#submit_filters").click()    
  
  $("#grades").on "change", ->
    $("#submit_professor_filters").click()
   
  $("#subject").on "change", ->
    $("#submit_professor_filters").click()
  
  $("#activated").on "change", ->
    $("#submit_professor_filters").click()

  $("#first_accessed").on "change", ->
    $("#submit_professor_filters").click()

  $("#student_number").on "change", ->
    $("#submit_parent_filters").click()
    
  
  $("a[data-toggle='tab']").on "shown.bs.tab", (e) ->
    localStorage.setItem "lastTab", $(e.target).attr("href")
    
  lastTab = localStorage.getItem("lastTab")
  if lastTab
    $("#tabs a[href='"+lastTab+"']").tab "show"  
    return    
  
  
