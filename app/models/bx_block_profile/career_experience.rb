module BxBlockProfile
  class CareerExperience < BxBlockProfile::ApplicationRecord
    self.table_name = :career_experiences
    belongs_to :profile, class_name: "BxBlockProfile::Profile"
    has_many :career_experience_industrys, class_name: "BxBlockProfile::CareerExperienceIndustry"
    has_many :career_experience_employment_types, class_name: "BxBlockProfile::CareerExperienceEmploymentType"
    has_many :career_experience_system_experiences, class_name: "BxBlockProfile::CareerExperienceSystemExperience"
  end
end