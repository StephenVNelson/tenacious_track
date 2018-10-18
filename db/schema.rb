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

ActiveRecord::Schema.define(version: 20181017222044) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "element_categories", force: :cascade do |t|
    t.string "category_name"
    t.integer "position_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sort"
  end

  create_table "elements", force: :cascade do |t|
    t.string "series_name"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "category_id"
    t.bigint "element_category_id"
    t.index ["element_category_id"], name: "index_elements_on_element_category_id"
    t.index ["name"], name: "index_elements_on_name", unique: true
    t.index ["series_name", "name"], name: "index_elements_on_series_name_and_name", unique: true
    t.index ["series_name"], name: "index_elements_on_series_name"
  end

  create_table "exercise_elements", force: :cascade do |t|
    t.integer "exercise_id"
    t.integer "element_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["element_id"], name: "index_exercise_elements_on_element_id"
    t.index ["exercise_id", "element_id"], name: "index_exercise_elements_on_exercise_id_and_element_id", unique: true
    t.index ["exercise_id"], name: "index_exercise_elements_on_exercise_id"
  end

  create_table "exercises", force: :cascade do |t|
    t.boolean "right_left_bool"
    t.boolean "reps_bool"
    t.boolean "resistance_bool"
    t.boolean "duration_bool"
    t.string "gif_link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "work_rest_bool"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "remember_digest"
    t.date "hire_date"
    t.boolean "admin", default: false
    t.string "activation_digest"
    t.boolean "activated"
    t.datetime "activated_at"
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "elements", "element_categories"
end
