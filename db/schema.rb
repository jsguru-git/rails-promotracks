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

ActiveRecord::Schema.define(version: 20170420105033) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "brands", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
  end

  add_index "brands", ["user_id"], name: "index_brands_on_user_id", using: :btree

  create_table "client_brands", id: false, force: :cascade do |t|
    t.integer "client_id"
    t.integer "brand_id"
  end

  add_index "client_brands", ["brand_id"], name: "index_client_brands_on_brand_id", using: :btree
  add_index "client_brands", ["client_id"], name: "index_client_brands_on_client_id", using: :btree

  create_table "clients", force: :cascade do |t|
    t.string "name"
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "event_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", force: :cascade do |t|
    t.string "name"
    t.string "type"
    t.datetime "start_time"
    t.datetime "end_time"
    t.string "area"
    t.string "attendance"
    t.integer "sample"
    t.float "product_cost"
    t.float "total_expense"
    t.string "notes"
    t.text "images", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.integer "brand_id"
    t.integer "group_id"
    t.integer "promo_category"
    t.integer "client_id"
    t.datetime "check_in"
    t.datetime "check_out"
    t.integer "max_users", default: 0
    t.integer "event_type_id"
  end

  add_index "events", ["brand_id"], name: "index_events_on_brand_id", using: :btree
  add_index "events", ["client_id"], name: "index_events_on_client_id", using: :btree
  add_index "events", ["event_type_id"], name: "index_events_on_event_type_id", using: :btree
  add_index "events", ["group_id"], name: "index_events_on_group_id", using: :btree
  add_index "events", ["user_id"], name: "index_events_on_user_id", using: :btree

  create_table "groups", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.integer "client_id"
  end

  add_index "groups", ["client_id"], name: "index_groups_on_client_id", using: :btree

  create_table "locations", force: :cascade do |t|
    t.string "formatted_address"
    t.string "address_1"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "country"
    t.float "latitude"
    t.float "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "event_id"
  end

  add_index "locations", ["event_id"], name: "index_locations_on_event_id", using: :btree

  create_table "user_events", force: :cascade do |t|
    t.integer "event_id"
    t.integer "user_id"
    t.string "token"
    t.integer "category", default: 0
    t.integer "status", default: 0
  end

  add_index "user_events", ["event_id"], name: "index_user_events_on_event_id", using: :btree
  add_index "user_events", ["user_id"], name: "index_user_events_on_user_id", using: :btree

  create_table "user_groups", force: :cascade do |t|
    t.integer "group_id"
    t.integer "user_id"
  end

  add_index "user_groups", ["group_id"], name: "index_user_groups_on_group_id", using: :btree
  add_index "user_groups", ["user_id"], name: "index_user_groups_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.integer "role", default: 0
    t.string "phone"
    t.integer "client_id"
    t.string "authentication_token", limit: 30
    t.string "token"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["client_id"], name: "index_users_on_client_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "brands", "users"
  add_foreign_key "events", "brands"
  add_foreign_key "events", "clients"
  add_foreign_key "events", "event_types"
  add_foreign_key "events", "groups"
  add_foreign_key "events", "users"
  add_foreign_key "groups", "clients"
  add_foreign_key "locations", "events"
  add_foreign_key "users", "clients"
end
