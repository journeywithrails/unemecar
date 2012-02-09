# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110121032350) do

  create_table "answers", :force => true do |t|
    t.integer  "question_id"
    t.integer  "question_option_id"
    t.string   "extra_info"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "event_registration_id"
  end

  create_table "audits", :force => true do |t|
    t.integer  "auditable_id"
    t.string   "auditable_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "username"
    t.string   "action"
    t.text     "changes"
    t.integer  "version",        :default => 0
    t.datetime "created_at"
  end

  add_index "audits", ["auditable_id", "auditable_type"], :name => "auditable_index"
  add_index "audits", ["created_at"], :name => "index_audits_on_created_at"
  add_index "audits", ["user_id", "user_type"], :name => "user_index"

  create_table "contact_infos", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.string   "state"
    t.string   "city"
    t.string   "zip"
    t.string   "address"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "show_name"
    t.boolean  "show_email"
    t.boolean  "show_phone"
    t.boolean  "show_address"
  end

  create_table "contents", :force => true do |t|
    t.string   "name"
    t.text     "item_content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "coupons", :force => true do |t|
    t.integer  "event_id"
    t.string   "code"
    t.datetime "expiration"
    t.float    "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "director_requests", :force => true do |t|
    t.integer  "event_type_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "event_date"
    t.string   "city"
    t.string   "state"
    t.string   "results_link"
    t.string   "register_link"
    t.string   "contact_name"
    t.string   "contact_email"
    t.text     "description"
    t.integer  "discipline_id"
    t.string   "map_link"
    t.string   "user_email"
    t.string   "user_name"
    t.string   "start_time"
    t.string   "address_info"
    t.string   "tag_line"
    t.datetime "end_time"
    t.string   "host"
    t.string   "fb_id"
  end

  create_table "disciplines", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "discounts", :force => true do |t|
    t.integer  "event_id"
    t.integer  "race_group_id"
    t.boolean  "is_deduct"
    t.float    "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "easy_payments", :force => true do |t|
    t.string   "user_id"
    t.string   "name"
    t.string   "email"
    t.binary   "paid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "shirt_size"
    t.string   "address"
    t.string   "sex"
    t.string   "birthdate"
    t.string   "emergency_contact"
    t.string   "age_on_raceday"
    t.string   "last_name"
    t.string   "team_name"
    t.string   "city"
    t.string   "state"
    t.string   "zipcode"
  end

  create_table "email_messages", :force => true do |t|
    t.integer  "event_id"
    t.integer  "rm_user_id"
    t.string   "subject"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "event_owners", :force => true do |t|
    t.integer "event_id",   :null => false
    t.integer "rm_user_id", :null => false
  end

  create_table "event_payments", :force => true do |t|
    t.integer  "event_id"
    t.float    "amount"
    t.datetime "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "check_number"
    t.text     "notes"
  end

  create_table "event_registrations", :force => true do |t|
    t.integer  "rm_user_id"
    t.date     "birthday"
    t.integer  "team_id"
    t.string   "email"
    t.string   "phone"
    t.string   "address"
    t.string   "apt"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "em_con_name"
    t.string   "em_con_phone"
    t.string   "em_con_relationship"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "sex"
    t.string   "invoice_code"
    t.boolean  "processed"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "event_id"
    t.integer  "registration_entry_type_id"
    t.string   "status"
    t.string   "tshirt"
    t.string   "bib_number"
    t.boolean  "is_manual"
    t.integer  "race_id"
    t.float    "cost"
    t.float    "service_fee"
    t.string   "license_num"
    t.string   "club_team"
    t.string   "refered_by"
    t.string   "payment_notes"
    t.integer  "age"
    t.string   "ip_address"
    t.string   "first_tri"
    t.string   "open_swim"
    t.string   "extra_regs"
    t.string   "payment_gross"
    t.integer  "coupon_id"
    t.string   "general_notes"
    t.string   "team_type"
    t.float    "refund_amount"
    t.boolean  "refund_processed"
    t.string   "country"
  end

  add_index "event_registrations", ["event_id"], :name => "index_event_registrations_on_event_id"
  add_index "event_registrations", ["rm_user_id"], :name => "index_event_registrations_on_rm_user_id"

  create_table "event_series", :force => true do |t|
    t.string   "name"
    t.integer  "rm_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "event_signups", :force => true do |t|
    t.integer  "reg_type"
    t.integer  "event_id"
    t.integer  "rm_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "event_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "discipline_id"
    t.float    "distance"
  end

  create_table "event_types_events", :id => false, :force => true do |t|
    t.integer "event_id"
    t.integer "event_type_id"
  end

  create_table "events", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "city"
    t.string   "state"
    t.string   "results_link"
    t.string   "register_link"
    t.string   "contact_name"
    t.string   "contact_email"
    t.text     "description"
    t.string   "map_link"
    t.string   "start_time"
    t.string   "address_info"
    t.datetime "event_date"
    t.float    "distance"
    t.string   "tag_line"
    t.datetime "end_time"
    t.string   "host"
    t.string   "contact_phone"
    t.string   "zip"
    t.boolean  "is_register_open"
    t.string   "content_type"
    t.string   "filename"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.boolean  "approved",                 :default => true
    t.text     "registration_text"
    t.string   "contact_state"
    t.string   "contact_city"
    t.string   "contact_zip"
    t.string   "contact_address"
    t.string   "presented_by"
    t.string   "benefiting"
    t.string   "location"
    t.integer  "rd_contact_info_id"
    t.integer  "contact_info_id"
    t.text     "disclaimer_text"
    t.integer  "manage_type"
    t.boolean  "is_contact_mandatory"
    t.integer  "event_series_id"
    t.integer  "entry_limit"
    t.boolean  "show_total_on_start_list"
    t.integer  "header_image_id"
    t.boolean  "supports_volunteer",       :default => false
    t.string   "last_year_results"
  end

  create_table "facebook_templates", :force => true do |t|
    t.string "template_name", :default => "", :null => false
    t.string "content_hash",  :default => "", :null => false
    t.string "bundle_id"
  end

  add_index "facebook_templates", ["template_name"], :name => "index_facebook_templates_on_template_name", :unique => true

  create_table "features", :force => true do |t|
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "feature_order"
    t.string   "name"
    t.string   "link"
    t.integer  "click_count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "visible"
  end

  create_table "home_features", :force => true do |t|
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "feature_order"
    t.string   "name"
    t.string   "link"
    t.integer  "click_count"
    t.string   "location"
    t.datetime "time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "images", :force => true do |t|
    t.string   "file_content_type"
    t.string   "file_file_name"
    t.string   "thumbnail"
    t.integer  "file_file_size"
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "file_updated_at"
  end

  create_table "invitations", :force => true do |t|
    t.integer  "event_id"
    t.integer  "race_id"
    t.datetime "expire_at"
    t.datetime "used_at"
    t.string   "email"
    t.string   "secret"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "merchandise_item_options", :force => true do |t|
    t.integer  "merchandise_item_id"
    t.float    "cost"
    t.integer  "o_order"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "merchandise_items", :force => true do |t|
    t.integer  "event_id"
    t.boolean  "is_donation"
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "image_id"
  end

  create_table "merchandise_orders", :force => true do |t|
    t.integer  "merchandise_item_option_id"
    t.integer  "event_registration_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "quantity",                   :default => 0
  end

  create_table "notification_settings", :force => true do |t|
    t.integer  "event_id",                                  :null => false
    t.boolean  "rec_reg_notification",   :default => false
    t.boolean  "rec_daily_notification", :default => false
    t.string   "notification_email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "rec_limit_notification"
  end

  create_table "payment_notifications", :force => true do |t|
    t.text     "params"
    t.integer  "cart_id"
    t.string   "status"
    t.string   "transaction_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "personal_bests", :force => true do |t|
    t.integer  "event_type_id"
    t.integer  "result_id"
    t.integer  "rm_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  create_table "question_options", :force => true do |t|
    t.integer  "question_id"
    t.integer  "q_order"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "questions", :force => true do |t|
    t.integer  "event_id"
    t.boolean  "is_required"
    t.string   "title"
    t.integer  "q_order"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "question_type"
    t.string   "abbreviation"
    t.string   "explanation_text"
  end

  create_table "r_notifier_emails", :force => true do |t|
    t.string   "from"
    t.string   "to"
    t.integer  "last_send_attempt", :default => 0
    t.text     "mail"
    t.datetime "created_on"
  end

  create_table "race_fee_changes", :force => true do |t|
    t.float    "fee"
    t.integer  "race_id"
    t.datetime "change_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "race_groups", :force => true do |t|
    t.integer  "event_id"
    t.string   "title"
    t.integer  "group_order"
    t.boolean  "is_default"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "race_merchandise_items", :force => true do |t|
    t.integer "race_id"
    t.integer "merchandise_item_id"
  end

  create_table "races", :force => true do |t|
    t.integer  "event_id"
    t.integer  "discipline_id"
    t.integer  "event_type_id"
    t.float    "distance"
    t.datetime "start_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "race_group_id"
    t.integer  "race_group_order"
    t.string   "name"
    t.integer  "field_size"
    t.string   "prizes"
    t.boolean  "assign_bibs"
    t.boolean  "registration_open"
    t.float    "initial_fee"
    t.integer  "distance_unit"
    t.boolean  "is_kids_race"
    t.boolean  "is_sanctioned"
    t.boolean  "is_series"
    t.string   "sanctioned_by"
    t.string   "series_name"
    t.boolean  "is_women_race"
    t.string   "reserve_entries"
    t.boolean  "license_req"
    t.boolean  "has_minimum_age"
    t.integer  "minimum_age"
    t.boolean  "is_relay"
    t.integer  "min_relay_size"
    t.integer  "max_relay_size"
    t.boolean  "visible"
    t.boolean  "show_on_start_list"
    t.boolean  "supports_team"
    t.boolean  "supports_team_creation"
    t.boolean  "has_waiting_list"
  end

  create_table "redirects", :force => true do |t|
    t.string   "text"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "regions", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "registration_datas", :force => true do |t|
    t.integer  "event_registration_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "registration_entry_types", :force => true do |t|
    t.integer  "event_id"
    t.string   "name"
    t.float    "cost"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "supports_teams"
  end

  create_table "relay_entries", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "em_con_name"
    t.string   "em_con_phone"
    t.boolean  "is_captain"
    t.integer  "rm_user_id"
    t.integer  "team_order"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "date_of_birth"
    t.string   "email"
    t.string   "license_num"
    t.integer  "relay_team_id"
    t.string   "gender"
    t.string   "tshirt"
  end

  create_table "relay_teams", :force => true do |t|
    t.integer  "event_registration_id"
    t.string   "name"
    t.string   "division"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "results", :force => true do |t|
    t.integer  "event_id"
    t.integer  "rm_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "pace_unit"
    t.integer  "overall_place"
    t.integer  "division_place"
    t.boolean  "is_personal_record"
    t.integer  "hour"
    t.integer  "minute"
    t.integer  "second"
    t.integer  "pace_hour"
    t.integer  "pace_minute"
    t.integer  "pace_second"
  end

  create_table "rm_users", :force => true do |t|
    t.integer  "referral_id"
    t.string   "fb_usid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "team"
    t.string   "weight"
    t.text     "strengths"
    t.integer  "h_inches"
    t.integer  "h_feet"
    t.integer  "racing_age"
    t.integer  "icon_num"
    t.string   "bikes"
    t.string   "sneakers"
    t.string   "pre_race_song"
    t.string   "pre_race_food"
    t.string   "email_hash"
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password"
    t.string   "salt"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "name"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "password_reset_code",       :limit => 40
  end

  create_table "series", :force => true do |t|
    t.integer  "name"
    t.string   "header"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "series_events", :force => true do |t|
    t.integer  "series_id"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :default => "", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "simple_events", :force => true do |t|
    t.string   "title"
    t.datetime "date"
    t.string   "host"
    t.string   "discipline"
    t.string   "event_type"
    t.text     "description"
    t.string   "location"
    t.string   "city"
    t.string   "state"
    t.string   "contact_name"
    t.string   "contact_email"
    t.string   "website"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sitedatas", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "team_entries", :force => true do |t|
    t.integer  "team_id"
    t.integer  "team_order"
    t.boolean  "approved"
    t.integer  "event_registration_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teams", :force => true do |t|
    t.integer  "race_director_id"
    t.string   "name"
    t.string   "company_name"
    t.string   "captain_name"
    t.string   "email"
    t.string   "phone"
    t.string   "address"
    t.string   "apt"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "event_id"
    t.boolean  "approved"
    t.string   "cpt_first_name"
    t.string   "cpt_last_name"
    t.string   "team_type"
  end

  create_table "users", :force => true do |t|
    t.integer  "referral_id"
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
  end

  create_table "volunteer_coords", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "volunteer_groups", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "volunteer_jobs", :force => true do |t|
    t.string   "title"
    t.string   "location"
    t.datetime "start_time"
    t.datetime "end_time"
    t.text     "training_info"
    t.datetime "training_start_time"
    t.datetime "training_end_time"
    t.string   "training_location"
    t.integer  "min_needed"
    t.integer  "max_needed"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "volunteer_time_slots", :force => true do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "volunteers", :force => true do |t|
    t.string   "last_name"
    t.string   "first_name"
    t.date     "birthday"
    t.string   "email"
    t.string   "phone"
    t.string   "address"
    t.string   "apt"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "comments"
    t.string   "gender"
    t.integer  "volunteer_job_id"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "waitlists", :force => true do |t|
    t.integer  "event_id",   :null => false
    t.integer  "race_id",    :null => false
    t.integer  "rm_user_id", :null => false
    t.string   "name"
    t.string   "gender"
    t.string   "email"
    t.text     "address"
    t.string   "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_invited"
    t.date     "birthday"
  end

end
