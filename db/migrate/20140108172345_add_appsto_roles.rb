class AddAppstoRoles < ActiveRecord::Migration
  def change
        add_column :roles, :app_id, :int
  end
end
