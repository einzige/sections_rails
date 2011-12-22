$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "sections_rails/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "sections_rails"
  s.version     = SectionsRails::VERSION
  s.authors     = ["Kevin Goslar"]
  s.email       = ["kevin.goslar@gmail.com"]
  s.homepage    = "https://github.com/kevgo/sections_rails"
  s.summary     = "A rails plugin that allows to define the HTML, CSS, and JS for individual sections of pages as one unit."
  s.description = "Sections_rails adds infrastructure to the view layer of Ruby on Rails. It allows to define and use the HTML, CSS, and JavaScript code of dedicated sections of pages together in one place."

  s.files = Dir["{lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.markdown"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 3.1"

  s.add_development_dependency "rspec"
  s.add_development_dependency "sqlite3"
end
