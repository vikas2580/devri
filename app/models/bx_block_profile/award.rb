module BxBlockProfile
  class Award < BxBlockProfile::ApplicationRecord
    self.table_name = :awards
    belongs_to :profile, class_name: "BxBlockProfile::Profile"
    validates :profile_id, presence: true
  end
end
