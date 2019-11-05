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

ActiveRecord::Schema.define(version: 2019_11_05_020642) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "flowchart_nodes", force: :cascade do |t|
    t.string "text", null: false
    t.string "header", null: false
    t.string "button_text"
    t.string "next_question"
    t.bigint "child_id_id"
    t.bigint "sibling_id_id"
    t.boolean "is_root", null: false
    t.bigint "flowchart_id_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["child_id_id"], name: "index_flowchart_nodes_on_child_id_id"
    t.index ["flowchart_id_id"], name: "index_flowchart_nodes_on_flowchart_id_id"
    t.index ["sibling_id_id"], name: "index_flowchart_nodes_on_sibling_id_id"
  end

  create_table "flowcharts", force: :cascade do |t|
    t.string "title", null: false
    t.string "description", null: false
    t.integer "height", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "questions", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "flowchart_nodes", "flowchart_nodes", column: "child_id_id"
  add_foreign_key "flowchart_nodes", "flowchart_nodes", column: "sibling_id_id"
  add_foreign_key "flowchart_nodes", "flowcharts", column: "flowchart_id_id"
end
