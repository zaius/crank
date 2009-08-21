// position_changed is defined here so it can be used in both drag
// and resize initializers
var selected = null;
var position_changed = function(event, ui) { 
  $('#selected_x').val(selected.position().left);
  $('#selected_y').val(selected.position().top);
  $('#selected_w').val(selected.width());
  $('#selected_h').val(selected.height());
  $('#selected_z').val(selected.css('z-index'));
};

$(function() {
  $('.element').addClass('editable');
  select_element(null);

  // Functions for dragging and resizing elements 
  //

  $(".element").draggable({
    grid: [10,10],
    start: position_changed,
    drag: position_changed
  });

  $(".element").resizable({
    autoHide: true,
    aspectRatio: $('#aspect').attr("checked"),
    start: position_changed,
    resize: position_changed
  });


  // Track selected element
  function select_element(element) {
    if (selected) selected.removeClass('selected');

    selected = element;
    
    if (selected == null) {
      $('.selected_coordinate').val(null);
      $('.selected_coordinate').attr({disabled: 'disabled'});
      return;
    }

    selected.addClass('selected');
    $('.selected_coordinate').removeAttr('disabled');
    position_changed();
  }

  $('.element').bind('mousedown', function () {
    select_element($(this));
  });

  $(document).bind('click', function(element) {
    // returning true passes the click to the browser
    // returning false stops further click handling
    element = $(element.target); 

    // Ignore clicks on elements and the toolbox
    if (element.closest('.element').length != 0) return true;
    if (element.closest('#toolbox').length != 0) return true;

    select_element(null);
  });
});
