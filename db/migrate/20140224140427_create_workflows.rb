class CreateWorkflows < ActiveRecord::Migration
  def change 
    create_table :workflows do |t|
      t.string :name
      t.integer :app_id
      t.integer :created_by_id
      t.integer :updated_by_id      
  
      t.timestamps
    end
    
    create_table :workflow_stages do |t|
      t.integer :workflow_id
      t.integer :stage
      t.integer :send_to_id   
      t.integer :created_by_id
      t.integer :updated_by_id

      t.timestamps
    end
    
    create_table :workflow_contents do |t|
      t.integer :workflow_stage_id
      t.integer :submission_id
      t.integer :created_by_id
      t.integer :updated_by_id
      t.string :status
      t.text :comment
      
      t.timestamps      
    end
  end
end
