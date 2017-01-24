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

ActiveRecord::Schema.define(version: 20150917131224) do

  create_table "addresses", force: :cascade do |t|
    t.integer  "owner_id",   limit: 4,   null: false
    t.string   "line1",      limit: 255, null: false
    t.string   "line2",      limit: 255
    t.integer  "area_id",    limit: 4,   null: false
    t.string   "city",       limit: 255, null: false
    t.integer  "pin",        limit: 4,   null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "areas", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "cloth_types", force: :cascade do |t|
    t.string   "name",           limit: 255, null: false
    t.float    "laundry_price",  limit: 24,  null: false
    t.float    "dryclean_price", limit: 24,  null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "cloths", force: :cascade do |t|
    t.integer  "cloth_type_id", limit: 4,   null: false
    t.string   "wash_type",     limit: 255, null: false
    t.integer  "count",         limit: 4,   null: false
    t.integer  "order_id",      limit: 4,   null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "customer_id",         limit: 4,   null: false
    t.datetime "order_time",                      null: false
    t.integer  "laundry_store_id",    limit: 4
    t.integer  "dryclean_store_id",   limit: 4
    t.integer  "picker_id",           limit: 4
    t.datetime "pickup_time"
    t.integer  "dropper_id",          limit: 4
    t.datetime "drop_time"
    t.string   "status",              limit: 255
    t.datetime "wash_comeplete_time"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.date     "to_pick_date"
    t.time     "to_pick_time"
    t.integer  "address_id",          limit: 4,   null: false
  end

  create_table "stores", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.integer  "area_id",    limit: 4,   null: false
    t.string   "owner_id",   limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "operations", limit: 255
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "role",                   limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
