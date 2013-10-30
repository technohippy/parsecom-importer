# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'parse/importer/version'

Gem::Specification.new do |gem|
  gem.name          = "parsecom-importer"
  gem.version       = Parse::Importer::VERSION
  gem.authors       = ["Ando Yasushi"]
  gem.email         = ["andyjpn@gmail.com"]
  gem.description   = %q{You can import an exported zip file into your parse.com app.}
  gem.summary       = %q{You can import an exported zip file into your parse.com app.}
  gem.homepage      = "https://github.com/technohippy/parsecom-importer"
  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "parsecom"
  gem.add_dependency "zipruby"
end
