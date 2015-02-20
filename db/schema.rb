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

ActiveRecord::Schema.define(version: 20150219165353) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: :cascade do |t|
    t.text "eventName"
  end

  create_table "payloads", force: :cascade do |t|
    t.integer "user_id"
    t.integer "url_id"
    t.text    "requestedAt"
    t.integer "respondedIn"
    t.integer "referral_id"
    t.integer "request_id"
    t.text    "parameters"
    t.integer "event_id"
    t.integer "user_agent_id"
    t.integer "resolution_id"
    t.text    "ip"
  end

  create_table "referrals", force: :cascade do |t|
    t.text "referredBy"
  end

  create_table "requests", force: :cascade do |t|
    t.text "requestType"
  end

  create_table "resolutions", force: :cascade do |t|
    t.text "resolutionWidth"
    t.text "resolutionHeight"
  end

  create_table "urls", force: :cascade do |t|
    t.text "url"
  end

  create_table "user_agents", force: :cascade do |t|
    t.text "userAgent"
  end

  create_table "users", force: :cascade do |t|
    t.text     "identifier"
    t.text     "rootUrl"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
