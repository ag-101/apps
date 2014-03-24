class CreateApps < ActiveRecord::Migration
  def change
    create_table :apps do |t|
      t.string :name
      t.text :description
      t.integer :app_type
      t.integer :created_by_id
      t.integer :updated_by_id

      t.timestamps
    end
  end
end
