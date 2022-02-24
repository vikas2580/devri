module BxBlockProfile
  class FieldStudy < BxBlockProfile::ApplicationRecord
    self.table_name = :field_study
    has_many :educational_qualification_field_studys, class_name: "BxBlockProfile::EducationalQualificationFieldStudy"
  end
end