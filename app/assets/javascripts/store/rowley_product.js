function change_zoom_image_url() {
  var url = $('ul#product-thumbnails li:visible.vtmb').eq(0).children('input[type="hidden"]').val();
  $('#main-image p.enlarge a').attr('href', url);
}

function check_try_them_on(){
  var val = $('ul[data-hook=available-colors] li:first input').data('hto-in-stock')
  if (val == false)
  {
    $('#add-to-hto-button').hide();
  }
}

$(document).ready(function () {
  $("span.color-circle").click(function () {
    // set variant id to place into order
    var radio = $(this).parent("label").parent().find("input");
    var t = radio.val();

    $("input#product_variant_selected").val(t);
    //change selected color
    var c = $(this).next("span.variant-description").text();
    $('span[data-hook="variant-color"]').text(c);
    //set zoom image url
    // timeout need to wait while other "click" events will be done
    setTimeout(function () {
      change_zoom_image_url();
    }, 200);
    //check try them on availability
    if (radio.data('hto-in-stock') == true)
    {
      $('#add-to-hto-button').show();
    }
    else {
      $('#add-to-hto-button').hide();
    }
  });

  // bind "Enlarge" link
  $('ul#product-thumbnails li img').on('click', function () {
    var url = $(this).parents('li').children('input[type="hidden"]').val();
    $('#main-image p.enlarge a').attr('href', url);
  });
  // find first image url
  change_zoom_image_url();

  check_try_them_on();

  // attach FancyBox
  $("p.enlarge a").fancybox({
    padding: 0,
    autoSize: false,
    maxWidth: 802,
    openEffect: 'elastic',
    openSpeed: 150,
    closeEffect: 'elastic',
    closeSpeed: 150,
    closeClick: true
  });

  // add product for Try Them On
  $("#add-to-hto-button").on('click', function(){
    var f = $(this).parents('#product-description').find('#cart-form').find('form');
    $('<input>').attr({
        type: 'hidden',
        id: 'add-to-hto',
        name: 'hto',
        value: 'hto'
    }).appendTo(f);
    f.submit();
  });

})

