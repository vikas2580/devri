module BxBlockProfile
  class CurrentStatusEmploymentType < BxBlockProfile::ApplicationRecord
    self.table_name = :current_status_employment_types
    belongs_to :current_status, class_name: "BxBlockProfile::CurrentStatus"
    belongs_to :employment_type, class_name: "BxBlockProfile::EmploymentType"
  end
end