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

ActiveRecord::Schema.define(version: 2020_11_12_032231) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "auth_users", id: :serial, force: :cascade do |t|
    t.string "auth0_id_string", null: false
    t.string "password_digest"
    t.string "access_level"
    t.integer "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["auth0_id_string"], name: "index_auth_users_on_auth0_id_string", unique: true
    t.index ["person_id"], name: "index_auth_users_on_person_id"
  end

  create_table "delayed_jobs", id: :serial, force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "invitation_sets", id: :serial, force: :cascade do |t|
    t.integer "person_id", null: false
    t.string "invitation_text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_invitation_sets_on_person_id"
  end

  create_table "invitation_tokens", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "token_hash", null: false
    t.datetime "expires_at", null: false
    t.integer "invitation_set_id", null: false
    t.index ["invitation_set_id"], name: "index_invitation_tokens_on_invitation_set_id"
  end

  create_table "invitations", id: :serial, force: :cascade do |t|
    t.integer "invitation_set_id", null: false
    t.string "type", null: false
    t.string "invited_state", default: "not_sent", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invitation_set_id"], name: "index_invitations_on_invitation_set_id"
  end

  create_table "measurements", id: :serial, force: :cascade do |t|
    t.integer "questionnaire_id", null: false
    t.integer "protocol_id", null: false
    t.integer "period"
    t.integer "open_from_offset"
    t.integer "open_duration"
    t.integer "reward_points", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "offset_till_end"
    t.boolean "stop_measurement", default: false, null: false
    t.boolean "should_invite", default: true, null: false
    t.string "redirect_url"
    t.integer "reminder_delay", default: 28800
    t.string "open_from_day"
    t.integer "priority"
    t.boolean "collapse_duplicates", default: true, null: false
    t.index ["protocol_id"], name: "index_measurements_on_protocol_id"
    t.index ["questionnaire_id"], name: "index_measurements_on_questionnaire_id"
  end

  create_table "one_time_responses", id: :serial, force: :cascade do |t|
    t.string "token", null: false
    t.integer "protocol_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["protocol_id"], name: "index_one_time_responses_on_protocol_id"
    t.index ["token"], name: "one_time_response_token", unique: true
  end

  create_table "organizations", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_organizations_on_name", unique: true
  end

  create_table "people", id: :serial, force: :cascade do |t|
    t.string "mobile_phone"
    t.string "first_name", null: false
    t.string "last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "gender"
    t.string "email"
    t.integer "role_id", null: false
    t.string "external_identifier", null: false
    t.string "iban"
    t.string "ip_hash"
    t.boolean "account_active", default: false, null: false
    t.bigint "parent_id"
    t.string "locale", default: "nl"
    t.index ["email"], name: "index_people_on_email", unique: true
    t.index ["external_identifier"], name: "index_people_on_external_identifier", unique: true
    t.index ["mobile_phone"], name: "index_people_on_mobile_phone", unique: true
    t.index ["parent_id"], name: "index_people_on_parent_id"
  end

  create_table "protocol_subscriptions", id: :serial, force: :cascade do |t|
    t.integer "person_id", null: false
    t.integer "protocol_id", null: false
    t.string "state", null: false
    t.datetime "start_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "informed_consent_given_at"
    t.integer "filling_out_for_id", null: false
    t.datetime "end_date", null: false
    t.string "external_identifier"
    t.index ["person_id"], name: "index_protocol_subscriptions_on_person_id"
    t.index ["protocol_id"], name: "index_protocol_subscriptions_on_protocol_id"
  end

  create_table "protocol_transfers", id: :serial, force: :cascade do |t|
    t.integer "from_id", null: false
    t.integer "to_id", null: false
    t.integer "protocol_subscription_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["from_id"], name: "index_protocol_transfers_on_from_id"
    t.index ["protocol_subscription_id"], name: "index_protocol_transfers_on_protocol_subscription_id"
    t.index ["to_id"], name: "index_protocol_transfers_on_to_id"
  end

  create_table "protocols", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.integer "duration", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "informed_consent_questionnaire_id"
    t.string "invitation_text"
    t.index ["informed_consent_questionnaire_id"], name: "index_protocols_on_informed_consent_questionnaire_id"
    t.index ["name"], name: "index_protocols_on_name", unique: true
  end

  create_table "push_subscriptions", force: :cascade do |t|
    t.bigint "protocol_id", null: false
    t.string "url", null: false
    t.string "name", null: false
    t.string "method", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["protocol_id", "name"], name: "index_push_subscriptions_on_protocol_id_and_name", unique: true
    t.index ["protocol_id"], name: "index_push_subscriptions_on_protocol_id"
  end

  create_table "questionnaires", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.string "key", null: false
    t.index ["key"], name: "questionnaires_key", unique: true
    t.index ["name"], name: "index_questionnaires_on_name", unique: true
  end

  create_table "responses", id: :serial, force: :cascade do |t|
    t.integer "protocol_subscription_id", null: false
    t.integer "measurement_id", null: false
    t.string "content"
    t.datetime "open_from", null: false
    t.datetime "opened_at"
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "uuid", limit: 36, null: false
    t.integer "filled_out_for_id"
    t.integer "filled_out_by_id"
    t.integer "invitation_set_id"
    t.index ["filled_out_by_id"], name: "index_responses_on_filled_out_by_id"
    t.index ["filled_out_for_id"], name: "index_responses_on_filled_out_for_id"
    t.index ["invitation_set_id"], name: "index_responses_on_invitation_set_id"
    t.index ["measurement_id"], name: "index_responses_on_measurement_id"
    t.index ["protocol_subscription_id"], name: "index_responses_on_protocol_subscription_id"
    t.index ["uuid"], name: "index_responses_on_uuid", unique: true
  end

  create_table "rewards", id: :serial, force: :cascade do |t|
    t.integer "threshold", null: false
    t.integer "reward_points", null: false
    t.integer "protocol_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["protocol_id"], name: "index_rewards_on_protocol_id"
    t.index ["threshold", "protocol_id"], name: "index_rs_on_threshold_and_protocol_id", unique: true
  end

  create_table "roles", id: :serial, force: :cascade do |t|
    t.string "group", null: false
    t.string "title", null: false
    t.integer "team_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id", "title"], name: "index_roles_on_team_id_and_title", unique: true
    t.index ["team_id"], name: "index_roles_on_team_id"
  end

  create_table "teams", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "organization_id", null: false
    t.index ["name"], name: "index_teams_on_name", unique: true
  end

  add_foreign_key "auth_users", "people"
  add_foreign_key "invitation_sets", "people"
  add_foreign_key "invitation_tokens", "invitation_sets"
  add_foreign_key "invitations", "invitation_sets"
  add_foreign_key "measurements", "protocols"
  add_foreign_key "measurements", "questionnaires"
  add_foreign_key "one_time_responses", "protocols"
  add_foreign_key "protocol_subscriptions", "people"
  add_foreign_key "protocol_subscriptions", "protocols"
  add_foreign_key "protocol_transfers", "people", column: "from_id"
  add_foreign_key "protocol_transfers", "people", column: "to_id"
  add_foreign_key "protocol_transfers", "protocol_subscriptions"
  add_foreign_key "protocols", "questionnaires", column: "informed_consent_questionnaire_id"
  add_foreign_key "push_subscriptions", "protocols"
  add_foreign_key "responses", "invitation_sets"
  add_foreign_key "responses", "measurements"
  add_foreign_key "responses", "people", column: "filled_out_by_id"
  add_foreign_key "responses", "people", column: "filled_out_for_id"
  add_foreign_key "responses", "protocol_subscriptions"
  add_foreign_key "rewards", "protocols"
  add_foreign_key "roles", "teams"
end
