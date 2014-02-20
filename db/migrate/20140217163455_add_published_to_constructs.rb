class AddPublishedToConstructs < ActiveRecord::Migration
  def change
            add_column :constructs, :published, :tinyint, :default => 0
            add_column :constructs, :disabled, :tinyint, :default => 0
  end
end
