# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20131122151656) do

  create_table "product_customization_types_products", :id => false, :force => true do |t|
    t.integer "product_customization_type_id"
    t.integer "product_id"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "spree_activators", :force => true do |t|
    t.string   "description"
    t.datetime "expires_at"
    t.datetime "starts_at"
    t.string   "name"
    t.string   "event_name"
    t.string   "type"
    t.integer  "usage_limit"
    t.string   "match_policy", :default => "all"
    t.string   "code"
    t.boolean  "advertise",    :default => false
    t.string   "path"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  create_table "spree_ad_hoc_option_types", :force => true do |t|
    t.integer  "product_id"
    t.integer  "option_type_id"
    t.string   "price_modifier_type"
    t.boolean  "is_required",         :default => false
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.integer  "position",            :default => 0
  end

  create_table "spree_ad_hoc_option_values", :force => true do |t|
    t.integer  "ad_hoc_option_type_id"
    t.integer  "option_value_id"
    t.decimal  "price_modifier",        :precision => 8, :scale => 2, :default => 0.0, :null => false
    t.datetime "created_at",                                                           :null => false
    t.datetime "updated_at",                                                           :null => false
    t.integer  "position"
    t.boolean  "selected"
  end

  create_table "spree_ad_hoc_option_values_line_items", :force => true do |t|
    t.integer  "line_item_id"
    t.integer  "ad_hoc_option_value_id"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  create_table "spree_ad_hoc_variant_exclusions", :force => true do |t|
    t.integer  "product_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "spree_addresses", :force => true do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "zipcode"
    t.string   "phone"
    t.string   "state_name"
    t.string   "alternative_phone"
    t.string   "company"
    t.integer  "state_id"
    t.integer  "country_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "email"
  end

  add_index "spree_addresses", ["firstname"], :name => "index_addresses_on_firstname"
  add_index "spree_addresses", ["lastname"], :name => "index_addresses_on_lastname"

  create_table "spree_adjustments", :force => true do |t|
    t.integer  "source_id"
    t.string   "source_type"
    t.integer  "adjustable_id"
    t.string   "adjustable_type"
    t.integer  "originator_id"
    t.string   "originator_type"
    t.decimal  "amount",          :precision => 8, :scale => 2
    t.string   "label"
    t.boolean  "mandatory"
    t.boolean  "locked"
    t.boolean  "eligible",                                      :default => true
    t.datetime "created_at",                                                      :null => false
    t.datetime "updated_at",                                                      :null => false
  end

  add_index "spree_adjustments", ["adjustable_id"], :name => "index_adjustments_on_order_id"

  create_table "spree_assets", :force => true do |t|
    t.integer  "viewable_id"
    t.string   "viewable_type"
    t.integer  "attachment_width"
    t.integer  "attachment_height"
    t.integer  "attachment_file_size"
    t.integer  "position"
    t.string   "attachment_content_type"
    t.string   "attachment_file_name"
    t.string   "type",                    :limit => 75
    t.datetime "attachment_updated_at"
    t.text     "alt"
    t.boolean  "try_on_photo",                          :default => false
    t.boolean  "vto_image",                             :default => false
  end

  add_index "spree_assets", ["viewable_id"], :name => "index_assets_on_viewable_id"
  add_index "spree_assets", ["viewable_type", "type"], :name => "index_assets_on_viewable_type_and_type"

  create_table "spree_banner_boxes", :force => true do |t|
    t.string   "presentation"
    t.string   "url"
    t.string   "category"
    t.integer  "position"
    t.boolean  "enabled",                 :default => false
    t.string   "attachment_content_type"
    t.string   "attachment_file_name"
    t.datetime "attachment_updated_at"
    t.integer  "attachment_width"
    t.integer  "attachment_height"
    t.integer  "attachment_size"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
  end

  create_table "spree_calculators", :force => true do |t|
    t.string   "type"
    t.integer  "calculable_id"
    t.string   "calculable_type"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "spree_configurations", :force => true do |t|
    t.string   "name"
    t.string   "type",       :limit => 50
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "spree_configurations", ["name", "type"], :name => "index_spree_configurations_on_name_and_type"

  create_table "spree_countries", :force => true do |t|
    t.string  "iso_name"
    t.string  "iso"
    t.string  "iso3"
    t.string  "name"
    t.integer "numcode"
    t.boolean "states_required", :default => true
  end

  create_table "spree_credit_cards", :force => true do |t|
    t.string   "month"
    t.string   "year"
    t.string   "cc_type"
    t.string   "last_digits"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "start_month"
    t.string   "start_year"
    t.string   "issue_number"
    t.integer  "address_id"
    t.string   "gateway_customer_profile_id"
    t.string   "gateway_payment_profile_id"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.string   "encrypted_stored_number"
    t.string   "encrypted_stored_verification_value"
  end

  create_table "spree_cross_login_tokens", :force => true do |t|
    t.string   "value"
    t.integer  "user_id"
    t.datetime "expire_at"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.datetime "used_at"
  end

  add_index "spree_cross_login_tokens", ["user_id"], :name => "index_spree_cross_login_tokens_on_user_id"
  add_index "spree_cross_login_tokens", ["value"], :name => "index_spree_cross_login_tokens_on_value"

  create_table "spree_customizable_product_options", :force => true do |t|
    t.integer  "product_customization_type_id"
    t.integer  "position"
    t.string   "presentation",                  :null => false
    t.string   "name",                          :null => false
    t.string   "description"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "spree_customized_product_options", :force => true do |t|
    t.integer  "product_customization_id"
    t.integer  "customizable_product_option_id"
    t.string   "value"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.string   "customization_image"
  end

  create_table "spree_excluded_ad_hoc_option_values", :force => true do |t|
    t.integer "ad_hoc_variant_exclusion_id"
    t.integer "ad_hoc_option_value_id"
  end

  create_table "spree_feedback_reviews", :force => true do |t|
    t.integer  "user_id"
    t.integer  "review_id",                    :null => false
    t.integer  "rating",     :default => 0
    t.text     "comment"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.string   "locale",     :default => "en"
  end

  add_index "spree_feedback_reviews", ["review_id"], :name => "index_feedback_reviews_on_review_id"
  add_index "spree_feedback_reviews", ["user_id"], :name => "index_feedback_reviews_on_user_id"

  create_table "spree_gateways", :force => true do |t|
    t.string   "type"
    t.string   "name"
    t.text     "description"
    t.boolean  "active",      :default => true
    t.string   "environment", :default => "development"
    t.string   "server",      :default => "test"
    t.boolean  "test_mode",   :default => true
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  create_table "spree_inventory_units", :force => true do |t|
    t.integer  "lock_version",            :default => 0
    t.string   "state"
    t.integer  "variant_id"
    t.integer  "order_id"
    t.integer  "shipment_id"
    t.integer  "return_authorization_id"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "spree_inventory_units", ["order_id"], :name => "index_inventory_units_on_order_id"
  add_index "spree_inventory_units", ["shipment_id"], :name => "index_inventory_units_on_shipment_id"
  add_index "spree_inventory_units", ["variant_id"], :name => "index_inventory_units_on_variant_id"

  create_table "spree_lens_meta_prescriptions", :force => true do |t|
    t.string   "glasses_type"
    t.string   "prescription_input_method"
    t.string   "tint"
    t.decimal  "strength",                  :precision => 10, :scale => 2
    t.integer  "user_lens_prescription_id"
    t.datetime "created_at",                                                                 :null => false
    t.datetime "updated_at",                                                                 :null => false
    t.boolean  "demo",                                                     :default => true
    t.integer  "order_id"
    t.string   "purchase_subscription"
    t.integer  "subscription_id"
    t.string   "polarized"
    t.string   "state"
  end

  add_index "spree_lens_meta_prescriptions", ["order_id"], :name => "index_spree_lens_meta_prescriptions_on_order_id"
  add_index "spree_lens_meta_prescriptions", ["state"], :name => "index_spree_lens_meta_prescriptions_on_state"
  add_index "spree_lens_meta_prescriptions", ["subscription_id"], :name => "index_spree_lens_meta_prescriptions_on_subscription_id"
  add_index "spree_lens_meta_prescriptions", ["user_lens_prescription_id"], :name => "index_spree_lens_meta_prescriptions_on_user_lens_prescription_id"

  create_table "spree_lens_prescriptions", :force => true do |t|
    t.decimal  "left_sph",                    :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "left_cyl",                    :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "left_axis",                   :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "left_add",                    :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "left_pd",                     :precision => 10, :scale => 2, :default => 30.0
    t.decimal  "right_sph",                   :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "right_cyl",                   :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "right_axis",                  :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "right_add",                   :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "right_pd",                    :precision => 10, :scale => 2, :default => 30.0
    t.decimal  "pd",                          :precision => 10, :scale => 2, :default => 60.0
    t.datetime "created_at",                                                                    :null => false
    t.datetime "updated_at",                                                                    :null => false
    t.string   "vision_type"
    t.string   "wear"
    t.integer  "prescription_container_id"
    t.string   "prescription_container_type"
    t.boolean  "two_pds",                                                    :default => false
    t.string   "tint"
    t.boolean  "transition"
    t.integer  "state_id"
    t.string   "verification_method"
    t.string   "lens_type"
    t.string   "doctor_name"
    t.string   "doctor_phone"
    t.string   "patient_name"
    t.date     "patient_birth_date"
    t.string   "name"
    t.string   "uploaded_copy_file_name"
    t.string   "uploaded_copy_content_type"
    t.integer  "uploaded_copy_file_size"
    t.datetime "uploaded_copy_updated_at"
    t.boolean  "detailed",                                                   :default => false
    t.string   "polarized"
  end

  add_index "spree_lens_prescriptions", ["detailed"], :name => "index_spree_lens_prescriptions_on_detailed"
  add_index "spree_lens_prescriptions", ["prescription_container_id"], :name => "index_spree_lens_prescriptions_on_prescription_container_id"

  create_table "spree_line_items", :force => true do |t|
    t.integer  "variant_id"
    t.integer  "order_id"
    t.integer  "quantity",                                 :null => false
    t.decimal  "price",      :precision => 8, :scale => 2, :null => false
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.string   "currency"
  end

  add_index "spree_line_items", ["order_id"], :name => "index_spree_line_items_on_order_id"
  add_index "spree_line_items", ["variant_id"], :name => "index_spree_line_items_on_variant_id"

  create_table "spree_log_entries", :force => true do |t|
    t.integer  "source_id"
    t.string   "source_type"
    t.text     "details"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "spree_mail_methods", :force => true do |t|
    t.string   "environment"
    t.boolean  "active",      :default => true
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "spree_option_types", :force => true do |t|
    t.string   "name",         :limit => 100
    t.string   "presentation", :limit => 100
    t.integer  "position",                    :default => 0, :null => false
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
  end

  create_table "spree_option_types_prototypes", :id => false, :force => true do |t|
    t.integer "prototype_id"
    t.integer "option_type_id"
  end

  create_table "spree_option_values", :force => true do |t|
    t.integer  "position"
    t.string   "name"
    t.string   "presentation"
    t.integer  "option_type_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "spree_option_values_variants", :id => false, :force => true do |t|
    t.integer "variant_id"
    t.integer "option_value_id"
  end

  add_index "spree_option_values_variants", ["variant_id", "option_value_id"], :name => "index_option_values_variants_on_variant_id_and_option_value_id"
  add_index "spree_option_values_variants", ["variant_id"], :name => "index_spree_option_values_variants_on_variant_id"

  create_table "spree_order_subscription_discounts", :force => true do |t|
    t.integer  "order_id"
    t.integer  "subscription_id"
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
    t.decimal  "discount_percent", :precision => 10, :scale => 2
  end

  add_index "spree_order_subscription_discounts", ["order_id"], :name => "index_spree_order_subscription_discounts_on_order_id"
  add_index "spree_order_subscription_discounts", ["subscription_id"], :name => "index_spree_order_subscription_discounts_on_subscription_id"

  create_table "spree_orders", :force => true do |t|
    t.string   "number",                    :limit => 15
    t.decimal  "item_total",                              :precision => 8, :scale => 2, :default => 0.0,   :null => false
    t.decimal  "total",                                   :precision => 8, :scale => 2, :default => 0.0,   :null => false
    t.string   "state"
    t.decimal  "adjustment_total",                        :precision => 8, :scale => 2, :default => 0.0,   :null => false
    t.integer  "user_id"
    t.datetime "completed_at"
    t.integer  "bill_address_id"
    t.integer  "ship_address_id"
    t.decimal  "payment_total",                           :precision => 8, :scale => 2, :default => 0.0
    t.integer  "shipping_method_id"
    t.string   "shipment_state"
    t.string   "payment_state"
    t.string   "email"
    t.text     "special_instructions"
    t.datetime "created_at",                                                                               :null => false
    t.datetime "updated_at",                                                                               :null => false
    t.string   "currency"
    t.string   "last_ip_address"
    t.integer  "store_id"
    t.datetime "locked_at"
    t.integer  "locked_by"
    t.boolean  "subscribe_to_news",                                                     :default => true
    t.boolean  "hto",                                                                   :default => false
    t.string   "hto_state"
    t.boolean  "hto_disabled_auto_capture",                                             :default => false
  end

  add_index "spree_orders", ["hto"], :name => "index_spree_orders_on_hto"
  add_index "spree_orders", ["locked_at"], :name => "index_spree_orders_on_locked_at"
  add_index "spree_orders", ["locked_by"], :name => "index_spree_orders_on_locked_by"
  add_index "spree_orders", ["number"], :name => "index_spree_orders_on_number"

  create_table "spree_pages", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.string   "slug"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.boolean  "show_in_header",           :default => false, :null => false
    t.boolean  "show_in_footer",           :default => false, :null => false
    t.string   "foreign_link"
    t.integer  "position",                 :default => 1,     :null => false
    t.boolean  "visible",                  :default => true
    t.string   "meta_keywords"
    t.string   "meta_description"
    t.string   "layout"
    t.boolean  "show_in_sidebar",          :default => false, :null => false
    t.string   "meta_title"
    t.boolean  "render_layout_as_partial", :default => false
  end

  add_index "spree_pages", ["slug"], :name => "index_pages_on_slug"

  create_table "spree_payment_methods", :force => true do |t|
    t.string   "type"
    t.string   "name"
    t.text     "description"
    t.boolean  "active",      :default => true
    t.string   "environment", :default => "development"
    t.datetime "deleted_at"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "display_on"
  end

  create_table "spree_payments", :force => true do |t|
    t.decimal  "amount",            :precision => 8, :scale => 2, :default => 0.0, :null => false
    t.integer  "order_id"
    t.integer  "source_id"
    t.string   "source_type"
    t.integer  "payment_method_id"
    t.string   "state"
    t.string   "response_code"
    t.string   "avs_response"
    t.datetime "created_at",                                                       :null => false
    t.datetime "updated_at",                                                       :null => false
    t.string   "identifier"
  end

  create_table "spree_preferences", :force => true do |t|
    t.text     "value"
    t.string   "key"
    t.string   "value_type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "spree_preferences", ["key"], :name => "index_spree_preferences_on_key", :unique => true

  create_table "spree_prices", :force => true do |t|
    t.integer "variant_id",                               :null => false
    t.decimal "amount",     :precision => 8, :scale => 2
    t.string  "currency"
  end

  create_table "spree_product_customization_types", :force => true do |t|
    t.string   "name"
    t.string   "presentation"
    t.string   "description"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "spree_product_customizations", :force => true do |t|
    t.integer  "line_item_id"
    t.integer  "product_customization_type_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "spree_product_option_types", :force => true do |t|
    t.integer  "position"
    t.integer  "product_id"
    t.integer  "option_type_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "spree_product_properties", :force => true do |t|
    t.string   "value"
    t.integer  "product_id"
    t.integer  "property_id"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.integer  "position",    :default => 0
  end

  add_index "spree_product_properties", ["product_id"], :name => "index_product_properties_on_product_id"

  create_table "spree_products", :force => true do |t|
    t.string   "name",                                               :default => "",    :null => false
    t.text     "description"
    t.datetime "available_on"
    t.datetime "deleted_at"
    t.string   "permalink"
    t.string   "meta_description"
    t.string   "meta_keywords"
    t.integer  "tax_category_id"
    t.integer  "shipping_category_id"
    t.integer  "count_on_hand",                                      :default => 0
    t.datetime "created_at",                                                            :null => false
    t.datetime "updated_at",                                                            :null => false
    t.boolean  "on_demand",                                          :default => false
    t.decimal  "avg_rating",           :precision => 7, :scale => 5, :default => 0.0,   :null => false
    t.integer  "reviews_count",                                      :default => 0,     :null => false
    t.boolean  "featured",                                           :default => false
    t.integer  "sort_order"
    t.boolean  "is_new",                                             :default => false
    t.integer  "hto_count_on_hand",                                  :default => 0
    t.string   "ebay_item_id"
  end

  add_index "spree_products", ["available_on"], :name => "index_spree_products_on_available_on"
  add_index "spree_products", ["deleted_at"], :name => "index_spree_products_on_deleted_at"
  add_index "spree_products", ["name"], :name => "index_spree_products_on_name"
  add_index "spree_products", ["permalink"], :name => "index_spree_products_on_permalink"

  create_table "spree_products_promotion_rules", :id => false, :force => true do |t|
    t.integer "product_id"
    t.integer "promotion_rule_id"
  end

  add_index "spree_products_promotion_rules", ["product_id"], :name => "index_products_promotion_rules_on_product_id"
  add_index "spree_products_promotion_rules", ["promotion_rule_id"], :name => "index_products_promotion_rules_on_promotion_rule_id"

  create_table "spree_products_stores", :id => false, :force => true do |t|
    t.integer "product_id"
    t.integer "store_id"
  end

  add_index "spree_products_stores", ["product_id"], :name => "index_products_stores_on_product_id"
  add_index "spree_products_stores", ["store_id"], :name => "index_products_stores_on_store_id"

  create_table "spree_products_taxons", :id => false, :force => true do |t|
    t.integer "product_id"
    t.integer "taxon_id"
  end

  add_index "spree_products_taxons", ["product_id"], :name => "index_spree_products_taxons_on_product_id"
  add_index "spree_products_taxons", ["taxon_id"], :name => "index_spree_products_taxons_on_taxon_id"

  create_table "spree_promotion_action_line_items", :force => true do |t|
    t.integer "promotion_action_id"
    t.integer "variant_id"
    t.integer "quantity",            :default => 1
  end

  create_table "spree_promotion_actions", :force => true do |t|
    t.integer "activator_id"
    t.integer "position"
    t.string  "type"
  end

  create_table "spree_promotion_rules", :force => true do |t|
    t.integer  "activator_id"
    t.integer  "user_id"
    t.integer  "product_group_id"
    t.string   "type"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "spree_promotion_rules", ["product_group_id"], :name => "index_promotion_rules_on_product_group_id"
  add_index "spree_promotion_rules", ["user_id"], :name => "index_promotion_rules_on_user_id"

  create_table "spree_promotion_rules_stores", :id => false, :force => true do |t|
    t.integer "promotion_rule_id"
    t.integer "store_id"
  end

  create_table "spree_promotion_rules_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "promotion_rule_id"
  end

  add_index "spree_promotion_rules_users", ["promotion_rule_id"], :name => "index_promotion_rules_users_on_promotion_rule_id"
  add_index "spree_promotion_rules_users", ["user_id"], :name => "index_promotion_rules_users_on_user_id"

  create_table "spree_properties", :force => true do |t|
    t.string   "name"
    t.string   "presentation", :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "spree_properties_prototypes", :id => false, :force => true do |t|
    t.integer "prototype_id"
    t.integer "property_id"
  end

  create_table "spree_prototypes", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "spree_return_authorizations", :force => true do |t|
    t.string   "number"
    t.string   "state"
    t.decimal  "amount",     :precision => 8, :scale => 2, :default => 0.0, :null => false
    t.integer  "order_id"
    t.text     "reason"
    t.datetime "created_at",                                                :null => false
    t.datetime "updated_at",                                                :null => false
  end

  create_table "spree_reviews", :force => true do |t|
    t.integer  "product_id"
    t.string   "name"
    t.string   "location"
    t.integer  "rating"
    t.text     "title"
    t.text     "review"
    t.boolean  "approved",   :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.integer  "user_id"
    t.string   "ip_address"
    t.string   "locale",     :default => "en"
  end

  create_table "spree_roles", :force => true do |t|
    t.string "name"
  end

  create_table "spree_roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  add_index "spree_roles_users", ["role_id"], :name => "index_spree_roles_users_on_role_id"
  add_index "spree_roles_users", ["user_id"], :name => "index_spree_roles_users_on_user_id"

  create_table "spree_shipments", :force => true do |t|
    t.string   "tracking"
    t.string   "number"
    t.decimal  "cost",               :precision => 8, :scale => 2
    t.datetime "shipped_at"
    t.integer  "order_id"
    t.integer  "shipping_method_id"
    t.integer  "address_id"
    t.string   "state"
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
  end

  add_index "spree_shipments", ["number"], :name => "index_shipments_on_number"

  create_table "spree_shipping_categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "spree_shipping_methods", :force => true do |t|
    t.string   "name"
    t.integer  "zone_id"
    t.string   "display_on"
    t.integer  "shipping_category_id"
    t.boolean  "match_none"
    t.boolean  "match_all"
    t.boolean  "match_one"
    t.datetime "deleted_at"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "spree_skrill_transactions", :force => true do |t|
    t.string   "email"
    t.float    "amount"
    t.string   "currency"
    t.integer  "transaction_id"
    t.integer  "customer_id"
    t.string   "payment_type"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "spree_state_changes", :force => true do |t|
    t.string   "name"
    t.string   "previous_state"
    t.integer  "stateful_id"
    t.integer  "user_id"
    t.string   "stateful_type"
    t.string   "next_state"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "spree_states", :force => true do |t|
    t.string  "name"
    t.string  "abbr"
    t.integer "country_id"
    t.boolean "doctor_verification", :default => false
  end

  create_table "spree_store_credits", :force => true do |t|
    t.integer  "user_id"
    t.decimal  "amount",           :precision => 8, :scale => 2, :default => 0.0, :null => false
    t.decimal  "remaining_amount", :precision => 8, :scale => 2, :default => 0.0, :null => false
    t.string   "reason"
    t.datetime "created_at",                                                      :null => false
    t.datetime "updated_at",                                                      :null => false
  end

  create_table "spree_store_payment_methods", :force => true do |t|
    t.integer  "store_id"
    t.integer  "payment_method_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "spree_store_shipping_methods", :force => true do |t|
    t.integer  "store_id"
    t.integer  "shipping_method_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "spree_store_shipping_methods", ["shipping_method_id"], :name => "index_spree_store_shipping_methods_on_shipping_method_id"
  add_index "spree_store_shipping_methods", ["store_id"], :name => "index_spree_store_shipping_methods_on_store_id"

  create_table "spree_stores", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.text     "domains"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.boolean  "default",          :default => false
    t.string   "email"
    t.string   "logo_file_name"
    t.string   "default_currency"
  end

  create_table "spree_subscriptions", :force => true do |t|
    t.integer  "user_id"
    t.string   "period"
    t.string   "status",              :default => "active"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "arb_subscription_id"
    t.text     "response_text"
    t.integer  "credit_card_id"
  end

  add_index "spree_subscriptions", ["credit_card_id"], :name => "index_spree_subscriptions_on_credit_card_id"
  add_index "spree_subscriptions", ["user_id"], :name => "index_spree_subscriptions_on_user_id"

  create_table "spree_tax_categories", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.boolean  "is_default",  :default => false
    t.datetime "deleted_at"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "spree_tax_rates", :force => true do |t|
    t.decimal  "amount",             :precision => 8, :scale => 5
    t.integer  "zone_id"
    t.integer  "tax_category_id"
    t.boolean  "included_in_price",                                :default => false
    t.datetime "created_at",                                                          :null => false
    t.datetime "updated_at",                                                          :null => false
    t.string   "name"
    t.boolean  "show_rate_in_label",                               :default => true
  end

  create_table "spree_taxonomies", :force => true do |t|
    t.string   "name",                      :null => false
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.integer  "position",   :default => 0
    t.integer  "store_id"
  end

  add_index "spree_taxonomies", ["store_id"], :name => "index_spree_taxonomies_on_store_id"

  create_table "spree_taxons", :force => true do |t|
    t.integer  "parent_id"
    t.integer  "position",          :default => 0
    t.string   "name",                             :null => false
    t.string   "permalink"
    t.integer  "taxonomy_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.string   "icon_file_name"
    t.string   "icon_content_type"
    t.integer  "icon_file_size"
    t.datetime "icon_updated_at"
    t.text     "description"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  add_index "spree_taxons", ["parent_id"], :name => "index_taxons_on_parent_id"
  add_index "spree_taxons", ["permalink"], :name => "index_taxons_on_permalink"
  add_index "spree_taxons", ["taxonomy_id"], :name => "index_taxons_on_taxonomy_id"

  create_table "spree_tokenized_permissions", :force => true do |t|
    t.integer  "permissable_id"
    t.string   "permissable_type"
    t.string   "token"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "spree_tokenized_permissions", ["permissable_id", "permissable_type"], :name => "index_tokenized_name_and_type"

  create_table "spree_trackers", :force => true do |t|
    t.string   "environment"
    t.string   "analytics_id"
    t.boolean  "active",       :default => true
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.integer  "store_id"
  end

  create_table "spree_users", :force => true do |t|
    t.string   "encrypted_password",      :limit => 128
    t.string   "password_salt",           :limit => 128
    t.string   "email"
    t.string   "remember_token"
    t.string   "persistence_token"
    t.string   "reset_password_token"
    t.string   "perishable_token"
    t.integer  "sign_in_count",                          :default => 0,     :null => false
    t.integer  "failed_attempts",                        :default => 0,     :null => false
    t.datetime "last_request_at"
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "login"
    t.integer  "ship_address_id"
    t.integer  "bill_address_id"
    t.string   "authentication_token"
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "reset_password_sent_at"
    t.datetime "created_at",                                                :null => false
    t.datetime "updated_at",                                                :null => false
    t.string   "spree_api_key",           :limit => 48
    t.datetime "remember_created_at"
    t.boolean  "is_mail_list_subscriber",                :default => false, :null => false
    t.string   "mailchimp_subscriber_id"
    t.string   "firstname"
    t.string   "lastname"
  end

  add_index "spree_users", ["email"], :name => "email_idx_unique", :unique => true

  create_table "spree_variants", :force => true do |t|
    t.string   "sku",                                              :default => "",    :null => false
    t.decimal  "weight",             :precision => 8, :scale => 2
    t.decimal  "height",             :precision => 8, :scale => 2
    t.decimal  "width",              :precision => 8, :scale => 2
    t.decimal  "depth",              :precision => 8, :scale => 2
    t.datetime "deleted_at"
    t.boolean  "is_master",                                        :default => false
    t.integer  "product_id"
    t.integer  "count_on_hand",                                    :default => 0
    t.decimal  "cost_price",         :precision => 8, :scale => 2
    t.string   "cost_currency"
    t.integer  "position"
    t.integer  "lock_version",                                     :default => 0
    t.boolean  "on_demand",                                        :default => false
    t.string   "sku_upc"
    t.integer  "hto_count_on_hand",                                :default => 0
    t.string   "video_id"
    t.decimal  "sale_price",         :precision => 8, :scale => 2
    t.integer  "same_as_variant_id"
  end

  add_index "spree_variants", ["product_id"], :name => "index_spree_variants_on_product_id"
  add_index "spree_variants", ["same_as_variant_id"], :name => "index_spree_variants_on_same_as_variant_id"

  create_table "spree_zone_members", :force => true do |t|
    t.integer  "zoneable_id"
    t.string   "zoneable_type"
    t.integer  "zone_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "spree_zones", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.boolean  "default_tax",        :default => false
    t.integer  "zone_members_count", :default => 0
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
  end

  create_table "ttt1", :id => false, :force => true do |t|
    t.string "username", :limit => 18, :default => "", :null => false
  end

  create_table "ttt2", :id => false, :force => true do |t|
    t.string "username", :limit => 18, :default => "", :null => false
  end

  create_table "ttt3", :id => false, :force => true do |t|
    t.string  "upc", :limit => 12, :default => "", :null => false
    t.integer "qty", :limit => 8,  :default => 0,  :null => false
  end

  create_table "ttt4", :id => false, :force => true do |t|
    t.integer  "id",                                              :default => 0,     :null => false
    t.string   "sku",                                             :default => "",    :null => false
    t.decimal  "weight",            :precision => 8, :scale => 2
    t.decimal  "height",            :precision => 8, :scale => 2
    t.decimal  "width",             :precision => 8, :scale => 2
    t.decimal  "depth",             :precision => 8, :scale => 2
    t.datetime "deleted_at"
    t.boolean  "is_master",                                       :default => false
    t.integer  "product_id"
    t.integer  "count_on_hand",                                   :default => 0
    t.decimal  "cost_price",        :precision => 8, :scale => 2
    t.string   "cost_currency"
    t.integer  "position"
    t.integer  "lock_version",                                    :default => 0
    t.boolean  "on_demand",                                       :default => false
    t.string   "sku_upc"
    t.integer  "hto_count_on_hand",                               :default => 0
    t.string   "video_id"
  end

  create_table "ttt5", :id => false, :force => true do |t|
    t.integer  "id",                         :default => 0, :null => false
    t.string   "number",       :limit => 15
    t.datetime "completed_at"
    t.string   "state"
    t.string   "hto_state"
  end

  create_table "ttt7", :id => false, :force => true do |t|
    t.integer "product_id",   :default => 0,  :null => false
    t.integer "product_id2",  :default => 0,  :null => false
    t.string  "product_name", :default => "", :null => false
    t.string  "color_name"
    t.integer "variant_id1",  :default => 0,  :null => false
    t.integer "variant_id2",  :default => 0,  :null => false
    t.string  "sku",          :default => "", :null => false
    t.string  "sku2",         :default => "", :null => false
  end

  create_table "ttt8", :id => false, :force => true do |t|
    t.string  "product_name", :default => "", :null => false
    t.string  "color_name"
    t.integer "variant_id1",  :default => 0,  :null => false
    t.integer "variant_id2",  :default => 0,  :null => false
  end

end
