# -*- encoding: utf-8 -*-
require File.expand_path('../lib/cozaepp/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Todor Genov"]
  gem.email         = ["todor@subnet.co.za"]
  gem.description   = %q{API to Uniforum's EPP service}
  gem.summary       = %q{API to Uniforum's EPP service}
  gem.homepage      = "http://github.com/tgenov/cozaepp"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "cozaepp"
  gem.require_paths = ["lib"]
  gem.version       = Cozaepp::VERSION

end
