require 'rails/generators/active_record'

require_relative 'misc/options'
require_relative 'misc/filesystem'
require_relative 'misc/template_processor'

require 'pry'

class RankerGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  argument :model_name, :type => :string
  argument :column_name, :type => :string, :default => 'row'

  def generate_ranker
    options = Options.new(model_name, column_name)
    unless options.valid?
      handle_error(options.errors)
    end

    fs = Filesystem.new(options)

    template = TemplateProcessor.new(fs.migration_origin)
    unless template.perform!(options)
      handle_error(template.errors)
    end

    if !fs.unique? || !fs.store(template.source)
      handle_error(fs.errors)
    end

    copy_file fs.filename, "db/migrate/#{fs.filename}"

    fs.clear_dir!
  end

  private

  def handle_error(errors)
    puts 'Error.'
    errors.each { |e| puts e }
    exit!
  end
end
