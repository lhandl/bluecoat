# -*- encoding: utf-8 -*-
require File.expand_path('../lib/bluecoat/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Lothar Handl"]
  gem.email         = ["lothar.handl@3beg.at"]
  gem.description   = %q{A bundle of functions for accessing Blue Coat Appliances. I.e. Reporter, ProxySG, etc.}
  gem.summary       = %q{A bundle of functions for accessing Blue Coat Appliances.}
  gem.homepage      = "https://github.com/terracor/bluecoat"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "bluecoat"
  gem.require_paths = ["lib"]
  gem.version       = Bluecoat::VERSION
  gem.add_dependency(%q{mechanize})
  gem.add_dependency(%q{ipaddress})
end
