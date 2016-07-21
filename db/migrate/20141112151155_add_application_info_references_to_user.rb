class AddApplicationInfoReferencesToUser < ActiveRecord::Migration
  def change
    add_reference :users, :application_info, index: true
  end
end
