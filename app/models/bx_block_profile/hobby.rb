module BxBlockProfile
  class Hobby < BxBlockProfile::ApplicationRecord
    self.table_name = :hobbies_and_interests
    belongs_to :profile, class_name: "BxBlockProfile::Profile"
    validates :profile_id, presence: true
  end
end
