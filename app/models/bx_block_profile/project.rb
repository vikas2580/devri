module BxBlockProfile
  class Project < BxBlockProfile::ApplicationRecord
    self.table_name = :projects
    belongs_to :profile, class_name: "BxBlockProfile::Profile"
    has_many :associated_projects, class_name: "BxBlockProfile::AssociatedProject"
  end
end