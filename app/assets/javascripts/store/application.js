$(function () {

  $('.accordion').on('show', function (e) {
    $(e.target).prev('.accordion-heading').find('.accordion-toggle').addClass('active');
  });

  $('.accordion').on('hide', function (e) {
    $(this).find('.accordion-toggle').not($(e.target)).removeClass('active');
  });

});

function select_topic_faq(url) {
  $('.faq-accordion').find('.show').removeClass('show');
  $(url).addClass('show');
  $('.faq-sidenav li').removeClass('active');
  $('.faq-sidenav').find($("a[href=" + url + "]")).parent().addClass('active');
}

$(function () {

  $(".faq-sidenav a").click(function () {
    var url = $(this).attr("href");
    select_topic_faq(url);
  });

  $(".faq-accordion .accordion-inner a.here").click(function () {
    var url = $(this).attr("href");
    select_topic_faq(url);
  });

  $(".faq-footer-link").click(function () {
    var url = $(this).attr("href").replace("/help_faq", "");
    select_topic_faq(url);
  });

  // detect FAQ page and set proper topic after page loaded
  var current_url = $.url();
  if (current_url.segment(-1) == 'help_faq'){
    var segment = current_url.fsegment(1)
    if (typeof segment === 'undefined' || segment == ''){
      segment = 'faq_frame';
    }
    select_topic_faq("#"+segment);
  }

  setTimeout(function () {
    $('#checkout-summary').affix({ offset: { top: function
        () {
      return $(window).width() <= 980 ? 300 : 300
    }, bottom: 300 } })
  }, 100)

  setTimeout(function () {
    $('#product-description').affix({ offset: { top: function
        () {
      return $(window).width() <= 980 ? 159 : 159
    }, bottom: 280 } })
  }, 100)

}); 



