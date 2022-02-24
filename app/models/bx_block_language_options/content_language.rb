module BxBlockLanguageOptions
  class ContentLanguage < ApplicationRecord
    self.table_name = :contents_languages

    belongs_to :account, class_name: "AccountBlock::Account"
    belongs_to :language

  end
end
