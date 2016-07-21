# == Schema Information
#
# Table name: menu_items
#
#  id                  :integer          not null, primary key
#  display_name        :string(255)
#  position            :integer          default(0)
#  app_home            :boolean          default(FALSE)
#  application_info_id :integer
#  info_object_id      :integer
#  info_object_type    :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  enabled             :boolean          default(FALSE)
#
# Indexes
#
#  index_menu_items_on_application_info_id                  (application_info_id)
#  index_menu_items_on_info_object_id_and_info_object_type  (info_object_id,info_object_type)
#

class MenuItem < ActiveRecord::Base
  belongs_to :info_object, polymorphic: true
  belongs_to :application_info, touch: true
  acts_as_list scope: :application_info

  scope :enabled, -> { where(enabled: true) }

  before_save :set_disabled_attrs, unless: Proc.new { enabled }

  validates_presence_of :display_name, :application_info

  around_destroy :remove_related_info_object

  private

  def remove_related_info_object
    yield
    info_object.destroy
  end

  def set_disabled_attrs
    self.position = disabled_position
    self.app_home = false
    true
  end

  def disabled_position
    id.blank? ? 99 : id + 99
  end
end
