module BxBlockProfile
  class AssociatedProject < BxBlockProfile::ApplicationRecord
    self.table_name = :associated_projects
    belongs_to :project, class_name: "BxBlockProfile::Project"
    belongs_to :associated, class_name: "BxBlockProfile::Associated"
  end
end