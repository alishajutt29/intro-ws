class RenameProduciesToProducts < ActiveRecord::Migration[8.1]
  def change
    rename_table :producies, :products
  end
end