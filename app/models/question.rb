class Question < ApplicationRecord
  scope :active, -> { where(deteled: false).order('id DESC') }
  scope :deleted, -> { where(deteled: true).order('id DESC') }
end
