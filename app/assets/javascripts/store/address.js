$(document).ready(function(){
  var open = $('.open'),
  a = $('ul').find('a');

  //console.log(a.hasClass('active'));

  open.click(function(e){
    e.preventDefault();
    var $this = $(this),
    speed = 500;
    if($this.hasClass('active') === true) {
      $this.removeClass('active').next('.box').fadeOut(speed);
    } else if(a.hasClass('active') === false) {
      $this.addClass('active').next('.box').fadeIn(speed);
    } else {
      a.removeClass('active').next('.box').fadeOut(speed);
      $this.addClass('active').next('.box').delay(speed).fadeIn(speed);
    }
  });
});
