$().ready(function(){
  var showCart = getParameterByName("show_cart");
  if (typeof showCart === 'undefined' || showCart == "" ){
    // do nothing
  } else {
    $("#shopping_cart_modal").modal();
  }
  var showHTO = getParameterByName("show_hto");
    if (typeof showHTO === 'undefined' || showHTO == "" ){
      // do nothing
    } else {
      $("#hto_cart_modal").modal();
    }
})

function getParameterByName(name)
{
  name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
  var regexS = "[\\?&]" + name + "=([^&#]*)";
  var regex = new RegExp(regexS);
  var results = regex.exec(window.location.search);
  if(results == null)
    return "";
  else
    return decodeURIComponent(results[1].replace(/\+/g, " "));
}
