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

ActiveRecord::Schema.define(version: 20140617110220) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: true do |t|
    t.integer  "user_id"
    t.integer  "question_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "accepted",    default: false
  end

  add_index "answers", ["question_id"], name: "index_answers_on_question_id", using: :btree
  add_index "answers", ["user_id"], name: "index_answers_on_user_id", using: :btree

  create_table "attachments", force: true do |t|
    t.string   "file"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "attachable_id"
    t.string   "attachable_type"
  end

  create_table "authorizations", force: true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bounties", force: true do |t|
    t.integer "question_id"
    t.integer "winner_id"
    t.integer "value"
  end

  add_index "bounties", ["question_id"], name: "index_bounties_on_question_id", using: :btree
  add_index "bounties", ["winner_id"], name: "index_bounties_on_winner_id", using: :btree

  create_table "comments", force: true do |t|
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "comments", ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "favorites", force: true do |t|
    t.integer "user_id"
    t.integer "favorable_id"
    t.string  "favorable_type"
  end

  add_index "favorites", ["favorable_id", "favorable_type"], name: "index_favorites_on_favorable_id_and_favorable_type", using: :btree
  add_index "favorites", ["user_id"], name: "index_favorites_on_user_id", using: :btree

  create_table "impressions", force: true do |t|
    t.string   "impressionable_type"
    t.integer  "impressionable_id"
    t.integer  "user_id"
    t.string   "controller_name"
    t.string   "action_name"
    t.string   "view_name"
    t.string   "request_hash"
    t.string   "ip_address"
    t.string   "session_hash"
    t.text     "message"
    t.text     "referrer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "impressions", ["controller_name", "action_name", "ip_address"], name: "controlleraction_ip_index", using: :btree
  add_index "impressions", ["controller_name", "action_name", "request_hash"], name: "controlleraction_request_index", using: :btree
  add_index "impressions", ["controller_name", "action_name", "session_hash"], name: "controlleraction_session_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "ip_address"], name: "poly_ip_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "request_hash"], name: "poly_request_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "session_hash"], name: "poly_session_index", using: :btree
  add_index "impressions", ["impressionable_type", "message", "impressionable_id"], name: "impressionable_type_message_index", using: :btree
  add_index "impressions", ["user_id"], name: "index_impressions_on_user_id", using: :btree

  create_table "profiles", force: true do |t|
    t.integer  "user_id"
    t.string   "real_name"
    t.string   "website"
    t.string   "location"
    t.datetime "birthday"
    t.text     "about"
  end

  add_index "profiles", ["user_id"], name: "index_profiles_on_user_id", using: :btree

  create_table "questions", force: true do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "status",        default: 0
    t.integer  "answers_count", default: 0
    t.integer  "views_count",   default: 0, null: false
  end

  add_index "questions", ["user_id"], name: "index_questions_on_user_id", using: :btree

  create_table "questions_tags", id: false, force: true do |t|
    t.integer "question_id"
    t.integer "tag_id"
  end

  add_index "questions_tags", ["question_id"], name: "index_questions_tags_on_question_id", using: :btree
  add_index "questions_tags", ["tag_id"], name: "index_questions_tags_on_tag_id", using: :btree

  create_table "tags", force: true do |t|
    t.string   "name"
    t.text     "excerpt"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "questions_count", default: 0, null: false
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email",                  default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "avatar"
    t.integer  "reputation",             default: 0,  null: false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "votes", force: true do |t|
    t.integer "user_id"
    t.integer "voteable_id"
    t.string  "voteable_type"
    t.integer "value"
  end

  add_index "votes", ["user_id"], name: "index_votes_on_user_id", using: :btree
  add_index "votes", ["voteable_id", "voteable_type"], name: "index_votes_on_voteable_id_and_voteable_type", using: :btree

end
