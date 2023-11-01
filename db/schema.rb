# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_11_01_123049) do
  create_table "addresses", force: :cascade do |t|
    t.string "street"
    t.integer "number"
    t.string "neighborhood"
    t.string "city"
    t.string "state"
    t.string "postal_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "inn_id"
    t.index ["inn_id"], name: "index_addresses_on_inn_id"
  end

  create_table "inns", force: :cascade do |t|
    t.string "name"
    t.string "corporate_name"
    t.string "registration_number"
    t.string "phone"
    t.string "email"
    t.string "description"
    t.string "pay_methods"
    t.boolean "pet_friendly", default: false
    t.string "user_policies"
    t.time "check_in_time"
    t.time "check_out_time"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "owner_id", null: false
    t.index ["corporate_name"], name: "index_inns_on_corporate_name", unique: true
    t.index ["email"], name: "index_inns_on_email", unique: true
    t.index ["owner_id"], name: "index_inns_on_owner_id"
    t.index ["registration_number"], name: "index_inns_on_registration_number", unique: true
  end

  create_table "owners", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_owners_on_email", unique: true
    t.index ["reset_password_token"], name: "index_owners_on_reset_password_token", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "addresses", "inns"
  add_foreign_key "addresses", "inns"
  add_foreign_key "inns", "owners"
end
