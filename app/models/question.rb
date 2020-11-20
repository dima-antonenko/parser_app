class Question < ApplicationRecord
  scope :active, -> { where(deteled: false).order('id DESC') }
end
