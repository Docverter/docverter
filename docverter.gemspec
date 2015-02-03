lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
  gem.name          = "docverter-server"
  gem.version       = "1.0.3"
  gem.authors       = ["Pete Keen"]
  gem.email         = ["pete@docverter.com"]
  gem.description   = %{Document conversion service with a REST API}
  gem.summary       = %{Document conversion service with a REST API}
  gem.homepage      = 'http://www.docverter.com'
  gem.platform      = "java"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency('mime-types')
  gem.add_dependency('sinatra')
  gem.add_dependency('rake')
  gem.add_dependency('mizuno')
  gem.add_dependency('flying_saucer')
  gem.add_dependency('multi_json')
  
  gem.add_development_dependency("mocha")
  gem.add_development_dependency("shoulda")
end
