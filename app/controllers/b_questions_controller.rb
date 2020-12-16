class BQuestionsController < ApplicationController
  before_action :get_question, only: [:update, :delete]
  skip_before_action :verify_authenticity_token

  def index
    @questions = BQuestion.active.paginate(page: params[:page], per_page: 15)
  end

  def clear
    @questions = BQuestion.clear.paginate(page: params[:page], per_page: 15)
  end

  def update
    h = question_params.to_h
    h = h.reject{|_, v| v.blank?}
    @question.assign_attributes(h)
    @question.save ? flash[:success] = "Запись обновлена" : flash[:errors] = @question.errors.full_messages
    redirect_back(fallback_location: home_path)
  end

  def delete
    @question.update_attribute(:deleted, true)
    redirect_back(fallback_location: b_home_path)
  end

  def show
    redirect_to b_home_path
  end

  def create
    h = question_params.to_h
    h = h.reject{|_, v| v.blank?}
    @question = BQuestion.create(h) if h[:title_ru] || h[:title_en]
    redirect_back(fallback_location: b_home_path)
  end

  private

  def get_question
    @question = BQuestion.find(params[:id])
  end

  def question_params
    params.require(:b_question).permit(:title_ru, :title_en, :correct)
  end
end
