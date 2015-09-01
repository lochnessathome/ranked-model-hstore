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

  def self.func_count_items(table_name, collection_name, positions_column)
    func_name = "count_items_in_#{collection_name}_at_#{table_name}"
    func_args = "(collection_id varchar)"

    sql = "
           create or replace function
             #{func_name}#{func_args}
             returns integer as $$
               select count(#{positions_column} -> collection_id)::integer from #{table_name};
             $$ language sql;
          "

    {"name" => func_name, "fullname" => "#{func_name}#{func_args}", "body" => sql}
  end

  def self.func_generate_sequence(table_name, collection_name, positions_column)
    increment_by = 100_000.to_s
    start_with = 10_000_000.to_s

    func_name = "generate_sequence_for_#{collection_name}_at_#{table_name}"
    func_args = "(collection_id varchar)"

    sql = "
            create or replace function
            #{func_name}#{func_args}
            returns varchar as $$
              declare
                 _seq varchar := '#{collection_name}_' || collection_id || '_at_#{table_name}_seq';
              begin
                case (select c.relkind = 'S'::varchar
                      from   pg_namespace n
                      join   pg_class     c on c.relnamespace = n.oid
                      where  n.nspname =  current_schema()
                      and    c.relname =  _seq)
                when true then
                when false then
                   raise exception '% is not a sequence!', _seq;
                else
                   execute format('create sequence %I increment #{increment_by} start #{start_with}', _seq);
                end case;

                return _seq;
              end;
             $$ language plpgsql;
          "

    {"name" => func_name, "fullname" => "#{func_name}#{func_args}", "body" => sql}
  end


  def self.func_generate_position(table_name, collection_name, positions_column)
    func_name = "generate_position_in_#{collection_name}_at_#{table_name}"
    func_args = "()"

    sql = "
            create or replace function
            #{func_name}#{func_args}
            returns trigger as $$
            declare
              pairs varchar[][];
            begin
              pairs := hstore_to_matrix(NEW.#{positions_column});

              for i in 1 .. array_upper(pairs, 1) loop
                if pairs[i][2] = 'NULL' then
                  pairs[i][2] := nextval('#{collection_name}_' || pairs[i][1] || '_at_#{table_name}_seq');
                end if;
              end loop;

              NEW.#{positions_column} := hstore(pairs);

              return NEW;
            end;
            $$ language plpgsql;

            create trigger
            auto_assign_positions_in_#{collection_name}_at_#{table_name}
            before insert or update
            on #{table_name}
            for each row execute procedure
            #{func_name}#{func_args};
          "

    {"name" => func_name, "fullname" => "#{func_name}#{func_args}", "body" => sql}
  end
end
