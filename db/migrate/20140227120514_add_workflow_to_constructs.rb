class AddWorkflowToConstructs < ActiveRecord::Migration
  def change
    add_column :constructs, :workflow_id, :integer
  end
end
