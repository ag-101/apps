class AddDraftToForms < ActiveRecord::Migration
  def change
    add_column :submissions, :draft, :tinyint
  end
end
