# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_10_20_015021) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "edges", force: :cascade do |t|
    t.bigint "question_id"
    t.bigint "child_id"
    t.bigint "sibling_id"
    t.index ["child_id"], name: "index_edges_on_child_id"
    t.index ["question_id"], name: "index_edges_on_question_id"
    t.index ["sibling_id"], name: "index_edges_on_sibling_id"
  end

  create_table "questions", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "question"
    t.string "options", default: [], array: true
    t.boolean "is_root"
  end
 
  add_foreign_key "edges", "questions"
  add_foreign_key "edges", "questions", column: "child_id"
  add_foreign_key "edges", "questions", column: "sibling_id"
end
