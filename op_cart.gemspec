$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "op_cart/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "op_cart"
  s.version     = OpCart::VERSION
  s.authors     = ["Eric Boehs"]
  s.email       = ["ericboehs@gmail.com"]
  s.homepage    = "https://github.com/ericboehs/op_cart"
  s.summary     = "Opinionated cart engine for Ruby on Rails"
  s.description = "OpCart makes things simple through inflexibility and lack of features"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.0.b1"
  s.add_dependency "slim-rails", "~> 2.1.5"
  s.add_dependency "stripe", "~> 1.15.0"

  s.add_development_dependency "pg"
end
