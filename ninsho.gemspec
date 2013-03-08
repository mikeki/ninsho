# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ninsho/version'

Gem::Specification.new do |gem|
  gem.name          = "ninsho"
  gem.version       = Ninsho::VERSION
  gem.platform      = Gem::Platform::RUBY
  gem.authors       = ["Abraham Kuri Vargas"]
  gem.email         = ["abraham.kuri@gmail.com"]
  gem.description   = %q{Easy authentication with many providers}
  gem.summary       = %q{Easy authentication with many providers}
  gem.homepage      = ""

  gem.rubyforge_project = "ninsho"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency("orm_adapter", "~> 0.1")
  gem.add_dependency "railties", "~> 3.1"
  gem.add_dependency "activerecord", ">= 3.0"
end
