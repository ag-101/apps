class AddInfoOnlyToWorkflowStages < ActiveRecord::Migration
  def change
    add_column :workflow_stages, :info_only, :tinyint, :default => 0    
  end
end
