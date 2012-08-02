# -*- coding: iso-8859-1 -*-
require File.expand_path("../lib/pdf_forms/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "pdf-forms"
  s.version     = PdfForms::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jens Krämer"]
  s.email       = ["jk@jkraemer.net"]
  s.homepage    = "http://github.com/jkraemer/pdf-forms"
  s.summary     = %q{Fill out PDF forms with pdftk (http://www.accesspdf.com/pdftk/).}
  s.description = %q{Fill out PDF forms with pdftk (http://www.accesspdf.com/pdftk/).}

  s.required_rubygems_version = ">= 1.3.6"

  # required for validation
  s.rubyforge_project         = "pdf-forms"

  # If you have other dependencies, add them here
  # s.add_dependency "another", "~> 1.2"
  s.add_development_dependency "pry", "> 0.0"
  s.add_development_dependency "pry-nav", "> 0.0"

  # If you need to check in files that aren't .rb files, add them here
  s.files        = Dir["{lib}/**/*.rb", "bin/*", "LICENSE", "*.md", "*.rdoc"]
  s.require_path = 'lib'

end
