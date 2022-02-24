module BxBlockProfile
  class EducationalQualificationFieldStudy < BxBlockProfile::ApplicationRecord
    self.table_name = :educational_qualification_field_study
    belongs_to :field_study, class_name: "BxBlockProfile::FieldStudy"
    belongs_to :educational_qualification, class_name: "BxBlockProfile::EducationalQualification"
  end
end