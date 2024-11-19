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

ActiveRecord::Schema[7.1].define(version: 2024_11_19_012613) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "buildings", force: :cascade do |t|
    t.string "name"
    t.float "wage_cost_per_hour"
    t.float "construction_price"
    t.string "description"
    t.integer "map_buildings_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_link"
  end

  create_table "comments", force: :cascade do |t|
    t.integer "user_id"
    t.string "comment_text"
    t.integer "map_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "executives", force: :cascade do |t|
    t.integer "name"
    t.integer "map_id"
    t.integer "position"
    t.integer "operations_level"
    t.integer "finance_level"
    t.integer "marketing_level"
    t.integer "research_level"
    t.float "salary"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "likes", force: :cascade do |t|
    t.integer "user_id"
    t.integer "map_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "map_buildings", force: :cascade do |t|
    t.integer "map_id"
    t.integer "building_id"
    t.integer "position_id"
    t.integer "level"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "production_time"
    t.integer "quality_level"
    t.integer "product_id"
    t.integer "production_buildings_count"
  end

  create_table "maps", force: :cascade do |t|
    t.integer "owner_id"
    t.string "name"
    t.integer "map_buildings_count"
    t.integer "executives_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "prices", force: :cascade do |t|
    t.integer "resource_id"
    t.string "quality_level"
    t.float "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "resourcedependencies", force: :cascade do |t|
    t.integer "product_id"
    t.integer "input_id"
    t.float "quantity_required"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "resources", force: :cascade do |t|
    t.string "name"
    t.float "transport_amount"
    t.integer "building_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_link"
    t.decimal "units_per_hour"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "maps_count"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
