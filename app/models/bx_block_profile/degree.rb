module BxBlockProfile
  class Degree < BxBlockProfile::ApplicationRecord
    self.table_name = :degrees
    has_many  :degree_educational_qualifications,
              class_name: "BxBlockProfile::DegreeEducationalQualification"
  end
end