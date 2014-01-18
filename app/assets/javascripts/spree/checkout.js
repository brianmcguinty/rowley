//$().ready(function(){
//  $('input[id^=order_shipping_method_id_]').click(function(){
//      var value = $(this).val();
//      $.post("/checkout/update_shipping_methods",{'order[shipping_method_id]': value});
//  })
//})
$().ready(function(){
    $("#continue_checkout_place_order").click(function(){
        $("#checkout_form_order").submit();
    })
})
