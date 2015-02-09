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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150205012415) do

  create_table "account_bill_infos", force: true do |t|
    t.integer  "account_bill_id"
    t.integer  "adv_content_id"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.decimal  "price",           precision: 6, scale: 2, default: 0.0
    t.integer  "amount"
  end

  create_table "account_bills", force: true do |t|
    t.integer  "amount"
    t.decimal  "balance",                precision: 8, scale: 2, default: 0.0
    t.datetime "created_at",                                                     null: false
    t.datetime "updated_at",                                                     null: false
    t.integer  "user_id"
    t.string   "state"
    t.string   "company"
    t.string   "details"
    t.decimal  "after_tax_balance",      precision: 8, scale: 2, default: 0.0
    t.decimal  "tax",                    precision: 6, scale: 2, default: 0.0
    t.boolean  "is_public",                                      default: false
    t.string   "pay_money_pic"
    t.date     "expect_to_account_date"
    t.integer  "invoice_state",                                  default: 0
  end

  create_table "adultshop_configs", force: true do |t|
    t.string   "file"
    t.string   "version"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "adv_advertiser_reports", force: true do |t|
    t.integer  "adv_content_id"
    t.integer  "count",          default: 0
    t.date     "report_date"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "adv_advertiser_reports", ["adv_content_id"], name: "index_adv_advertiser_reports_on_adv_content_id", using: :btree

  create_table "adv_application_reports", force: true do |t|
    t.integer  "application_id"
    t.integer  "warning_count",  default: 0
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "adv_application_reports", ["application_id"], name: "index_adv_application_reports_on_application_id", using: :btree

  create_table "adv_content_account_notifies", force: true do |t|
    t.integer "adv_content_id"
    t.date    "start_date"
    t.date    "end_date"
  end

  create_table "adv_contents", force: true do |t|
    t.string   "title"
    t.string   "banner"
    t.string   "apk_sign"
    t.integer  "plan_view_count",                           default: 0
    t.integer  "actual_view_count",                         default: 0
    t.integer  "today_view_count",                          default: 0
    t.integer  "total_view_count",                          default: 0
    t.string   "square_banner"
    t.boolean  "activity",                                  default: false
    t.string   "url"
    t.datetime "updated_at",                                                null: false
    t.string   "description"
    t.datetime "created_at",                                                null: false
    t.decimal  "price",             precision: 6, scale: 2, default: 0.0
    t.integer  "user_id"
    t.string   "icon"
    t.string   "tag"
    t.string   "version_name"
    t.integer  "version_code"
    t.boolean  "trash",                                     default: false
    t.boolean  "deleted",                                   default: false
    t.string   "website"
  end

  create_table "adv_contents_applications", id: false, force: true do |t|
    t.integer "application_id", null: false
    t.integer "adv_content_id", null: false
  end

  add_index "adv_contents_applications", ["application_id"], name: "index_adv_contents_applications_on_application_id", using: :btree

  create_table "adv_details", force: true do |t|
    t.integer  "adv_content_id"
    t.string   "origin"
    t.string   "cooperation_mode"
    t.decimal  "price",                 precision: 8, scale: 2, default: 0.0
    t.string   "calculate_mode"
    t.string   "balance_requirement"
    t.string   "balance_instruction"
    t.string   "balance_cycle"
    t.string   "balance_first_date"
    t.string   "promotion_requirement"
    t.string   "manage_site",                                   default: "0"
    t.string   "manage_site_user"
    t.string   "manage_site_password"
    t.string   "company"
    t.string   "name"
    t.string   "phone"
    t.string   "qq"
    t.string   "postcode"
    t.string   "address"
    t.datetime "created_at",                                                  null: false
    t.datetime "updated_at",                                                  null: false
  end

  create_table "adv_settings", force: true do |t|
    t.string   "channel"
    t.string   "product_name"
    t.boolean  "activity",       default: false
    t.boolean  "block",          default: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "application_id"
  end

  add_index "adv_settings", ["application_id"], name: "index_adv_settings_on_application_id", using: :btree

  create_table "adv_settings_adv_tactics", id: false, force: true do |t|
    t.integer "adv_tactic_id"
    t.integer "adv_setting_id"
  end

  add_index "adv_settings_adv_tactics", ["adv_tactic_id"], name: "index_adv_settings_adv_tactics_on_adv_tactic_id", using: :btree

  create_table "adv_statistics", force: true do |t|
    t.integer  "application_id",             null: false
    t.integer  "adv_content_id",             null: false
    t.integer  "view_count",     default: 0
    t.integer  "click_count",    default: 0
    t.integer  "install_count",  default: 0
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "read_count",     default: 0
  end

  add_index "adv_statistics", ["application_id", "adv_content_id", "created_at"], name: "by_app_ad_date", unique: true, using: :btree

  create_table "adv_tactics", force: true do |t|
    t.string   "action"
    t.string   "value"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "notice_type",     default: 1
    t.string   "adv_content_ids"
    t.integer  "adv_setting_id"
  end

  create_table "applications", force: true do |t|
    t.string   "name"
    t.datetime "created_at",                                      null: false
    t.string   "api_key"
    t.string   "secret_key"
    t.string   "description"
    t.integer  "platform"
    t.integer  "user_id"
    t.boolean  "display_advertising",             default: false
    t.string   "getui_app_id"
    t.string   "getui_app_key"
    t.string   "getui_master_secret"
    t.datetime "updated_at",                                      null: false
    t.string   "getui_app_secret"
    t.string   "umeng_app_key"
    t.integer  "qr_scene_id"
    t.string   "qr_ticket",           limit: 500
  end

  add_index "applications", ["qr_scene_id"], name: "index_applications_on_qr_scene_id", using: :btree

  create_table "applications_rules", id: false, force: true do |t|
    t.integer "application_id", null: false
    t.integer "rule_id",        null: false
  end

  create_table "articles", force: true do |t|
    t.string   "title"
    t.text     "body"
    t.string   "image"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "description"
    t.string   "background"
    t.boolean  "banner",        default: false
    t.datetime "activate_at"
    t.datetime "expire_at"
    t.boolean  "noticed",       default: false
    t.integer  "reading_count", default: 0
    t.integer  "position",      default: 0
    t.datetime "deleted_at"
    t.boolean  "eailv_banner"
  end

  add_index "articles", ["title"], name: "index_articles_on_title", using: :btree

  create_table "asks", force: true do |t|
    t.text     "question"
    t.text     "answer"
    t.boolean  "imp",        default: false
    t.integer  "user_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "product_id"
  end

  create_table "block_lists", force: true do |t|
    t.string   "device_id"
    t.integer  "node_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "reason"
    t.datetime "free_at"
  end

  create_table "brands", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "logo"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "brands", ["name"], name: "index_brands_on_name", using: :btree

  create_table "cartlogs", force: true do |t|
    t.text     "content"
    t.integer  "cart_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "carts", force: true do |t|
    t.string   "device_id"
    t.datetime "deleted_at"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "application_id"
  end

  add_index "carts", ["device_id", "application_id"], name: "index_carts_on_device_id_and_app_id", using: :btree

  create_table "categories", force: true do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "channels", force: true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.boolean  "enabled",                                        default: true
    t.decimal  "price",                  precision: 6, scale: 2, default: 0.0
    t.datetime "created_at",                                                    null: false
    t.datetime "updated_at",                                                    null: false
    t.integer  "manager_id"
    t.integer  "level"
    t.boolean  "auto_ratio",                                     default: true
    t.datetime "auto_ratio_activate_at"
  end

  add_index "channels", ["manager_id"], name: "index_channels_on_manager_id", using: :btree

  create_table "cities", force: true do |t|
    t.string   "name"
    t.integer  "province_id"
    t.integer  "level"
    t.string   "zip_code"
    t.string   "pinyin"
    t.string   "pinyin_abbr"
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
    t.decimal  "cash_on_delivery", precision: 8, scale: 2, default: 0.0
    t.decimal  "pay_online",       precision: 8, scale: 2, default: 0.0
  end

  add_index "cities", ["level"], name: "index_cities_on_level", using: :btree
  add_index "cities", ["name"], name: "index_cities_on_name", using: :btree
  add_index "cities", ["pinyin"], name: "index_cities_on_pinyin", using: :btree
  add_index "cities", ["pinyin_abbr"], name: "index_cities_on_pinyin_abbr", using: :btree
  add_index "cities", ["province_id"], name: "index_cities_on_province_id", using: :btree
  add_index "cities", ["zip_code"], name: "index_cities_on_zip_code", using: :btree

  create_table "ckeditor_assets", force: true do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree

  create_table "clearing_items", force: true do |t|
    t.integer  "clearing_id"
    t.integer  "order_id",                                          null: false
    t.integer  "user_id",                                           null: false
    t.decimal  "order_amount", precision: 10, scale: 0, default: 0
    t.decimal  "earn_amount",  precision: 10, scale: 0, default: 0
    t.decimal  "real_amount",  precision: 10, scale: 0, default: 0
    t.string   "state"
    t.text     "notes"
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.string   "item_type"
    t.string   "pay_type"
  end

  add_index "clearing_items", ["clearing_id"], name: "index_clearing_items_on_clearing_id", using: :btree
  add_index "clearing_items", ["item_type"], name: "index_clearing_items_on_item_type", using: :btree
  add_index "clearing_items", ["order_id"], name: "index_clearing_items_on_order_id", using: :btree
  add_index "clearing_items", ["pay_type"], name: "index_clearing_items_on_pay_type", using: :btree
  add_index "clearing_items", ["state"], name: "index_clearing_items_on_state", using: :btree
  add_index "clearing_items", ["user_id"], name: "index_clearing_items_on_user_id", using: :btree

  create_table "clearings", force: true do |t|
    t.integer  "user_id",                                            null: false
    t.decimal  "sale_money",    precision: 10, scale: 0, default: 0
    t.decimal  "comission",     precision: 10, scale: 0, default: 0
    t.decimal  "push_money",    precision: 10, scale: 0, default: 0
    t.date     "deadline"
    t.string   "clearing_type"
    t.string   "state"
    t.text     "notes"
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
  end

  add_index "clearings", ["clearing_type"], name: "index_clearings_on_type", using: :btree
  add_index "clearings", ["state"], name: "index_clearings_on_state", using: :btree
  add_index "clearings", ["user_id"], name: "index_clearings_on_user_id", using: :btree

  create_table "comments", force: true do |t|
    t.integer  "product_id"
    t.string   "name"
    t.text     "content"
    t.datetime "comment_at"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "comment_num"
    t.string   "device_id"
    t.integer  "order_id"
    t.datetime "deleted_at"
    t.boolean  "enabled",                 default: false
    t.integer  "commable_id"
    t.string   "commable_type"
    t.integer  "score",         limit: 1
  end

  add_index "comments", ["order_id"], name: "index_comments_on_order_id", using: :btree
  add_index "comments", ["product_id"], name: "index_comments_on_product_id", using: :btree

  create_table "contents", force: true do |t|
    t.string   "user_name"
    t.string   "text"
    t.string   "image"
    t.string   "user_avatar"
    t.integer  "width"
    t.integer  "height"
    t.integer  "likes_count",   default: 0
    t.integer  "unlikes_count", default: 0
    t.integer  "forward_count", default: 0
    t.integer  "source_id"
    t.boolean  "top",           default: false
    t.boolean  "approved",      default: false
    t.integer  "replies_count", default: 0
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "contents", ["source_id"], name: "index_contents_on_source_id", using: :btree

  create_table "coupons", force: true do |t|
    t.string   "to"
    t.string   "title"
    t.string   "description"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "category",                                     default: 0
    t.integer  "number",                                       default: 0
    t.integer  "condition",                                    default: 0
    t.integer  "additional_condition",                         default: 0
    t.boolean  "enabled",                                      default: true
    t.boolean  "separate",                                     default: true
    t.decimal  "money",                precision: 8, scale: 2, default: 0.0
    t.datetime "created_at",                                                   null: false
    t.datetime "updated_at",                                                   null: false
    t.string   "user_type",                                    default: "ALL"
    t.datetime "user_start_at"
    t.datetime "user_end_at"
    t.string   "message_subject"
    t.text     "message_body"
    t.integer  "pay_type"
    t.integer  "application_id"
    t.string   "application_ver"
  end

  add_index "coupons", ["application_id"], name: "index_coupons_on_application_id", using: :btree
  add_index "coupons", ["pay_type"], name: "index_coupons_on_pay_type", using: :btree
  add_index "coupons", ["to"], name: "index_coupons_on_to", using: :btree

  create_table "coupons_orders", force: true do |t|
    t.integer "coupon_id"
    t.integer "order_id"
  end

  create_table "debugs", force: true do |t|
    t.string   "file"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "device_infos", force: true do |t|
    t.string   "device_id"
    t.string   "nickname"
    t.string   "baidu_user_id"
    t.string   "baidu_channel_id"
    t.string   "tag_list"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "application_id"
  end

  add_index "device_infos", ["device_id"], name: "index_device_infos_on_device_id", using: :btree

  create_table "devices", force: true do |t|
    t.string   "device_id"
    t.string   "model_ver"
    t.string   "manufacture"
    t.string   "firmware"
    t.string   "sdk_ver"
    t.string   "apn"
    t.string   "lang"
    t.string   "country"
    t.string   "channel_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "applist_md5"
    t.text     "applist"
    t.text     "location_info"
    t.text     "address"
    t.string   "init_app_ver"
    t.string   "app_ver"
    t.text     "devinfo_extra"
    t.string   "init_pwd"
    t.integer  "robot_id"
    t.integer  "member_id"
  end

  add_index "devices", ["channel_id"], name: "channel_id_on_devices", using: :btree
  add_index "devices", ["device_id"], name: "index_devices_on_device_id", using: :btree
  add_index "devices", ["member_id"], name: "index_devices_on_member_id", using: :btree

  create_table "districts", force: true do |t|
    t.string   "name"
    t.integer  "city_id"
    t.string   "pinyin"
    t.string   "pinyin_abbr"
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
    t.decimal  "cash_on_delivery", precision: 8, scale: 2, default: 0.0
    t.decimal  "pay_online",       precision: 8, scale: 2, default: 0.0
  end

  add_index "districts", ["city_id"], name: "index_districts_on_city_id", using: :btree
  add_index "districts", ["name"], name: "index_districts_on_name", using: :btree
  add_index "districts", ["pinyin"], name: "index_districts_on_pinyin", using: :btree
  add_index "districts", ["pinyin_abbr"], name: "index_districts_on_pinyin_abbr", using: :btree

  create_table "eclogs", force: true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "logable_id"
    t.string   "logable_type"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "favorites", force: true do |t|
    t.string   "device_id"
    t.integer  "favable_id"
    t.string   "favable_type"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "favorites", ["device_id"], name: "index_favorites_on_device_id", using: :btree
  add_index "favorites", ["favable_id"], name: "index_favorites_on_favable_id", using: :btree
  add_index "favorites", ["favable_type"], name: "index_favorites_on_favable_type", using: :btree

  create_table "home_contents", force: true do |t|
    t.integer  "page_id"
    t.integer  "block"
    t.integer  "position"
    t.string   "typename"
    t.integer  "typeid"
    t.string   "title"
    t.string   "name"
    t.string   "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "homepages", force: true do |t|
    t.string   "name"
    t.string   "label"
    t.integer  "hour"
    t.string   "day"
    t.boolean  "activity"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "application_id"
  end

  add_index "homepages", ["application_id"], name: "index_homepages_on_application_id", using: :btree

  create_table "line_items", force: true do |t|
    t.integer  "order_id"
    t.datetime "created_at",                                               null: false
    t.datetime "updated_at",                                               null: false
    t.string   "sku"
    t.integer  "product_id"
    t.string   "product_prop_name"
    t.string   "product_prop_value"
    t.string   "price"
    t.integer  "quantity",                                   default: 1
    t.decimal  "purchase_price",     precision: 8, scale: 2, default: 0.0
    t.decimal  "sale_price",         precision: 8, scale: 2, default: 0.0
    t.integer  "product_prop_id"
    t.string   "num_iid"
    t.decimal  "shipping_charge",    precision: 8, scale: 2, default: 0.0
    t.integer  "cart_id"
    t.datetime "deleted_at"
  end

  add_index "line_items", ["cart_id"], name: "index_line_items_on_cart_id", using: :btree
  add_index "line_items", ["order_id", "product_id"], name: "index_line_items_on_order_id_and_product_id", using: :btree
  add_index "line_items", ["order_id"], name: "index_line_items_on_order_id", using: :btree

  create_table "logs", force: true do |t|
    t.string   "device_id"
    t.string   "query_string"
    t.string   "request_path"
    t.string   "controller_name"
    t.string   "action_name"
    t.string   "ip_address"
    t.string   "message"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "application_id"
  end

  add_index "logs", ["action_name"], name: "index_logs_on_action_name", using: :btree
  add_index "logs", ["controller_name"], name: "index_logs_on_controller_name", using: :btree
  add_index "logs", ["device_id"], name: "index_logs_on_device_id", using: :btree

  create_table "materials", force: true do |t|
    t.string   "filetype"
    t.string   "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "members", force: true do |t|
    t.string   "nickname"
    t.string   "hashed_password"
    t.string   "salt"
    t.integer  "coin_total",                   default: 0
    t.integer  "score_total",                  default: 0
    t.integer  "level",                        default: 0
    t.boolean  "verified",                     default: false
    t.boolean  "gender",                       default: true
    t.string   "phone"
    t.string   "province"
    t.string   "avatar"
    t.string   "captcha"
    t.integer  "captcha_flag"
    t.datetime "captcha_updated_at"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.boolean  "robot",                        default: false
    t.boolean  "receive_message_notification", default: true
    t.boolean  "receive_reply_notification",   default: true
  end

  add_index "members", ["coin_total"], name: "index_members_on_coin_total", using: :btree
  add_index "members", ["level"], name: "index_members_on_level", using: :btree
  add_index "members", ["province"], name: "index_members_on_province", using: :btree
  add_index "members", ["score_total"], name: "index_members_on_score_total", using: :btree

  create_table "members_nodes", id: false, force: true do |t|
    t.integer "member_id"
    t.integer "node_id"
  end

  create_table "messages", force: true do |t|
    t.string   "subject"
    t.text     "body"
    t.string   "image"
    t.string   "category"
    t.string   "from"
    t.string   "to"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "object_id"
    t.string   "nickname"
    t.boolean  "published",  default: true
    t.integer  "position",   default: 1000
    t.integer  "reply_num"
  end

  add_index "messages", ["parent_id"], name: "index_messages_on_parent_id", using: :btree
  add_index "messages", ["to"], name: "index_messages_on_to", using: :btree
  add_index "messages", ["updated_at"], name: "index_messages_on_updated_at", using: :btree

  create_table "nodes", force: true do |t|
    t.string   "name"
    t.string   "summary"
    t.text     "managers"
    t.integer  "sort",         default: 0
    t.integer  "topics_count", default: 0
    t.boolean  "privated",     default: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "icon"
    t.text     "rule"
    t.integer  "gender",       default: 0
    t.boolean  "recommend",    default: false
  end

  create_table "notifications", force: true do |t|
    t.string   "notice_type"
    t.integer  "notice_id"
    t.integer  "application_id"
    t.string   "tag"
    t.string   "title"
    t.string   "description"
    t.text     "messages"
    t.string   "user_id"
    t.string   "channel_id"
    t.integer  "push_type"
    t.boolean  "sended",         default: false
    t.integer  "receive_count",  default: 0
    t.integer  "open_count",     default: 0
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "message_type",   default: 0
    t.datetime "activate_at"
    t.boolean  "getui_sended",   default: false
  end

  create_table "orderlogs", force: true do |t|
    t.text     "content"
    t.integer  "order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
  end

  add_index "orderlogs", ["order_id"], name: "index_order_logs_on_order_id", using: :btree
  add_index "orderlogs", ["order_id"], name: "index_orderlogs_on_order_id", using: :btree

  create_table "orders", force: true do |t|
    t.string   "state"
    t.string   "device_id"
    t.string   "address"
    t.string   "name"
    t.string   "phone"
    t.string   "postal_code"
    t.string   "product_name"
    t.decimal  "price",             precision: 8, scale: 2, default: 0.0
    t.decimal  "shipping_charge",   precision: 8, scale: 2, default: 0.0
    t.string   "num_iid"
    t.datetime "created_at",                                                null: false
    t.integer  "quantity"
    t.datetime "updated_at",                                                null: false
    t.integer  "application_id"
    t.text     "comment"
    t.string   "audio"
    t.integer  "pay_type",                                  default: 1
    t.string   "delivery_no"
    t.string   "delivery_vendor"
    t.string   "remask"
    t.integer  "user_id"
    t.string   "shipping_address"
    t.boolean  "handle",                                    default: false
    t.string   "shipping_city"
    t.string   "shipping_province"
    t.string   "shipping_district"
    t.integer  "shippingorder_id"
    t.datetime "deleted_at"
    t.decimal  "item_total",        precision: 8, scale: 2, default: 0.0
    t.integer  "coordinator_id"
    t.datetime "assigned_at"
    t.boolean  "export_to_erp",                             default: false
    t.string   "payment_state"
    t.decimal  "payment_total",     precision: 8, scale: 2, default: 0.0
    t.boolean  "sms_sended",                                default: false
    t.boolean  "sms_unhandled",                             default: false
    t.decimal  "actual_total",      precision: 6, scale: 2, default: 0.0
    t.string   "come_from"
  end

  add_index "orders", ["device_id"], name: "index_orders_on_device_id", using: :btree
  add_index "orders", ["num_iid"], name: "index_orders_on_num_iid", using: :btree
  add_index "orders", ["phone"], name: "index_orders_on_phone", using: :btree
  add_index "orders", ["shippingorder_id"], name: "index_orders_on_shippingorder_id", using: :btree
  add_index "orders", ["sms_sended"], name: "index_orders_on_sms_sended", using: :btree
  add_index "orders", ["sms_unhandled"], name: "index_orders_on_sms_unhandled", using: :btree

  create_table "passwords", force: true do |t|
    t.string   "device_id"
    t.string   "password"
    t.integer  "number",     default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "passwords", ["device_id"], name: "index_passwords_on_device_id", using: :btree

  create_table "payments", force: true do |t|
    t.decimal  "amount",               precision: 8, scale: 2
    t.integer  "order_id"
    t.integer  "source_id"
    t.string   "source_type"
    t.integer  "payment_method_id"
    t.string   "state"
    t.string   "response_code"
    t.string   "avs_response"
    t.string   "identifier"
    t.string   "cvv_response_code"
    t.string   "cvv_response_message"
    t.string   "transaction_no"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
  end

  create_table "photos", force: true do |t|
    t.integer  "product_id"
    t.string   "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "position"
    t.integer  "number"
  end

  add_index "photos", ["product_id"], name: "index_photos_on_product_id", using: :btree

  create_table "platform_accounts", force: true do |t|
    t.integer  "platform_id"
    t.string   "account_name"
    t.decimal  "balance",      precision: 6, scale: 2, default: 0.0
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
  end

  create_table "platform_balanceios", force: true do |t|
    t.integer  "platform_account_id"
    t.integer  "adv_content_id"
    t.decimal  "money",               precision: 6, scale: 2, default: 0.0
    t.datetime "created_at",                                                null: false
    t.datetime "updated_at",                                                null: false
    t.date     "report_date"
  end

  create_table "platform_statistics", force: true do |t|
    t.integer  "adv_content_id"
    t.integer  "platform_id"
    t.integer  "install_count"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.date     "report_date"
  end

  create_table "platforms", force: true do |t|
    t.string   "name"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "adv_content_ids"
  end

  create_table "private_messages", force: true do |t|
    t.text     "body"
    t.integer  "receiver_id"
    t.integer  "sender_id"
    t.boolean  "opened",           default: false
    t.boolean  "receiver_deleted", default: false
    t.boolean  "sender_deleted",   default: false
    t.boolean  "spam",             default: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "private_messages", ["sender_id", "receiver_id"], name: "acts_as_messageable_ids", using: :btree

  create_table "product_props", force: true do |t|
    t.integer  "product_id"
    t.datetime "created_at",                                                       null: false
    t.datetime "updated_at",                                                       null: false
    t.string   "values"
    t.string   "name"
    t.string   "sku"
    t.decimal  "purchase_price",             precision: 8, scale: 2, default: 0.0
    t.decimal  "sale_price",                 precision: 8, scale: 2, default: 0.0
    t.integer  "quantity",                                           default: 0
    t.integer  "supplier_id"
    t.decimal  "original_price",             precision: 8, scale: 2, default: 0.0
    t.integer  "rzx_stock"
    t.integer  "rzx_validity"
    t.integer  "safe_stock",                                         default: 0
    t.float    "franchise_price", limit: 24
  end

  add_index "product_props", ["product_id"], name: "index_product_props_on_product_id", using: :btree

  create_table "products", force: true do |t|
    t.integer  "brand_id"
    t.string   "title"
    t.string   "image"
    t.string   "sell_link",              limit: 512
    t.integer  "rank",                                                       default: 0
    t.datetime "created_at",                                                                 null: false
    t.datetime "updated_at",                                                                 null: false
    t.string   "description"
    t.string   "background"
    t.boolean  "banner",                                                     default: false
    t.string   "num_iid"
    t.datetime "activate_at"
    t.decimal  "price",                              precision: 8, scale: 2, default: 0.0
    t.datetime "expire_at"
    t.boolean  "noticed",                                                    default: false
    t.string   "seller_credit_score"
    t.string   "item_location"
    t.string   "commission"
    t.string   "commission_num"
    t.string   "commission_rate"
    t.string   "commission_volume"
    t.integer  "volume"
    t.string   "coupon_price"
    t.string   "coupon_rate"
    t.string   "seller"
    t.string   "shop_link",              limit: 512
    t.decimal  "item_score",                         precision: 4, scale: 2
    t.decimal  "service_score",                      precision: 4, scale: 2
    t.decimal  "delivery_score",                     precision: 4, scale: 2
    t.datetime "coupon_start_time"
    t.datetime "coupon_end_time"
    t.decimal  "shipping_charge",                    precision: 8, scale: 2, default: 0.0
    t.boolean  "recommended",                                                default: false
    t.string   "shop_title"
    t.string   "item_score_compare"
    t.string   "service_score_compare"
    t.string   "delivery_score_compare"
    t.string   "feed_back",              limit: 24
    t.string   "detail_link"
    t.string   "number"
    t.integer  "supplier_id"
    t.datetime "deleted_at"
    t.string   "taobao_id"
    t.boolean  "out_of_stock",                                               default: false
    t.string   "itemsn"
    t.boolean  "auto_pick_up",                                               default: true
    t.string   "video"
    t.text     "selling_point"
  end

  add_index "products", ["brand_id"], name: "index_products_on_brand_id", using: :btree
  add_index "products", ["price"], name: "index_products_on_price", using: :btree
  add_index "products", ["title"], name: "index_products_on_title", using: :btree

  create_table "profiles", force: true do |t|
    t.integer  "user_id"
    t.string   "type_name"
    t.decimal  "amount",            precision: 8, scale: 2
    t.string   "name"
    t.string   "phone"
    t.string   "qq"
    t.string   "identity_card"
    t.string   "bank"
    t.string   "bank_address"
    t.string   "bank_account"
    t.string   "bank_account_name"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  create_table "provinces", force: true do |t|
    t.string   "name"
    t.string   "pinyin"
    t.string   "pinyin_abbr"
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
    t.decimal  "cash_on_delivery", precision: 8, scale: 2, default: 0.0
    t.decimal  "pay_online",       precision: 8, scale: 2, default: 0.0
  end

  add_index "provinces", ["name"], name: "index_provinces_on_name", using: :btree
  add_index "provinces", ["pinyin"], name: "index_provinces_on_pinyin", using: :btree
  add_index "provinces", ["pinyin_abbr"], name: "index_provinces_on_pinyin_abbr", using: :btree

  create_table "q_messages", force: true do |t|
    t.string   "subject"
    t.text     "body"
    t.string   "image"
    t.string   "category"
    t.string   "from"
    t.string   "to"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "object_id"
    t.string   "nickname"
    t.integer  "position"
    t.integer  "reply_num"
    t.boolean  "published",  default: true
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "hidden",     default: false
    t.integer  "fid"
  end

  add_index "q_messages", ["parent_id"], name: "index_q_messages_on_parent_id", using: :btree
  add_index "q_messages", ["to"], name: "index_q_messages_on_to", using: :btree

  create_table "replies", force: true do |t|
    t.text     "body"
    t.integer  "topic_id"
    t.string   "device_id"
    t.string   "nickname"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "replyable_id"
    t.string   "replyable_type"
    t.integer  "member_id"
    t.integer  "report_num",     default: 0
    t.datetime "deleted_at"
  end

  add_index "replies", ["member_id"], name: "index_replies_on_member_id", using: :btree
  add_index "replies", ["replyable_id", "replyable_type"], name: "index_replies_on_replyable_id_and_replyable_type", using: :btree
  add_index "replies", ["topic_id"], name: "index_replies_on_topic_id", using: :btree

  create_table "reports", force: true do |t|
    t.string   "reportable_id"
    t.string   "reportable_type"
    t.string   "device_id"
    t.string   "reason"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "resources", force: true do |t|
    t.integer  "application_id"
    t.integer  "resable_id"
    t.string   "resable_type"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "resources", ["application_id"], name: "index_resources_on_application_id", using: :btree
  add_index "resources", ["resable_id"], name: "index_resources_on_resable_id", using: :btree
  add_index "resources", ["resable_type"], name: "index_resources_on_resable_type", using: :btree

  create_table "rules", force: true do |t|
    t.string   "name"
    t.decimal  "ratio",       precision: 3, scale: 2, default: 0.0
    t.integer  "channel_id"
    t.datetime "activate_at"
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
  end

  create_table "sales_messages", force: true do |t|
    t.string   "subject"
    t.text     "content"
    t.string   "category"
    t.string   "from"
    t.datetime "device_created_at_start"
    t.datetime "device_created_at_end"
    t.integer  "range"
    t.integer  "page"
    t.integer  "count",                   default: 0
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  create_table "settings", force: true do |t|
    t.string   "name"
    t.text     "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "settings", ["name"], name: "index_settings_on_name", using: :btree

  create_table "shippingorderlogs", force: true do |t|
    t.string   "content"
    t.integer  "shippingorder_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "shippingorderlogs", ["shippingorder_id"], name: "index_shippingorderlogs_on_shippingorder_id", using: :btree

  create_table "shippingorders", force: true do |t|
    t.string   "company"
    t.string   "contact"
    t.string   "leavetime"
    t.text     "data"
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.integer  "amount"
    t.string   "extra_order_id"
    t.datetime "deleted_at"
    t.integer  "state"
    t.datetime "worked"
    t.decimal  "pay_back_fee",    precision: 6, scale: 2, default: 0.0
    t.decimal  "handle_fee",      precision: 6, scale: 2, default: 0.0
    t.decimal  "return_back_fee", precision: 6, scale: 2, default: 0.0
    t.decimal  "shipping_charge", precision: 6, scale: 2, default: 0.0
    t.integer  "handle_state",                            default: 0
    t.decimal  "server_fee",      precision: 6, scale: 2, default: 0.0
  end

  create_table "shopping_items", force: true do |t|
    t.text     "content"
    t.string   "image"
    t.integer  "shopping_list_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "shopping_lists", force: true do |t|
    t.integer  "member_id"
    t.string   "title"
    t.text     "description"
    t.integer  "view_count",  default: 0
    t.boolean  "top",         default: false
    t.string   "device_id"
    t.boolean  "approved",    default: false
    t.boolean  "recommend",   default: false
    t.integer  "approved_by"
    t.integer  "order_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "shopping_lists", ["approved"], name: "index_shopping_lists_on_approved", using: :btree
  add_index "shopping_lists", ["member_id"], name: "index_shopping_lists_on_member_id", using: :btree
  add_index "shopping_lists", ["recommend"], name: "index_shopping_lists_on_recommend", using: :btree

  create_table "short_messages", force: true do |t|
    t.string   "phone"
    t.text     "content"
    t.string   "device_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "order_id"
    t.boolean  "sended",     default: false
  end

  create_table "suppliers", force: true do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tag_product_sorts", force: true do |t|
    t.integer  "tag_id"
    t.integer  "product_id"
    t.integer  "positoin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
    t.integer  "rank",                      default: 0
  end

  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: true do |t|
    t.string  "name"
    t.string  "image"
    t.integer "style"
    t.string  "category"
    t.integer "parent_id",      default: 0
    t.integer "lft",            default: 0
    t.integer "rgt",            default: 0
    t.integer "depth",          default: 0
    t.string  "keywords"
    t.integer "rank"
    t.boolean "visible",        default: true
    t.integer "taggings_count", default: 0
    t.string  "description"
    t.string  "background"
    t.boolean "banner",         default: false
    t.boolean "eailv_banner",   default: false
  end

  add_index "tags", ["category"], name: "index_tags_on_category", using: :btree

  create_table "task_loggings", force: true do |t|
    t.integer  "task_id"
    t.integer  "member_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "task_loggings", ["member_id"], name: "index_task_loggings_on_member_id", using: :btree
  add_index "task_loggings", ["task_id"], name: "index_task_loggings_on_task_id", using: :btree

  create_table "tasks", force: true do |t|
    t.string   "name"
    t.string   "action"
    t.integer  "value"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "ticket_histories", force: true do |t|
    t.integer  "workorder_id"
    t.integer  "user_id"
    t.string   "move"
    t.text     "move_info"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "topic_images", force: true do |t|
    t.integer  "topic_id"
    t.string   "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "topics", force: true do |t|
    t.string   "title"
    t.text     "body"
    t.integer  "node_id"
    t.string   "nickname"
    t.string   "device_id"
    t.integer  "replies_count", default: 0
    t.datetime "replied_at"
    t.integer  "likes_count",   default: 0
    t.integer  "unlikes_count", default: 0
    t.boolean  "lock",          default: false
    t.boolean  "top",           default: false
    t.datetime "deleted_at"
    t.string   "deleted_by"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.boolean  "best",          default: false
    t.boolean  "approved",      default: false
    t.integer  "member_id"
    t.datetime "bested_at"
    t.boolean  "recommend",     default: false
    t.integer  "forward_count", default: 0
    t.integer  "report_num",    default: 0
  end

  add_index "topics", ["approved"], name: "index_topics_on_approved", using: :btree
  add_index "topics", ["best"], name: "index_topics_on_best", using: :btree
  add_index "topics", ["deleted_at", "node_id", "approved", "best"], name: "index_topics_on_select", using: :btree
  add_index "topics", ["device_id"], name: "index_topics_on_device_id", using: :btree
  add_index "topics", ["member_id"], name: "index_topics_on_member_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "encrypted_password",                              default: "",  null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                                   default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                                    null: false
    t.datetime "updated_at",                                                    null: false
    t.string   "email",                                                         null: false
    t.string   "role"
    t.string   "username"
    t.string   "phone"
    t.string   "qq"
    t.string   "alipay"
    t.string   "openid"
    t.integer  "reviewed",                                        default: 0
    t.string   "identification"
    t.string   "invication_code"
    t.string   "invicated_from"
    t.decimal  "jm_debt",                precision: 10, scale: 2, default: 0.0
    t.integer  "supervisor_id",                                   default: 0
    t.string   "wechat"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["openid"], name: "index_users_on_openid", unique: true, using: :btree
  add_index "users", ["phone"], name: "index_users_on_phone", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "workorders", force: true do |t|
    t.string   "title"
    t.integer  "order_id"
    t.string   "status"
    t.string   "phone"
    t.string   "username"
    t.integer  "creater_id"
    t.integer  "handler_id"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "workorders", ["creater_id"], name: "index_workorders_on_creater_id", using: :btree
  add_index "workorders", ["handler_id"], name: "index_workorders_on_handler_id", using: :btree

end
