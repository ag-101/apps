class AddPageTypeToHomes < ActiveRecord::Migration
  def change
        add_column :homes, :page_type, :string
  end
end
