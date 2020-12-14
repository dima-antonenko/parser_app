class CreateBQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :b_questions do |t|
      t.string :title_ru, index: true
      t.string :title_en, index: true
      t.boolean :answer, index: true, null: false, default: false
      t.boolean :deleted, index: true, null: false, default: false
    end
  end
end
