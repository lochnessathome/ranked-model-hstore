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
      @source.gsub!('_description_', options.column_name.camelize)
      @source.gsub!('_model_name_', options.table_name.camelize)
      @source.gsub!('_table_name_', options.table_name)
      @source.gsub!('_column_name_', options.column_name)
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
