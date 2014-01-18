
Deface::Override.new(:virtual_path => "spree/checkout/registration",
                     :name => "add_registration_form_to_registration_step",
                     :insert_top => "[data-hook='registration'] #new_account, #registration[data-hook] #new_account",
                     #:erb => erb,
                     :partial => "spree/shared/sign_up",
                     :disabled => true)

Deface::Override.new(:virtual_path => "spree/hto_checkout/registration",
                     :name => "add_registration_form_to_registration_step2",
                     :insert_top => "[data-hook='registration'] #new_account, #registration[data-hook] #new_account",
                     #:erb => erb,
                     :partial => "spree/shared/sign_up",
                     :disabled => true)

Deface::Override.new(:virtual_path => "spree/hto_checkout/registration",
                     :name => "auth_user_login_form",
                     :replace_contents => "[data-hook='registration'] #account, #registration[data-hook] #account",
                     :template => "spree/user_sessions/new",
                     :disabled => false,
                     :original => 'ab20ac9e90baa11b847b30040aef863d2e1af17a')

# Disable override from spree_auth_devise

Deface::Override.new(:virtual_path => "spree/checkout/registration",
                     :name => "auth_user_login_form",
                     :disabled => true,
                     :original => 'ab20ac9e90baa11b847b30040aef863d2e1af17a')
