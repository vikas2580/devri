module BxBlockProfile
  class CurrentStatusIndustry < BxBlockProfile::ApplicationRecord
    self.table_name = :current_status_industries
    belongs_to :current_status, class_name: "BxBlockProfile::CurrentStatus"
    belongs_to :industry, class_name: "BxBlockProfile::Industry"
  end
end