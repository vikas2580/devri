ActiveAdmin.register BxBlockCategories::Category do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name, :admin_user_id, :rank, :light_icon, :light_icon_active, :light_icon_inactive, :dark_icon, :dark_icon_active, :dark_icon_inactive, :identifier
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :admin_user_id, :rank, :light_icon, :light_icon_active, :light_icon_inactive, :dark_icon, :dark_icon_active, :dark_icon_inactive, :identifier]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
