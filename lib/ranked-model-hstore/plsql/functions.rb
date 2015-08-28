module PlSql
  def self.func_latest_position(table_name, collection_name, positions_column)
    func_name = "latest_position_in_#{collection_name}_at_#{table_name}"
    func_args = "(collection_id varchar)"
    
    sql = "
           create or replace function
             #{func_name}#{func_args}
             returns integer as $$
               select max(#{positions_column} -> collection_id)::integer from #{table_name};
             $$ language sql;
          "

    {"name" => func_name, "fullname" => "#{func_name}#{func_args}", "body" => sql}
  end
end
