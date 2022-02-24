module BxBlockProfile
  class CurrentAnnualSalary < BxBlockProfile::ApplicationRecord
    self.table_name = :current_annual_salaries
    has_many :current_annual_salary_current_status, class_name: "BxBlockProfile::CurrentAnnualSalaryCurrentStatus"
  end
end