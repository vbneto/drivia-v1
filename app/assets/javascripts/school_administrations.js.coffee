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

   
  $("#student_number").on "change", ->
    $("#submit_parent_filters").click()
  
  
