//$(document).ready(function(){
//  if (!!$('.sticky').offset()) {
//    var stickyTop = $('.sticky').offset().top;
//		var footerStop =$('footer').offset().top - 200;
//
//    $(window).scroll(function(){
//      var windowTop = $(window).scrollTop();
//      if (stickyTop > windowTop){
//				$('.sticky').css({position: 'static', top: 'auto'});
//			}
//			else if (windowTop > footerStop){
//				$('.sticky').css({position: 'absolute', top :'auto', bottom: 0});
//			}
//			else {
//				$('.sticky').css({ position: 'fixed', top: 20 });
//			}
//    });
//  }
//})