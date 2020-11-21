class Question < ApplicationRecord
  scope :active, -> { where(deteled: false).order('id DESC') }
  scope :deleted, -> { where(deteled: true).order('id DESC') }
  scope :clear, -> { where.not(title: nil).where.not(answer: nil).where.not(answer_wrong_1_ru: nil).where.not(answer_wrong_2_ru: nil).where.not(answer_wrong_3_ru: nil).order('id DESC') }


  validates :title, :answer, :answer_wrong_1_ru, :answer_wrong_2_ru, :answer_wrong_3_ru, presence: true
end
