class Options
  attr_reader :errors, :model_name, :column_name

  def initialize(model_name, column_name)
    @model_name = model_name.camelize
    @column_name = column_name.underscore
  end

  def valid?
    # Model and table (in DB) should present,
    # column (field) should not present.

    if !!model && !!table_name && !!column_name_valid? && !column_exists?
      true
    else
      @errors ||= []
      @errors << "Model doesn't exist." if !model
      @errors << "Table doesn't exist." if !table_name
      @errors << "Column already exist." if column_exists?
      @errors << "Column name too long." if !column_name_valid?
      false
    end
  end

  def table_name
    @table_name ||= begin
      if ActiveRecord::Base.connection.table_exists?(model.table_name)
        model.table_name
      end
    rescue
    end
  end

  private

  def model
    # Try to get model class from string.

    @klass ||= begin
      eval(@model_name)
    rescue
    end
  end

  def column_exists?
    if table_name
      ActiveRecord::Base.connection.column_exists?(table_name, @column_name)
    end
  end

  def column_name_valid?
    @column_name.length < 127
  end
end
