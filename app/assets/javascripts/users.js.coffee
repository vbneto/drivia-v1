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
  
  $("option", $("#select_subject")).each (element) ->
    $("#select_subject").multiselect "select", $(this).val()
    
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
    
  $(document).on "click", "#current_bimester", ->
    current_bimester = $('#end_month option:last-child').val();
    $('#start_month').val(current_bimester);
    $('#end_month').val(current_bimester);
    $('#submit_date_range').click()
  
  $('.loading').hide();
  $(document).ajaxStart ->
    $(this).find('.loading').show()
  
  $(document).ajaxStop ->
    $(this).find('.loading').hide()
  
