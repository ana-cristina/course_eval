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

ActiveRecord::Schema.define(version: 2020_04_10_180216) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_incognito_users", id: :serial, force: :cascade do |t|
    t.datetime "start_date"
    t.string "incognito_user_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "activities", id: :serial, force: :cascade do |t|
    t.integer "course_id"
    t.integer "cohort_id"
    t.boolean "is_optional"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "teacher_id"
    t.integer "year"
    t.integer "semester"
    t.string "activity_type"
    t.index ["cohort_id"], name: "index_activities_on_cohort_id"
    t.index ["course_id"], name: "index_activities_on_course_id"
    t.index ["teacher_id"], name: "index_activities_on_teacher_id"
  end

  create_table "cohorts", id: :serial, force: :cascade do |t|
    t.string "name"
    t.boolean "is_terminal"
    t.integer "students_number"
    t.integer "optionals_number", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "department_id"
    t.integer "year"
    t.index ["department_id"], name: "index_cohorts_on_department_id"
  end

  create_table "completed_evaluations", id: :serial, force: :cascade do |t|
    t.string "incognito_token"
    t.text "content"
    t.integer "time"
    t.datetime "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "eval_session_activity_id"
    t.index ["eval_session_activity_id"], name: "index_completed_evaluations_on_eval_session_activity_id"
  end

  create_table "courses", id: :serial, force: :cascade do |t|
    t.string "title"
    t.string "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "department_id"
    t.index ["department_id"], name: "index_courses_on_department_id"
  end

  create_table "departments", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "eval_session_activities", id: :serial, force: :cascade do |t|
    t.integer "course_id"
    t.integer "evaluation_session_cohort_id"
    t.boolean "is_optional"
    t.integer "teacher_id"
    t.integer "year"
    t.integer "semester"
    t.string "activity_type"
    t.integer "evaluation_session_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_eval_session_activities_on_course_id"
    t.index ["evaluation_session_cohort_id"], name: "index_eval_session_activities_on_evaluation_session_cohort_id"
    t.index ["evaluation_session_id"], name: "index_eval_session_activities_on_evaluation_session_id"
    t.index ["teacher_id"], name: "index_eval_session_activities_on_teacher_id"
  end

  create_table "evaluation_session_cohorts", id: :serial, force: :cascade do |t|
    t.string "name"
    t.boolean "is_terminal"
    t.integer "students_number"
    t.integer "optionals_number"
    t.integer "department_id"
    t.integer "evaluation_session_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_evaluation_session_cohorts_on_department_id"
    t.index ["evaluation_session_id"], name: "index_evaluation_session_cohorts_on_evaluation_session_id"
  end

  create_table "evaluation_sessions", id: :serial, force: :cascade do |t|
    t.date "start_date"
    t.date "end_date"
    t.integer "year"
    t.integer "semester"
    t.string "status"
    t.boolean "terminal"
    t.integer "form_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "last_refresh"
    t.integer "formS_id"
    t.integer "formL_id"
    t.integer "formA_id"
    t.boolean "visibility", default: false
    t.integer "formP_id"
    t.index ["form_id"], name: "index_evaluation_sessions_on_form_id"
  end

  create_table "forms", id: :serial, force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "incognito_users", id: :serial, force: :cascade do |t|
    t.string "token"
    t.integer "evaluation_session_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "evaluation_session_cohort_id"
    t.index ["evaluation_session_cohort_id"], name: "index_incognito_users_on_evaluation_session_cohort_id"
    t.index ["evaluation_session_id"], name: "index_incognito_users_on_evaluation_session_id"
  end

  create_table "teachers", id: :serial, force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.integer "uuid"
    t.string "department"
  end

  create_table "users", primary_key: "uid", id: :serial, force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "status"
    t.string "email"
    t.string "is_student"
    t.string "is_teacher"
    t.string "is_management"
    t.string "is_admin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "token"
    t.string "password_digest"
  end

  add_foreign_key "activities", "cohorts"
  add_foreign_key "activities", "courses"
  add_foreign_key "activities", "teachers"
  add_foreign_key "cohorts", "departments"
  add_foreign_key "completed_evaluations", "eval_session_activities"
  add_foreign_key "courses", "departments"
  add_foreign_key "eval_session_activities", "courses"
  add_foreign_key "eval_session_activities", "evaluation_session_cohorts"
  add_foreign_key "eval_session_activities", "evaluation_sessions"
  add_foreign_key "eval_session_activities", "teachers"
  add_foreign_key "evaluation_session_cohorts", "departments"
  add_foreign_key "evaluation_session_cohorts", "evaluation_sessions"
  add_foreign_key "evaluation_sessions", "forms"
  add_foreign_key "incognito_users", "evaluation_session_cohorts"
  add_foreign_key "incognito_users", "evaluation_sessions"
end
