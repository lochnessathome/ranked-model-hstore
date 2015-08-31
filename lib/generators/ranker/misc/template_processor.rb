require_relative 'plsql_function'

class TemplateProcessor

  attr_reader :errors, :source

  def initialize(migration_origin)
    @migration_origin = migration_origin
  end

  def perform!(options)
    # Load origin template and
    # substitute lemmas with variables.
    # Result will be available via :source accessor.

    begin
      @source = template
      @source.gsub!('_description_', options.collection_name.camelize)
      @source.gsub!('_model_name_', options.table_name.camelize)
      @source.gsub!('_table_name_', options.table_name)
      @source.gsub!('_positions_column_', options.positions_column)
      @source.gsub!('_ids_column_', options.ids_column)
      func_latest_position = FuncLatestPosition.new(options)
      @source.gsub!('_func_latest_position_fullname_', func_latest_position.fullname)
      @source.gsub!('_func_latest_position_body_', func_latest_position.body)
      func_count_items = FuncCountItems.new(options)
      @source.gsub!('_func_count_items_fullname_', func_count_items.fullname)
      @source.gsub!('_func_count_items_body_', func_count_items.body)
      true
    rescue
      false
    end
  end

  private

  def template
    @template ||= begin
      File.read(@migration_origin)
    rescue
      @errors ||= []
      @errors << "Can't read file: #{@migration_origin}. Check permissions."
      raise $!
    end
  end
end
