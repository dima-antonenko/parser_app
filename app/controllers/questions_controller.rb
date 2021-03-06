class QuestionsController < ApplicationController
  before_action :get_question, only: [:update, :delete]
  skip_before_action :verify_authenticity_token

  def index
    @questions = Question.active.paginate(page: params[:page], per_page: 15)
  end

  def clear
    @questions = Question.clear.paginate(page: params[:page], per_page: 15)
  end

  def update
    @question.assign_attributes(question_params)
    @question.save ? flash[:success] = "Запись обновлена" : flash[:errors] = @question.errors.full_messages
    redirect_back(fallback_location: home_path)
  end

  def delete
    @question.update_attribute(:deteled, true)
    redirect_back(fallback_location: home_path)
  end

  def show
    redirect_to home_path
  end

  def test

  end

  private

  def get_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :answer, :title_en, :answer_en,
                                     :answer_wrong_1_ru, :answer_wrong_2_ru, :answer_wrong_3_ru,
                                     :answer_wrong_1_en, :answer_wrong_2_en, :answer_wrong_3_en,
                                     )
  end
end
