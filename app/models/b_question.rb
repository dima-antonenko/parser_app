class BQuestion < ApplicationRecord
  scope :active, -> {
    where.not("title_ru IS NOT NULL AND title_en IS NOT NULL")
         .where(deleted: false).order('id DESC')
  }


  scope :deleted, -> { where(deleted: true).order('id DESC') }

  scope :clear, -> { where.not(title_ru: nil)
                          .where.not(title_en: nil)
                          .where(deleted: false).order('id DESC') }
end
