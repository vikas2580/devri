module BxBlockProfile
  class CareerExperienceSystemExperience < BxBlockProfile::ApplicationRecord
    self.table_name = :career_experience_system_experiences
    belongs_to :career_experience, class_name: "BxBlockProfile::CareerExperience"
    belongs_to :system_experience, class_name: "BxBlockProfile::SystemExperience"
  end
end