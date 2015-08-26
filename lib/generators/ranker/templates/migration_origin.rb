class AddRanker_description_To_model_name_ < ActiveRecord::Migration
  def self.up
    add_column :_table_name_, :_column_name_, :integer
  end

  def self.down
    remove_column :_table_name_, :_column_name_
  end
end
