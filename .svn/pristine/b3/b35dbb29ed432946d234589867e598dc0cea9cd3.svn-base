class RenameAppIdToFormId < ActiveRecord::Migration
  def up
    rename_column :submissions, :app_id, :construct_id
  end

  def down
    rename_column :submissions, :construct_id, :app_id
  end
end
