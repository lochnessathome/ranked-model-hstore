class Add_description_RankTo_model_name_ < ActiveRecord::Migration
  def self.up
    enable_extension 'hstore'
    enable_extension 'intarray'

    add_column :_table_name_, :_positions_column_, :hstore, default: {}, null: false
    add_column :_table_name_, :_ids_column_, :integer, default: [], null: false, array: true

    ### PlSql functions
    execute <<-SQL
      _func_latest_position_body_
      _func_count_items_body_
    SQL
  end

  def self.down
    # Do not drop extensions.

    remove_column :_table_name_, :_positions_column_
    remove_column :_table_name_, :_ids_column_

    ### PlSql functions
    execute <<-SQL
      drop function _func_latest_position_fullname_;
      drop function _func_count_items_fullname_;
    SQL
  end
end
