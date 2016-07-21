module MenuItemInfoObject
  extend ActiveSupport::Concern
  included do
    after_initialize :check_menu_type_method_existence
    has_one :menu_item, as: :info_object, dependent: :destroy
    accepts_nested_attributes_for :menu_item
    
    validates_presence_of :menu_item
    after_touch :touch_menu_item
    after_save :touch_menu_item

    def self.build_with_application_info app_info
      info_object = self.new
      menu_item = info_object.build_menu_item(application_info: app_info)
      if self.respond_to?(:is_enabled_by_default?)
        menu_item.enabled = is_enabled_by_default?
      end
      info_object
    end

    def self.of_app app
      self.includes(:menu_item).where(menu_items: { application_info_id: app.id })
    end

    def self.first_of_app_or_initialize app
      first_of_app(app) || build_with_application_info(app)
    end

    def self.first_of_app app
      of_app(app).first
    end
  end

  def touch_menu_item
    menu_item.touch if menu_item && menu_item.persisted?
  end

  def check_menu_type_method_existence
    unless self.respond_to?(:menu_type)
      raise "Info object should implement menu_type method" 
    end
  end
end