class MigrateToMenuItemBasedEnabledStatus < ActiveRecord::Migration
  def up
    add_column :menu_items, :enabled, :boolean, default: false
    ContactUsInfo.includes(:menu_item).all.each { |c| c.menu_item.update_columns(enabled: c.enabled) }
    remove_column :contact_us_infos, :enabled
    Coupons.includes(:menu_item).all.each { |c| c.menu_item.update_columns(enabled: c.enabled) }
    remove_column :coupons, :enabled
    CustomerFeedback.includes(:menu_item).all.each { |c| c.menu_item.update_columns(enabled: c.enabled) }
    remove_column :customer_feedbacks, :enabled
    PdfFileItem.includes(:menu_item).all.each { |c| c.menu_item.update_columns(enabled: true) }
    ProductMenu.includes(:menu_item).all.each { |c| c.menu_item.update_columns(enabled: c.enabled) }
    remove_column :product_menus, :enabled
    SocialStream.includes(:menu_item).all.each { |c| c.menu_item.update_columns(enabled: c.enabled) }
    remove_column :social_streams, :enabled
    WebLink.includes(:menu_item).all.each { |c| c.menu_item.update_columns(enabled: true) }
  end

  def down
    add_column :contact_us_infos, :enabled, :boolean, default: false
    ContactUsInfo.includes(:menu_item).all.each { |c| c.update_columns(enabled: c.menu_item.enabled) }
    add_column :coupons, :enabled, :boolean, default: false
    Coupons.includes(:menu_item).all.each { |c| c.update_columns(enabled: c.menu_item.enabled) }
    add_column :customer_feedbacks, :enabled, :boolean, default: false
    CustomerFeedback.includes(:menu_item).all.each { |c| c.update_columns(enabled: c.menu_item.enabled) }
    add_column :product_menus, :enabled, :boolean, default: false
    ProductMenu.includes(:menu_item).all.each { |c| c.update_columns(enabled: c.menu_item.enabled) }
    add_column :social_streams, :enabled, :boolean, default: false
    SocialStream.includes(:menu_item).all.each { |c| c.update_columns(enabled: c.menu_item.enabled) }
    remove_column :menu_items, :enabled
  end
end
