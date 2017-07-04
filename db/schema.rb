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

ActiveRecord::Schema.define(version: 20170702142456) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "brands", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "user_id"
    t.boolean  "deleted",     default: false
    t.float    "unit_cost",   default: 0.0
    t.index ["user_id"], name: "index_brands_on_user_id", using: :btree
  end

  create_table "client_brands", id: false, force: :cascade do |t|
    t.integer "client_id"
    t.integer "brand_id"
    t.index ["brand_id"], name: "index_client_brands_on_brand_id", using: :btree
    t.index ["client_id"], name: "index_client_brands_on_client_id", using: :btree
  end

  create_table "clients", force: :cascade do |t|
    t.string   "name"
    t.string   "phone"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "admin_id"
    t.float    "payment",    default: 0.0
    t.index ["admin_id"], name: "index_clients_on_admin_id", using: :btree
  end

  create_table "clients_groups", id: false, force: :cascade do |t|
    t.integer "client_id"
    t.integer "group_id"
  end

  create_table "clients_users", id: false, force: :cascade do |t|
    t.integer "client_id"
    t.integer "user_id"
  end

  create_table "contacts", force: :cascade do |t|
    t.jsonb    "details",    default: {}
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "event_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", force: :cascade do |t|
    t.string   "name"
    t.string   "type"
    t.datetime "start_time"
    t.datetime "end_time"
    t.string   "area"
    t.float    "product_cost"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "user_id"
    t.integer  "group_id"
    t.integer  "promo_category", default: 0
    t.integer  "client_id"
    t.integer  "max_users",      default: 0
    t.integer  "event_type_id"
    t.float    "pay",            default: 0.0
    t.integer  "brand_id"
    t.boolean  "deleted",        default: false
    t.string   "notes"
    t.index ["brand_id"], name: "index_events_on_brand_id", using: :btree
    t.index ["client_id"], name: "index_events_on_client_id", using: :btree
    t.index ["event_type_id"], name: "index_events_on_event_type_id", using: :btree
    t.index ["group_id"], name: "index_events_on_group_id", using: :btree
    t.index ["user_id"], name: "index_events_on_user_id", using: :btree
  end

  create_table "group_members", force: :cascade do |t|
    t.integer "group_id"
    t.integer "user_id"
    t.index ["group_id"], name: "index_group_members_on_group_id", using: :btree
    t.index ["user_id"], name: "index_group_members_on_user_id", using: :btree
  end

  create_table "groups", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
  end

  create_table "locations", force: :cascade do |t|
    t.string   "formatted_address"
    t.string   "address_1"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "country"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "event_id"
    t.string   "time_zone"
    t.index ["event_id"], name: "index_locations_on_event_id", using: :btree
  end

  create_table "user_events", force: :cascade do |t|
    t.integer  "event_id"
    t.integer  "user_id"
    t.string   "token"
    t.integer  "category",      default: 0
    t.integer  "status",        default: 0
    t.string   "notes"
    t.boolean  "recommended"
    t.datetime "check_in"
    t.datetime "check_out"
    t.text     "images",        default: [],    array: true
    t.string   "follow_up"
    t.integer  "attendance",    default: 0
    t.integer  "sample",        default: 0
    t.boolean  "deleted",       default: false
    t.float    "total_expense", default: 0.0
    t.boolean  "recap"
    t.index ["event_id"], name: "index_user_events_on_event_id", using: :btree
    t.index ["user_id"], name: "index_user_events_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                             default: "",    null: false
    t.string   "encrypted_password",                default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                     default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "role",                              default: 0
    t.string   "phone"
    t.string   "authentication_token",   limit: 30
    t.string   "token"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.string   "invited_by_type"
    t.integer  "invited_by_id"
    t.integer  "invitations_count",                 default: 0
    t.string   "image"
    t.integer  "group_id"
    t.string   "area"
    t.boolean  "deleted",                           default: false
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["group_id"], name: "index_users_on_group_id", using: :btree
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
    t.index ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "brands", "users"
  add_foreign_key "clients", "users", column: "admin_id"
  add_foreign_key "events", "brands"
  add_foreign_key "events", "clients"
  add_foreign_key "events", "event_types"
  add_foreign_key "events", "groups"
  add_foreign_key "events", "users"
  add_foreign_key "locations", "events"
  add_foreign_key "users", "groups"
end
