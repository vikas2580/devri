module BxBlockProfile
  class Industry < BxBlockProfile::ApplicationRecord
    self.table_name = :industries
    has_many :current_status_industrys, class_name: "BxBlockProfile::CurrentStatusIndustry"
    has_many :career_experience_industrys, class_name: "BxBlockProfile::CareerExperienceIndustry"
  end
end