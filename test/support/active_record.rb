require 'active_record'
require 'logger'

root_path = File.expand_path(File.dirname(__FILE__) + '../../../')

log_file = File.join(root_path, 'log/database.log')
db_config = File.join(root_path, 'test/support/database.yml')

ActiveRecord::Base.logger = Logger.new(log_file)
ActiveRecord::Base.configurations = YAML::load(IO.read(db_config))
ActiveRecord::Base.establish_connection('test')

ActiveRecord::Schema.define :version => 0 do
  create_table :entities, force: true do |t|
    t.string :name
  end
end
