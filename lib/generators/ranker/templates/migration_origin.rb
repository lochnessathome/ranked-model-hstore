class Add_description_RankTo_model_name_ < ActiveRecord::Migration
  def self.up
    enable_extension 'hstore'
    enable_extension 'intarray'

    add_column :_table_name_, :_positions_column_, :hstore, default: {}, null: false
    add_column :_table_name_, :_ids_column_, :integer, default: [], null: false, array: true
  end

  def self.down
    # Do not drop extensions.

    remove_column :_table_name_, :_positions_column_
    remove_column :_table_name_, :_ids_column_
  end
end
