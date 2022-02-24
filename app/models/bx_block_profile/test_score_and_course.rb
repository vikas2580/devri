module BxBlockProfile
  class TestScoreAndCourse < BxBlockProfile::ApplicationRecord
    self.table_name = :test_score_and_courses
    belongs_to :profile, class_name: "BxBlockProfile::Profile"
    validates :profile_id, presence: true
  end
end
