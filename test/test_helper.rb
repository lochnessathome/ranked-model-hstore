$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].each { |f| require f }

require 'ranked-model-hstore'

require 'minitest/autorun'
require 'minitest/reporters'

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

require 'database_cleaner'

DatabaseCleaner.strategy = :transaction

class Minitest::Spec
  before :each do
    DatabaseCleaner.start
  end

  after :each do
    DatabaseCleaner.clean
  end
end
