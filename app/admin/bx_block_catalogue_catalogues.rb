ActiveAdmin.register BxBlockCatalogue::Catalogue do
  menu label: "Product"
  

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
   #permit_params :category_id, :sub_category_id, :brand_id, :name, :sku, :description, :manufacture_date, :length, :breadth, :height, :availability, :stock_qty, :weight, :price, :recommended, :on_sale, :sale_price, :discount, :block_qty
  #
  # or
  #
  # permit_params do
  #   permitted = [:category_id, :sub_category_id, :brand_id, :name, :sku, :description, :manufacture_date, :length, :breadth, :height, :availability, :stock_qty, :weight, :price, :recommended, :on_sale, :sale_price, :discount, :block_qty]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
