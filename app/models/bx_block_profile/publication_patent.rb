module BxBlockProfile
  class PublicationPatent < BxBlockProfile::ApplicationRecord
    self.table_name = :publication_patents
    belongs_to :profile, class_name: "BxBlockProfile::Profile"
  end
end