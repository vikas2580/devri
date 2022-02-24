# This migration comes from bx_block_profile (originally 20210322125341)
class ToChangeColumnSystemExperinceInCareerExperienceSystemExperiences < ActiveRecord::Migration[6.0]
  def change
    remove_column :career_experience_system_experiences, :syatem_experience_id, :integer
    add_column :career_experience_system_experiences, :system_experience_id, :integer
  end
end
