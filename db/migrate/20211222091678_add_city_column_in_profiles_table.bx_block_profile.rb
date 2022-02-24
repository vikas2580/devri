# This migration comes from bx_block_profile (originally 20210723071617)
class AddCityColumnInProfilesTable < ActiveRecord::Migration[6.0]
  def change
    add_column :profiles, :city, :string
  end
end
