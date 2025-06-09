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

ActiveRecord::Schema[8.0].define(version: 2025_06_08_160701) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "attendances", force: :cascade do |t|
    t.bigint "participant_id", null: false
    t.bigint "talk_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["participant_id", "talk_id"], name: "index_attendances_on_participant_id_and_talk_id", unique: true
    t.index ["participant_id"], name: "index_attendances_on_participant_id"
    t.index ["talk_id"], name: "index_attendances_on_talk_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "location"
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "feedbacks", force: :cascade do |t|
    t.text "comment"
    t.integer "rating"
    t.bigint "participant_id", null: false
    t.bigint "talk_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["participant_id", "talk_id"], name: "index_feedbacks_on_participant_id_and_talk_id", unique: true
    t.index ["participant_id"], name: "index_feedbacks_on_participant_id"
    t.index ["talk_id"], name: "index_feedbacks_on_talk_id"
  end

  create_table "participants", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.bigint "event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_participants_on_event_id"
  end

  create_table "talks", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "speaker"
    t.datetime "start_time"
    t.datetime "end_time"
    t.bigint "event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_talks_on_event_id"
  end

  add_foreign_key "attendances", "participants"
  add_foreign_key "attendances", "talks"
  add_foreign_key "feedbacks", "participants"
  add_foreign_key "feedbacks", "talks"
  add_foreign_key "participants", "events"
  add_foreign_key "talks", "events"
end
