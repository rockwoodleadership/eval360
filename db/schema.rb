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

ActiveRecord::Schema.define(version: 20190630182414) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", id: :serial, force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_id", null: false
    t.string "resource_type", null: false
    t.string "author_type"
    t.integer "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "admin_users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "answers", id: :serial, force: :cascade do |t|
    t.integer "question_id"
    t.integer "evaluation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "numeric_response"
    t.text "text_response"
    t.index ["question_id", "evaluation_id"], name: "index_answers_on_question_id_and_evaluation_id"
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "evaluations", id: :serial, force: :cascade do |t|
    t.integer "participant_id"
    t.string "access_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "evaluator_id"
    t.boolean "completed"
    t.boolean "self_eval", default: false
    t.index ["access_key"], name: "index_evaluations_on_access_key"
  end

  create_table "evaluators", id: :serial, force: :cascade do |t|
    t.string "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "actable_type"
    t.integer "actable_id"
    t.boolean "declined", default: false
    t.index ["actable_type", "actable_id"], name: "index_evaluators_on_actable_type_and_actable_id"
  end

  create_table "legacy_mean_scores", id: :serial, force: :cascade do |t|
    t.string "key"
    t.float "value"
    t.string "questionnaire_tag"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_legacy_mean_scores_on_key"
  end

  create_table "participants", id: :serial, force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "evaluation_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "training_id"
    t.string "access_key"
    t.string "sf_registration_id"
    t.string "sf_contact_id"
    t.date "assessment_sent_date"
    t.date "peer_assessment_sent_date"
    t.date "reminder_for_peer_assessment_sent_date"
    t.date "assessment_reminder_sent_date"
    t.date "assessment_complete_date"
    t.boolean "do_not_remind", default: false
    t.string "preferred_name"
    t.index ["access_key"], name: "index_participants_on_access_key"
  end

  create_table "questionnaire_templates", id: :serial, force: :cascade do |t|
    t.integer "questionnaire_id"
    t.integer "section_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "questionnaires", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
  end

  create_table "questions", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "answer_type"
    t.text "description"
    t.text "self_description"
    t.integer "section_id"
    t.string "legacy_tag"
  end

  create_table "sections", id: :serial, force: :cascade do |t|
    t.text "header"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "trainings", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string "status"
    t.integer "questionnaire_id"
    t.string "sf_training_id"
    t.string "city"
    t.string "state"
    t.datetime "deadline"
    t.string "curriculum"
    t.string "site_name"
    t.boolean "no_invite", default: false
  end

end
