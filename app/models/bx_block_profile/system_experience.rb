module BxBlockProfile
  class SystemExperience < BxBlockProfile::ApplicationRecord
    self.table_name = :system_experiences
    has_many :career_experience_system_experiences, class_name: "BxBlockProfile::CareerExperienceSystemExperience"
  end
end
