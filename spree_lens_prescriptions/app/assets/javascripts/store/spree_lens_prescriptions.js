//= require store/spree_core
//= require jquery.form

// $(document).ready(function(){
//   $(".glasses_type_selector").change(function() {
//     $.post($(this).data("url"), "script");
//   });
// });

// $(document).on("change", ".glasses_type_selector", function() {
//   $(".prescription_form").html("");
//   $(this).closest(".glasses_type").find(".prescription_form").html($(this).data("form"));
// });

$(document).on("change", ".order_lens_prescription_attributes_two_pds", function() {
  var form = $(this).closest("form");
  if ($(this).is(":checked")) {
    form.find(".two_pds").show();
    form.find(".one_pd").hide();
  }
  else {
    form.find(".two_pds").hide();
    form.find(".one_pd").show();
  }
});

$(document).on("change", ".order_lens_prescription_attributes_vision_type", function() {
  var form = $(this).closest("form");
  if ($(this).val() == 'progressive'){
    form.find("#wear").show();
    form.find(".optical_add_container").show();
    var selector = $(this)
    selector.popover("show");
    setTimeout(function() {selector.popover("hide");}, 7000);
  }
  else {
    form.find("#wear").hide();
    form.find(".optical_add_container").hide();
  }
});

$(document).on("change", ".lens_prescription_demo", function() {
  var form = $(this).closest("form");
  if ($(this).is(":checked"))
    form.find("#tint").hide();
  else 
    form.find("#tint").show();
});

$(document).on("change", ".order_lens_meta_prescription_attributes_lens_prescription_attributes_state_id", function() {
  var form = $(this).closest("form");
  if ($(this).find("option[value=" + $(this).val() + "]").data("doctor-verification") == "1") {
    form.find("#verification").show();
  }
  else {
    form.find("#verification").hide();
  }
});

$(document).on("change", ".verification_method_selector", function() {
  var form = $(this).closest("form");
  form.find(".verification_method_container").hide();
  form.find("#verification_" + $(this).val()).show();
});

$(document).on("change", ".input_method_selector", function() {
  var form = $(this).closest("form");
  form.find(".input_method_container").html("");
  $(this).closest(".input_method").find(".input_method_container").html($(this).data("form"));
  checkout_update_order_summary(this);
  form.find('.birthpicker').datepicker();  
  form.find('[data-toggle="popover"]').popover({"original-title": '', 'html': true});
  form.find(".stored_prescription_popover").popover({ trigger: "hover", html: true });
});

function show_form_by_glasses_type(btn)
{
  $(".prescription_form").hide();

  $(".glasses_type").find(".open").removeClass("open");
  $(btn).closest(".glasses_type").find(".prescription-heading").addClass('open');

  $(btn).closest(".glasses_type").find(".prescription_form").show();

  checkout_update_order_summary(btn);

  //   $('.birthpicker').datepicker();
  //   $('[data-toggle="popover"]').popover({"original-title": '',  'html': true})
}

$(document).on("change", ".order_lens_meta_prescription_attributes_purchase_subscription_yes_no", function() {
  var form = $(this).closest("form");
  if ($(this).val() == 'yes')
    form.find(".subscription_fields").show();
  else
    form.find(".subscription_fields").hide();
});

$(document).on("change", ".forced_thin_arg", function() {
  var form = $(this).closest("form");
  var right_sph = parseFloat(form.find("#optical_right_sph").val()),
      right_cyl = parseFloat(form.find("#optical_right_cyl").val()),
      left_sph = parseFloat(form.find("#optical_left_sph").val()),
      left_cyl = parseFloat(form.find("#optical_left_cyl").val());
  var min_sph = -4.001, max_sph = 4.001, min_cyl = -2.001;
  var forced_thin = right_sph < min_sph || left_sph < min_sph ||
    right_sph > max_sph || left_sph > max_sph ||
    right_cyl < min_cyl || left_cyl < min_cyl;
  if (forced_thin)
    form.find(".optical_lens_type").val("thin").find("option[value='standard']").prop('disabled', true);
  else
    form.find(".optical_lens_type").find("option[value='standard']").prop('disabled', false);
});

$(function() {
  $('.birthpicker').datepicker();  
});

$(document).on("change", ".refresh_totals", function() {
  checkout_update_order_summary(this);
});

function checkout_update_order_summary(b)
{
  $(b).closest(".glasses_type").find("form").ajaxSubmit();
}

$(document).ready(function(){
  $(".stored_prescription_popover").popover({ trigger: "hover", html: true });
});

$(document).on("click", ".demo_or_sunglasses", function() {
  if ($(this).val() == 'demo'){
    $('.sunglasses-with').hide();
  }
  else{
    $('.sunglasses-with').show();
  }
});
