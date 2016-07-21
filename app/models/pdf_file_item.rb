# == Schema Information
#
# Table name: pdf_file_items
#
#  id                    :integer          not null, primary key
#  pdf_file_file_name    :string(255)
#  pdf_file_content_type :string(255)
#  pdf_file_file_size    :integer
#  pdf_file_updated_at   :datetime
#  created_at            :datetime
#  updated_at            :datetime
#

class PdfFileItem < ActiveRecord::Base
  include MenuItemInfoObject
  
  has_attached_file :pdf_file

  validates_attachment_presence :pdf_file, preserve_files: true
  validates_attachment :pdf_file, content_type: { content_type: "application/pdf" }
  validates_attachment_file_name :pdf_file, matches: [/pdf\Z/]

  def menu_type
    'pdf'
  end

  def self.is_enabled_by_default?
    true
  end
end
