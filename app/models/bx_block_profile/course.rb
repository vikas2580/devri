module BxBlockProfile
  class Course < BxBlockProfile::ApplicationRecord
    self.table_name = :courses
    belongs_to :profile, class_name: "BxBlockProfile::Profile"
    validates :profile_id, presence: true
  end
end