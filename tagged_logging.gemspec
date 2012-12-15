# -*- encoding: utf-8 -*-
require File.expand_path('../lib/tagged_logging/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Ketan Padegaonkar"]
  gem.email         = ["KetanPadegaonkar@gmail.com"]
  gem.description   = %q{Provides a rails style TaggedLogging for ruby apps}
  gem.summary       = %q{Provides a rails style TaggedLogging for ruby apps}
  gem.homepage      = "https://github.com/ketan/tagged-logger"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "tagged_logging"
  gem.require_paths = ["lib"]
  gem.version       = TaggedLogging::Version::VERSION

  gem.add_development_dependency 'test-unit'
  gem.add_development_dependency "simplecov"
  gem.add_development_dependency 'rake'
end
