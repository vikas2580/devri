module BxBlockProfile
  class EmploymentType < BxBlockProfile::ApplicationRecord
    self.table_name = :employment_types
    has_many :current_status_employment_types, class_name: "BxBlockProfile::CurrentStatusEmploymentType"
    has_many :career_experience_employment_types, class_name: "BxBlockProfile::CareerExperienceEmploymentType"
  end
end