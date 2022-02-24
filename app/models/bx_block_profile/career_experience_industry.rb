module BxBlockProfile
  class CareerExperienceIndustry < BxBlockProfile::ApplicationRecord
    self.table_name = :career_experience_industry
    belongs_to :career_experience, class_name: "BxBlockProfile::CareerExperience"
    belongs_to :industry, class_name: "BxBlockProfile::Industry"
  end
end