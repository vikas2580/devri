module BxBlockProfile
  class Associated < BxBlockProfile::ApplicationRecord
    self.table_name = :associateds
    has_many :associated_projects, class_name: "BxBlockProfile::AssociatedProject"
  end
end