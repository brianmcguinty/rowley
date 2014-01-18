$(document).on("change", ".credit_card_selector", function() {
  if ($(this).val() == "enter_new") 
    $("#new_credit_card_container").show();
  else
    $("#new_credit_card_container").hide();
});
