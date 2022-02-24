# frozen_string_literal: true
# This migration comes from bx_block_profile_bio (originally 20210519080110)

class AddTypeToPushNotifications < ActiveRecord::Migration[6.0]
  def change
    add_column :push_notifications, :notify_type, :string
  end
end
