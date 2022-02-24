module BxBlockProfile
  class Language < BxBlockProfile::ApplicationRecord
    self.table_name = :languages
    belongs_to :profile, class_name: "BxBlockProfile::Profile"
    validates :profile_id, presence: true
  end
end
