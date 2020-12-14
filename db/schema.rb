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

ActiveRecord::Schema.define(version: 2020_12_14_150047) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "b_questions", force: :cascade do |t|
    t.string "title_ru"
    t.string "title_en"
    t.boolean "answer", default: false, null: false
    t.boolean "deleted", default: false, null: false
    t.index ["answer"], name: "index_b_questions_on_answer"
    t.index ["deleted"], name: "index_b_questions_on_deleted"
    t.index ["title_en"], name: "index_b_questions_on_title_en"
    t.index ["title_ru"], name: "index_b_questions_on_title_ru"
  end

  create_table "questions", id: :integer, default: nil, force: :cascade do |t|
    t.integer "tour_id"
    t.string "title"
    t.string "answer"
    t.string "title_en"
    t.string "answer_en"
    t.string "answer_wrong_1_ru"
    t.string "answer_wrong_2_ru"
    t.string "answer_wrong_3_ru"
    t.string "answer_wrong_1_en"
    t.string "answer_wrong_2_en"
    t.string "answer_wrong_3_en"
    t.boolean "deteled"
  end

end
