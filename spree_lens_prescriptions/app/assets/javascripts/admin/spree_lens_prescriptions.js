$(document).on("change", ".order_lens_prescription_attributes_two_pds", function() {
  if ($(this).is(":checked")) {
    $(".two_pds").show();
    $(".one_pd").hide();
  }
  else {
    $(".two_pds").hide();
    $(".one_pd").show();
  }
});

$(document).on("change", ".order_lens_prescription_attributes_vision_type", function() {
  if ($(this).val() == 'progressive') {
    $("#wear").show();
    $(".optical_add_container").show();
  }
  else {
    $("#wear").hide();
    $(".optical_add_container").hide();
  }
});

$(document).on("change", ".lens_prescription_demo", function() {
  if ($(this).is(":checked"))
    $("#tint").hide();
  else 
    $("#tint").show();
});

$(document).on("change", ".verification_method_selector", function() {
  $(".verification_method_container").hide();
  $("#verification_" + $(this).val()).show();
});

function show_form_by_glasses_type(btn)
{
  $(".prescription_form").html("");

  $('.glasses_type').find('.open').removeClass('open');
  $(btn).closest(".glasses_type").find(".prescription-heading").addClass('open');


  $(btn).closest(".glasses_type").find(".prescription_form").html($(btn).data("form"));
  $("#order_lens_meta_prescription_attributes_glasses_type").val($(btn).data("gt"));
}

function enter_prescription_details(btn)
{
  $(btn).remove();
  $("#order_lens_meta_prescription_attributes_lens_prescription_attributes_detailed").val("1");
  $("#prescription_details_container").show();
}

$(document).on("click", ".demo_or_sunglasses", function() {
  if ($(this).val() == 'demo'){
    $('.sunglasses-with').hide();
  }
  else{
    $('.sunglasses-with').show();
  }
});