class PlSqlFunction
  # Wrapper for PlSql module,
  # used to call its methods with Options object.

  def initialize(name, *args)
    @function = evaluate(name, *args)
  end

  def body
    @function["body"]
  end

  def name
    @function["name"]
  end

  def fullname
    @function["fullname"]
  end

  private

  def evaluate(name, *args)
    begin
      eval("PlSql.#{name} #{args.map { |arg| "'#{arg}'" }.join(', ')}")
    rescue
      raise "Bad arguments for function `#{name}`: #{args}."
    end
  end
end

class FuncLatestPosition < PlSqlFunction
  def initialize(options)
    super('func_latest_position', options.table_name, options.collection_name, options.positions_column)
  end
end
