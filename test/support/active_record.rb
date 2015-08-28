require 'active_record'
require 'logger'

root_path = File.expand_path(File.dirname(__FILE__) + '../../../')

log_file = File.join(root_path, 'log/database.log')
db_config = File.join(root_path, 'test/support/database.yml')

ActiveRecord::Base.logger = Logger.new(log_file)
ActiveRecord::Base.configurations = YAML::load(IO.read(db_config))
ActiveRecord::Base.establish_connection(:test)

ActiveRecord::Schema.define :version => 0 do
  enable_extension 'hstore'
  enable_extension 'intarray'

  create_table :entities, force: true do |t|
    t.string :name
  end

  create_table :ranked_entities, force: true do |t|
    t.string  :name
    t.integer :collections_ids,        default: [], null: false, array: true
    t.hstore  :collections_positions,  default: {}, null: false
  end
end

class Entity < ActiveRecord::Base
end

require 'ranked-model-hstore/ranker'

class RankedEntity < ActiveRecord::Base
  include RankedModelHstore
  ranks :collection
end

# 
# require 'pry'
#
# sql = "CREATE FUNCTION greenwich_time() RETURNS date AS $$
#        SELECT DATE(NOW() AT TIME ZONE 'UTC');
#        $$ LANGUAGE SQL;"
#
# binding.pry
#
# ActiveRecord::Base.connection.execute sql
#
# sql = "SELECT * from users"
# @result = @connection.connection.execute(sql);
# @result.each(:as => :hash) do |row|
#    puts row["email"]
# end
