class Options
  # Checks generator arguments.

  attr_reader :errors, :model_name, :collection_name

  def initialize(model_name, collection_name)
    @model_name = model_name.camelize
    @collection_name = collection_name.underscore
  end

  def valid?
    # Model and table (in DB) should present,
    # columns (fields) should not present.

    if !!model && !!table_name && !!collection_name_valid? && !collection_columns_exists?
      true
    else
      @errors ||= []
      @errors << "Model doesn't exist." if !model
      @errors << "Table doesn't exist." if !table_name
      @errors << "Collection name too long." if !collection_name_valid?
      @errors << "Collection columns already exist." if collection_columns_exists?
      false
    end
  end

  def table_name
    @table_name ||= begin
      if connection.table_exists?(model.table_name)
        model.table_name
      end
    rescue
    end
  end

  def positions_column
    @positions_column ||= "#{@collection_name.pluralize}_positions"
  end

  def ids_column
    @ids_column ||= "#{@collection_name.pluralize}_ids"
  end

  private

  def model
    # Try to get model class from string.

    @klass ||= begin
      eval(@model_name)
    rescue
    end
  end

  def collection_columns_exists?
    if table_name
      connection.column_exists?(table_name, ids_column) || connection.column_exists?(table_name, positions_column)
    end
  end

  def collection_name_valid?
    @collection_name.length < 127
  end

  def connection
    ActiveRecord::Base.connection
  end
end
