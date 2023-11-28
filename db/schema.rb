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

ActiveRecord::Schema[7.0].define(version: 2023_11_28_124556) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "addresses", force: :cascade do |t|
    t.string "street"
    t.string "number"
    t.string "neighborhood"
    t.string "city"
    t.string "state"
    t.string "postal_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "inn_id"
    t.string "street_ascii"
    t.string "neighborhood_ascii"
    t.string "city_ascii"
    t.index ["inn_id"], name: "index_addresses_on_inn_id"
  end

  create_table "bookings", force: :cascade do |t|
    t.integer "room_id", null: false
    t.integer "user_id"
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.datetime "check_in"
    t.datetime "check_out"
    t.decimal "bill"
    t.integer "status", default: 0, null: false
    t.integer "number_of_guests", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "code"
    t.string "pay_method"
    t.index ["code"], name: "index_bookings_on_code", unique: true
    t.index ["room_id"], name: "index_bookings_on_room_id"
    t.index ["user_id"], name: "index_bookings_on_user_id"
  end

  create_table "inns", force: :cascade do |t|
    t.string "name", null: false
    t.string "corporate_name", null: false
    t.string "registration_number", null: false
    t.string "phone", null: false
    t.string "email", null: false
    t.string "description"
    t.string "pay_methods", null: false
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

  create_table "reviews", force: :cascade do |t|
    t.integer "score", null: false
    t.string "message"
    t.integer "booking_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "answer"
    t.index ["booking_id"], name: "index_reviews_on_booking_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.integer "size", null: false
    t.integer "max_guests", null: false
    t.decimal "price", precision: 10, scale: 2, null: false
    t.boolean "bathroom", default: false
    t.boolean "porch", default: false
    t.boolean "air_conditioner", default: false
    t.boolean "tv", default: false
    t.boolean "wardrobe", default: false
    t.boolean "safe", default: false
    t.boolean "wifi", default: false
    t.boolean "accessibility", default: false
    t.integer "inn_id", null: false
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["inn_id"], name: "index_rooms_on_inn_id"
  end

  create_table "seasonal_prices", force: :cascade do |t|
    t.integer "room_id", null: false
    t.date "start", null: false
    t.date "end", null: false
    t.decimal "price", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_seasonal_prices_on_room_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", default: "", null: false
    t.string "cpf", default: "", null: false
    t.index ["cpf"], name: "index_users_on_cpf", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "addresses", "inns"
  add_foreign_key "addresses", "inns"
  add_foreign_key "bookings", "rooms"
  add_foreign_key "bookings", "users"
  add_foreign_key "inns", "owners"
  add_foreign_key "reviews", "bookings"
  add_foreign_key "rooms", "inns"
  add_foreign_key "seasonal_prices", "rooms"
end
