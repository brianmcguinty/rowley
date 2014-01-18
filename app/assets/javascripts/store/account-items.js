$(document).ready(function(){
     $('.view-button').click(function(e){
        e.preventDefault();
        var $this = $(this),
            speed = 500;
            if ($this.hasClass('active') === true) {
                $this.parent().parent().addClass('active').next('.box').fadeIn(speed);
                $this.addClass('active');
            } else {
                $this.parent().parent().removeClass('active').next('.box').fadeOut(speed);
                $this.removeClass('active');
            }
    });
})