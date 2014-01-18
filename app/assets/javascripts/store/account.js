$(document).on("click", ".account_edit_section", function() {
  var btn = $(this),
      section_container = $(this).closest(".account_editable_section"),
      form_container = section_container.find(".account_section_edit_container"),
      show_container = section_container.find(".show-container");
  if (btn.hasClass("open")){
    form_container.hide();
    show_container.show();
    btn.find("input[type='submit']").val("Edit");
    btn.find(".icon-edit").removeClass("active");
  }
  else {
    form_container.show();
    show_container.hide();
    btn.find("input[type='submit']").val("Close");
    btn.find(".icon-edit").addClass("active");
  }
  btn.toggleClass("open");
});

function collapse_account_section_editor(s)
{
  $(s).find("input[type='submit']").val("Edit");
  $(s).find(".icon-edit").removeClass("active");
  $(s).find(".account_edit_section").removeClass("open");

}
