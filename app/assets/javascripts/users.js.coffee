# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  
  $("#student_list").live "change", ->
    $.get('/users/change_student?id='+$(this).val())

  $("#select_subject").dropdownchecklist
    emptyText: "Please select subjects."
    firstItemChecksAll: true
    width: 190
    maxDropHeight: 200
    icon: {placement:'right'}
     
      
  $('#select_subject').live "change", ->
    $.get('/users/change_subjects?stid='+$("#student_list").val()+'&sub='+$(this).val())  
    
  
  new Morris.Line(
    
    # ID of the element in which to draw the chart.
    element: "myfirstchart"
    
    # Chart data records -- each entry in this array corresponds to a point on
    # the chart.
    data: [
      {
        month: "2008"
        value: 20
      }
      {
        month: "2009"
        value: 10
      }
      {
        month: "2010"
        value: 5
      }
    ]
    
    # The name of the data record attribute that contains x-values.
    xkey: "month"
    
    # A list of names of data record attributes that contain y-values.
    ykeys: ["value"]
    
    # Labels for the ykeys -- will be displayed when you hover over the
    # chart.
    labels: ["Value"]
  )
  
  
