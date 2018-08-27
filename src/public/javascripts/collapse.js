$(document).ready(function() {
  $('.collapse').on('show.bs.collapse', function(e) {
    changeIcon(e, 'glyphicon-chevron-left', 'glyphicon-chevron-down');
  });
  
  $('.collapse').on('hide.bs.collapse', function(e) {
    changeIcon(e, 'glyphicon-chevron-down', 'glyphicon-chevron-left');
  });
});

function changeIcon(e, class1, class2) {
  id = $(e.target).attr('id');
  collapseIcon = $('#icon-' + id);

  collapseIcon.removeClass(class1);
  collapseIcon.addClass(class2);
}
