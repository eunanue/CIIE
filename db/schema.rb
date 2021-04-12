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

ActiveRecord::Schema.define(version: 2021_02_25_221902) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "academic_areas", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "academic_levels", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "contribution_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "url"
    t.string "en_url"
    t.boolean "edtech", default: false
  end

  create_table "countries", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "evaluation_criteria", force: :cascade do |t|
    t.bigint "contribution_type_id", null: false
    t.integer "order"
    t.text "description"
    t.text "english_description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["contribution_type_id"], name: "index_evaluation_criteria_on_contribution_type_id"
  end

  create_table "evaluations", force: :cascade do |t|
    t.bigint "paper_id", null: false
    t.bigint "user_id", null: false
    t.boolean "veredict"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "feedback"
    t.index ["paper_id"], name: "index_evaluations_on_paper_id"
    t.index ["user_id"], name: "index_evaluations_on_user_id"
  end

  create_table "institution_privacies", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "institution_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "institutions", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "marks", force: :cascade do |t|
    t.bigint "evaluation_id", null: false
    t.bigint "evaluation_criterium_id", null: false
    t.integer "score"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["evaluation_criterium_id"], name: "index_marks_on_evaluation_criterium_id"
    t.index ["evaluation_id"], name: "index_marks_on_evaluation_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.text "content"
    t.string "url"
    t.boolean "seen"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "paper_subtopics", force: :cascade do |t|
    t.bigint "paper_topic_id", null: false
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["paper_topic_id"], name: "index_paper_subtopics_on_paper_topic_id"
  end

  create_table "paper_topics", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "paper_users", force: :cascade do |t|
    t.bigint "paper_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["paper_id"], name: "index_paper_users_on_paper_id"
    t.index ["user_id"], name: "index_paper_users_on_user_id"
  end

  create_table "papers", force: :cascade do |t|
    t.string "name"
    t.string "file"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "contribution_type_id", null: false
    t.bigint "academic_level_id", null: false
    t.bigint "academic_area_id", null: false
    t.string "keywords"
    t.text "brief"
    t.boolean "used_before"
    t.text "relevance"
    t.bigint "paper_topic_id", null: false
    t.integer "owner_id"
    t.bigint "paper_subtopic_id"
    t.string "academic_level_other"
    t.string "academic_area_other"
    t.bigint "used_before_option_id", null: false
    t.string "subtopic_other"
    t.integer "evaluator1_id"
    t.integer "evaluator2_id"
    t.integer "evaluator3_id"
    t.string "generation", default: "2020"
    t.index ["academic_area_id"], name: "index_papers_on_academic_area_id"
    t.index ["academic_level_id"], name: "index_papers_on_academic_level_id"
    t.index ["contribution_type_id"], name: "index_papers_on_contribution_type_id"
    t.index ["paper_subtopic_id"], name: "index_papers_on_paper_subtopic_id"
    t.index ["paper_topic_id"], name: "index_papers_on_paper_topic_id"
    t.index ["used_before_option_id"], name: "index_papers_on_used_before_option_id"
  end

  create_table "states", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "used_before_options", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "user_paper_topics", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "paper_topic_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["paper_topic_id"], name: "index_user_paper_topics_on_paper_topic_id"
    t.index ["user_id"], name: "index_user_paper_topics_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "role", default: 1
    t.string "names"
    t.string "last_names"
    t.string "phone"
    t.bigint "institution_id", null: false
    t.string "locale", default: "es"
    t.string "institution_name"
    t.bigint "institution_privacy_id"
    t.bigint "institution_type_id"
    t.bigint "country_id"
    t.bigint "state_id"
    t.boolean "evaluator", default: false
    t.boolean "invitation_sent", default: false
    t.string "code"
    t.index ["country_id"], name: "index_users_on_country_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["institution_id"], name: "index_users_on_institution_id"
    t.index ["institution_privacy_id"], name: "index_users_on_institution_privacy_id"
    t.index ["institution_type_id"], name: "index_users_on_institution_type_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["state_id"], name: "index_users_on_state_id"
  end

  add_foreign_key "evaluation_criteria", "contribution_types"
  add_foreign_key "evaluations", "papers"
  add_foreign_key "evaluations", "users"
  add_foreign_key "marks", "evaluation_criteria"
  add_foreign_key "marks", "evaluations"
  add_foreign_key "notifications", "users"
  add_foreign_key "paper_subtopics", "paper_topics"
  add_foreign_key "paper_users", "papers"
  add_foreign_key "paper_users", "users"
  add_foreign_key "papers", "academic_areas"
  add_foreign_key "papers", "academic_levels"
  add_foreign_key "papers", "contribution_types"
  add_foreign_key "papers", "paper_subtopics"
  add_foreign_key "papers", "paper_topics"
  add_foreign_key "papers", "used_before_options"
  add_foreign_key "user_paper_topics", "paper_topics"
  add_foreign_key "user_paper_topics", "users"
  add_foreign_key "users", "countries"
  add_foreign_key "users", "institution_privacies"
  add_foreign_key "users", "institution_types"
  add_foreign_key "users", "institutions"
  add_foreign_key "users", "states"
end
