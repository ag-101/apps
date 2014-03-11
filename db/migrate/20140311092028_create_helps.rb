class CreateHelps < ActiveRecord::Migration
  def change
    create_table :helps do |t|
      t.string :name
      t.text :content
      t.integer :created_by_id
      t.integer :updated_by_id

      t.timestamps
    end
  end
end
