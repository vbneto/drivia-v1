# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  
  $(document).on "change", "#student_list", ->
    $.post("/users/change_student",$("#select_student_form").serialize());
  
  $(document).on "change", "#student_status_id", ->
    $.post("/users/change_school",$("#select_school_form").serialize());
    
  $("#select_subject").multiselect
    onChange: (element, checked) ->
      $.post("/users/change_subjects",$("#select_subject_form").serialize());
    includeSelectAllOption: true
    
  $(document).on "change", "#date_year", ->
    $('#submit_date_range').click()
  
  bimesterNames = [ "1st bimester", "2nd bimester", "3rd bimester", "4th bimester" ];
  $(document).on "change", "#start_month", ->
    start_bimester = bimesterNames.indexOf($('#start_month').find(":selected").val());
    end_bimester = bimesterNames.indexOf($('#end_month').find(":selected").val());
    if end_bimester < start_bimester
      $('#end_month').val(String(bimesterNames[start_bimester]));   
    $('#submit_date_range').click()
    
  $(document).on "change", "#end_month", ->
    $('#submit_date_range').click()
    
  $(document).on "click", "#current_month", ->
    current_date = new Date();
    $('#date_year').val(current_date.getFullYear());
    $('#start_month').val(monthNames[current_date.getMonth()]);
    $('#end_month').val(monthNames[current_date.getMonth()]);
    $('#submit_date_range').click()
      
  
