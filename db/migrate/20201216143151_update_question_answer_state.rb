class UpdateQuestionAnswerState < ActiveRecord::Migration[6.0]
  def change
    add_column :b_questions, :correct, :boolean, index: true, null: false, default: false
    BQuestion.all.each do |q|
      q.correct = q.answer
      q.save
    end
    remove_column :b_questions, :answer
  end
end
