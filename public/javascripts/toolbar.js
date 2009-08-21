$(function() {
  // Toolbox functions
  //
  $().mousemove(function(e){
    $('#mouse_position').html(e.pageX +', '+ e.pageY);
  }); 

  $("#save").click(function () {
    var query = new Array();

    // Make a query with all the elements' positions and sizes
    $(".element").each(function() {
      query.push([
        $(this).attr('id'),
        $(this).width(),
        $(this).height(),
        $(this).position().left,
        $(this).position().top,
        $(this).css('z-index')
      ]);
    });

    $.post('/save/' + pageName, {'elements[]': query});
  });

  $('#toolbox').draggable({ 
    handle: 'h1',
    // FIXME: is it possible to make this snap to the bottom of the window too?
    snap: 'body', 
    snapMode: 'inner' 
  });

  // Control resize aspect locking with aspect checkbox
  $('#aspect').change(function () {
    // Hackety hack. Due to bug http://dev.jqueryui.com/ticket/4186
    // I can't change the aspect ratio after create. Instead, have to
    // destroy and recreate the resizable.
    $('.element').resizable('destroy');
    $('.element').resizable({
      autoHide: true,
      aspectRatio: $(this).attr("checked"),
      start: position_changed,
      resize: position_changed
    });
  });

  $('#selected_w').keyup(function(){
    var ratio = selected.height() / selected.width();

    if ($('#aspect').attr("checked")) {
      $('#selected_h').val(Math.round($(this).val() * ratio));
    }
  });

  $('#selected_h').keyup(function(){
    var ratio = selected.width() / selected.height();

    if ($('#aspect').attr("checked")) {
      $('#selected_w').val(Math.round($(this).val() * ratio));
    }
  });

  $('.selected_coordinate').keypress(function(e) {
    if (e.which == 13) {
      this.blur();
      this.focus();
      this.select();
      return true;
    }

    // Ignore all but backspace (8), digits, dash (45, for negatives), and arrow/direction keys (0)
    if (e.which != 8 && e.which != 45 && e.which != 0 && (e.which < 48 || e.which > 57)) return false;
    return true;
  });

  $('.selected_coordinate').bind('blur', function (){
    if (!selected) return;

    selected.css({
      left: parseInt($('#selected_x').val(), 10),
      top: parseInt($('#selected_y').val(), 10),
      width: parseInt($('#selected_w').val(), 10),
      height: parseInt($('#selected_h').val(), 10),
      'z-index': parseInt($('#selected_z').val(), 10)
    });
  });
});
