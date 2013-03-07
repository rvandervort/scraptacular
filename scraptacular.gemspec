# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'scraptacular/version'

Gem::Specification.new do |gem|
  gem.name          = "scraptacular"
  gem.version       = Scraptacular::VERSION
  gem.authors       = ["Roger Vandervort"]
  gem.email         = ["rvandervort@gmail.com"]
  gem.description   = %q{Organized web scraping}
  gem.summary       = %q{Organized web scraping}
  gem.homepage      = "https://github.com/rvandervort/scraptacular"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency 'mechanize', '~> 2.5'
  gem.add_development_dependency 'simplecov', '~> 0.7.1'
end
