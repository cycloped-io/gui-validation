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

ActiveRecord::Schema.define(version: 20151128223847) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "datasets", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "relation"
    t.string   "language"
  end

  create_table "datasets_users", id: false, force: :cascade do |t|
    t.integer "dataset_id"
    t.integer "user_id"
  end

  add_index "datasets_users", ["dataset_id", "user_id"], name: "index_datasets_users_on_dataset_id_and_user_id", unique: true, using: :btree
  add_index "datasets_users", ["dataset_id"], name: "index_datasets_users_on_dataset_id", using: :btree
  add_index "datasets_users", ["user_id"], name: "index_datasets_users_on_user_id", using: :btree

  create_table "decisions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "statement_id"
    t.string   "value"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "dataset_id"
    t.integer  "position"
  end

  add_index "decisions", ["dataset_id"], name: "index_decisions_on_dataset_id", using: :btree
  add_index "decisions", ["statement_id"], name: "index_decisions_on_statement_id", using: :btree
  add_index "decisions", ["user_id", "statement_id"], name: "index_decisions_on_user_id_and_statement_id", unique: true, using: :btree
  add_index "decisions", ["user_id"], name: "index_decisions_on_user_id", using: :btree

  create_table "statements", force: :cascade do |t|
    t.string   "cyc_name"
    t.string   "cyc_id"
    t.string   "wikipedia_name"
    t.string   "wikipedia_language"
    t.string   "relation"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "dataset_id"
  end

  add_index "statements", ["dataset_id"], name: "index_statements_on_dataset_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "datasets_users", "datasets"
  add_foreign_key "datasets_users", "users"
  add_foreign_key "decisions", "datasets"
  add_foreign_key "decisions", "statements"
  add_foreign_key "decisions", "users"
  add_foreign_key "statements", "datasets"
end
