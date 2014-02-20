class CreateSubmissions < ActiveRecord::Migration
  def change
    create_table :submissions do |t|
      t.text :content
      t.integer :app_id
      t.integer :created_by_id
      t.integer :updated_by_id

      t.timestamps
    end
  end
end
