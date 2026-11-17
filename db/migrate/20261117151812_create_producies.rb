class CreateProducies < ActiveRecord::Migration[8.1]
  def change
    create_table :producies do |t|
      t.string :name

      t.timestamps
    end
  end
end
