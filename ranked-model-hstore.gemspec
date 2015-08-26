# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ranked-model-hstore/version'

Gem::Specification.new do |spec|
  spec.name          = 'ranked-model-hstore'
  spec.version       = RankedModelHstore::VERSION
  spec.platform      = Gem::Platform::RUBY
  spec.authors       = ['Dmitriy Komaritskiy']
  spec.email         = ['lochnessathome@gmail.com']

  spec.summary       = %q{TODO: Write a short summary, because Rubygems requires one.}
  spec.description   = %q{TODO: Write a longer description or delete this line.}
  spec.homepage      = 'http://kiiiosk.ru/'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activerecord', '>= 4.1.0'
  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'minitest', '~> 5.8.0'
  spec.add_development_dependency 'minitest-spec-rails', '~> 5.2.2'
  spec.add_development_dependency 'minitest-reporters', '~> 1.0.20'
  spec.add_development_dependency 'database_cleaner'
  spec.add_development_dependency 'pry-rails'
  spec.add_development_dependency 'pry'
end
