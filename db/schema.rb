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

ActiveRecord::Schema.define(version: 20150309144553) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "language_ranks", id: false, force: :cascade do |t|
    t.text    "language"
    t.text    "country"
    t.text    "city"
    t.decimal "score"
    t.integer "city_rank",          limit: 8
    t.integer "country_rank",       limit: 8
    t.integer "world_rank",         limit: 8
    t.integer "repository_count",   limit: 8
    t.integer "stars_count",        limit: 8
    t.integer "user_id"
    t.integer "city_user_count",    limit: 8
    t.integer "country_user_count", limit: 8
    t.integer "world_user_count",   limit: 8
  end

  add_index "language_ranks", ["language", "city_rank", "city"], name: "language_ranks_city", using: :btree
  add_index "language_ranks", ["language", "country_rank", "country"], name: "language_ranks_country", using: :btree
  add_index "language_ranks", ["language", "world_rank"], name: "language_ranks_world", using: :btree
  add_index "language_ranks", ["user_id"], name: "language_ranks_user_id", using: :btree

  create_table "repositories", force: :cascade do |t|
    t.string   "name",                         null: false
    t.integer  "stars",        default: 0,     null: false
    t.string   "language"
    t.string   "organization"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "github_id"
    t.boolean  "forked",       default: false, null: false
    t.boolean  "processed",    default: false, null: false
    t.integer  "user_id",                      null: false
  end

  add_index "repositories", ["user_id", "language", "stars"], name: "index_repositories_on_user_id_and_language_and_stars", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "login",                        null: false
    t.string   "name"
    t.string   "company"
    t.string   "blog"
    t.string   "gravatar_url"
    t.string   "location"
    t.string   "country"
    t.string   "city"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "github_id"
    t.boolean  "processed",    default: false, null: false
    t.boolean  "organization", default: false, null: false
  end

  add_index "users", ["city"], name: "index_users_on_city", using: :btree
  add_index "users", ["country"], name: "index_users_on_country", using: :btree
  add_index "users", ["location"], name: "index_users_on_location", using: :btree
  add_index "users", ["login", "city"], name: "index_users_on_login_and_city", using: :btree
  add_index "users", ["login", "country"], name: "index_users_on_login_and_country", using: :btree
  add_index "users", ["login"], name: "index_users_on_login", unique: true, using: :btree
  add_index "users", ["processed"], name: "index_users_on_processed", using: :btree

end
