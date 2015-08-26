require 'fileutils'

class Filesystem
  ORIGIN = 'migration_origin.rb'

  attr_reader :errors

  def initialize(options)
    @timestamp = migration_timestamp
    @model_name = options.model_name
    @table_name = options.table_name
    @column_name = options.column_name

    clear_dir!
  end

  def store(source)
    begin
      File.open(migration_target, 'w') { |file| file.write(source) }
      true
    rescue
      @errors ||= []
      @errors << "Can't write file: #{migration_target}. Check permissions."
      false
    end
  end

  def filename
    # Name of migration file
    # Instance: 20150827193501_add_ranker_row_to_products.rb

    @filename ||= "#{@timestamp}_add_ranker_#{@column_name}_to_#{@table_name}.rb"
  end

  def migration_origin
    @migration_origin ||= File.join(templates_dir, ORIGIN)
  end

  def migration_target
    # Resulting file

    @migration_target ||= File.join(templates_dir, filename)
  end

  def unique?
    # Check that project doesn't use similar file.
    # E.g. there are NO ~/rails_project/db/migrate/*add_ranker_SAME_COLUMN_to_SAME_TABLE.rb*

    files = Dir.glob(File.join(migrate_dir, '*'))

    if files.any? { |file| file =~ /#{filename[15..-1]}$/}
      @errors ||= []
      @errors << "Such migration already exists. Try `rake db:migrate`."
      false
    else
      true
    end
  end

  def clear_dir!
    # Delete all temporary files from templetes.

    files = Dir.glob(File.join(templates_dir, '*'))
    files.delete_if { |f| f =~ /\/#{ORIGIN}$/ }

    FileUtils.rm_rf(files)
    true
  end

  private

  def migration_timestamp
    Time.now.strftime("%Y%m%d%H%M%S")
  end

  def root_dir
    @root_dir ||= File.expand_path(File.dirname(__FILE__) + '../../../../../')
  end

  def templates_dir
    @templates_dir ||= File.join(root_dir, 'lib', 'generators', 'ranker', 'templates')
  end

  def migrate_dir
    File.join(Rails.root, 'db', 'migrate')
  end
end
