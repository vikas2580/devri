module BxBlockProfile
  class Profile < BxBlockProfile::ApplicationRecord
    self.table_name = :profiles
    has_one_attached :photo
    belongs_to :account, class_name: "AccountBlock::Account"
    has_one :current_status, dependent: :destroy, class_name: "BxBlockProfile::CurrentStatus"
    accepts_nested_attributes_for :current_status, allow_destroy: true
    has_one :publication_patent,dependent: :destroy, class_name: "BxBlockProfile::PublicationPatent"
    accepts_nested_attributes_for :publication_patent, allow_destroy: true
    has_many :awards, dependent: :destroy, class_name: "BxBlockProfile::Award"
    accepts_nested_attributes_for :awards, allow_destroy: true
    has_many :hobbies, dependent: :destroy, class_name: "BxBlockProfile::Hobby"
    accepts_nested_attributes_for :hobbies, allow_destroy: true
    has_many :courses, dependent: :destroy, class_name: "BxBlockProfile::Course"
    accepts_nested_attributes_for :courses, allow_destroy: true
    has_many :test_score_and_courses,dependent: :destroy, class_name: "BxBlockProfile::TestScoreAndCourse"
    accepts_nested_attributes_for :test_score_and_courses, allow_destroy: true
    has_many :career_experiences,dependent: :destroy, class_name: "BxBlockProfile::CareerExperience"
    accepts_nested_attributes_for :career_experiences, allow_destroy: true
    has_one :video, class_name: "BxBlockVideolibrary::Video"
    has_many :educational_qualifications, dependent: :destroy,class_name: "BxBlockProfile::EducationalQualification"
    accepts_nested_attributes_for :educational_qualifications, allow_destroy: true
    has_many :projects,dependent: :destroy, class_name: "BxBlockProfile::Project"
    accepts_nested_attributes_for :projects, allow_destroy: true
    has_many :languages, class_name: "BxBlockProfile::Language"
    has_many :contacts, class_name: "BxBlockContactsintegration::Contact"
    has_many :jobs, class_name: "BxBlockJobListing::Job"
    has_many :applied_jobs, class_name: "BxBlockJobListing::AppliedJob"
    has_many :follows, class_name: "BxBlockJobListing::Follow"
    # has_many :company_pages, through: :follows , class_name: "BxBlockJoblisting::CompanyPage"
    has_many :interview_schedules, class_name: "BxBlockCalendar::InterviewSchedule"
    has_and_belongs_to_many :company_pages,
                            class_name: "BxBlockJobListing::CompanyPage",
                            join_table: :profiles_company_pages
    validates :profile_role, presence: true
    enum profile_role: [:jobseeker, :recruiter]
    validate :profile_validation
    private

    def profile_validation
      if account && account.profiles.count >= 2
        errors.add(:profiles, "for an account can not exceed count of 2")
      end
    end

    def photo_present?
      errors.add(:photo, :blank) unless photo.attached?
    end

  end
end


