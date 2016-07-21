# == Schema Information
#
# Table name: app_colors
#
#  id                     :integer          not null, primary key
#  application_info_id    :integer
#  header_bg_color        :string(255)      default("#1d1d1d")
#  separator_color        :string(255)      default("#272727")
#  header_text_color      :string(255)      default("#FAFAFA")
#  created_at             :datetime
#  updated_at             :datetime
#  separator_accent_color :string(255)      default("#1b1b1b")
#  menu_cell_bg_color     :string(255)      default("#202020")
#  menu_cell_text_color   :string(255)      default("#eeeeee")
#  menu_top_bg_color      :string(255)      default("#1d1d1d")
#  menu_top_text_color    :string(255)      default("#fafafa")
#
# Indexes
#
#  index_app_colors_on_application_info_id  (application_info_id)
#

class AppColors < ActiveRecord::Base
  belongs_to :application_info, touch: true

  validates_presence_of :header_bg_color, :header_text_color
  validates_presence_of :separator_color, :separator_accent_color
  validates_presence_of :menu_cell_bg_color, :menu_cell_text_color
  validates_presence_of :menu_top_bg_color, :menu_top_text_color

  validates :header_bg_color, css_hex_color: true
  validates :header_text_color, css_hex_color: true

  validates :separator_color, css_hex_color: true
  validates :separator_accent_color, css_hex_color: true

  validates :menu_cell_bg_color, css_hex_color: true
  validates :menu_cell_text_color, css_hex_color: true

  validates :menu_top_bg_color, css_hex_color: true
  validates :menu_top_text_color, css_hex_color: true
end
