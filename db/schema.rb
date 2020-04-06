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

ActiveRecord::Schema.define(version: 2020_04_06_215014) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "flowchart_icon_helpers", force: :cascade do |t|
    t.bigint "flowchart_node_id"
    t.bigint "flowchart_icon_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["flowchart_icon_id"], name: "index_flowchart_icon_helpers_on_flowchart_icon_id"
    t.index ["flowchart_node_id"], name: "index_flowchart_icon_helpers_on_flowchart_node_id"
  end

  create_table "flowchart_icons", force: :cascade do |t|
    t.string "url", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "flowchart_nodes", force: :cascade do |t|
    t.text "text", null: false
    t.string "header", null: false
    t.string "button_text"
    t.string "next_question"
    t.bigint "child_id"
    t.bigint "sibling_id"
    t.boolean "is_root", null: false
    t.bigint "flowchart_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "deleted", default: false, null: false
    t.bigint "flowchart_node_id"
    t.boolean "is_leaf", default: false, null: false
    t.string "breadcrumb_title"
    t.index ["child_id"], name: "index_flowchart_nodes_on_child_id"
    t.index ["flowchart_id"], name: "index_flowchart_nodes_on_flowchart_id"
    t.index ["flowchart_node_id"], name: "index_flowchart_nodes_on_flowchart_node_id"
    t.index ["sibling_id"], name: "index_flowchart_nodes_on_sibling_id"
  end

  create_table "flowcharts", force: :cascade do |t|
    t.string "title", null: false
    t.string "description", null: false
    t.integer "height", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "root_id"
    t.boolean "deleted", default: false, null: false
    t.index ["root_id"], name: "index_flowcharts_on_root_id"
  end

  create_table "questions", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "flowchart_nodes", "flowchart_nodes"
  add_foreign_key "flowchart_nodes", "flowchart_nodes", column: "child_id"
  add_foreign_key "flowchart_nodes", "flowchart_nodes", column: "sibling_id"
  add_foreign_key "flowchart_nodes", "flowcharts"
  add_foreign_key "flowcharts", "flowchart_nodes", column: "root_id"
end
