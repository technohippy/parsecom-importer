# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'parse/importer/version'

Gem::Specification.new do |gem|
  gem.name          = "parsecom-importer"
  gem.version       = Parse::Importer::VERSION
  gem.authors       = ["Ando Yasushi"]
  gem.email         = ["andyjpn@gmail.com"]
  gem.description   = %q{parse.com importer}
  gem.summary       = %q{parse.com importer}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  #gem. zipruby
end
