# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{pdf-forms}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jens Kraemer"]
  s.date = %q{2009-09-03}
  s.description = %q{Fill out PDF forms with pdftk (http://www.accesspdf.com/pdftk/).}
  s.email = %q{jk@jkraemer.net}
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.rdoc"]
  s.files = ["History.txt", "Manifest.txt", "README.rdoc", "Rakefile", "lib/pdf_forms.rb", "lib/pdf_forms/fdf.rb", "lib/pdf_forms/pdftk_wrapper.rb", "test/test_helper.rb", "test/test_fdf.rb"]
  s.has_rdoc = true
  s.homepage = %q{  http://github.com/jkraemer/pdf-forms/}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{pdf-forms}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Fill out PDF forms with pdftk (http://www.accesspdf.com/pdftk/).}
  s.test_files = ["test/test_fdf.rb", "test/test_helper.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<newgem>, [">= 1.2.3"])
      s.add_development_dependency(%q<hoe>, [">= 1.8.0"])
    else
      s.add_dependency(%q<newgem>, [">= 1.2.3"])
      s.add_dependency(%q<hoe>, [">= 1.8.0"])
    end
  else
    s.add_dependency(%q<newgem>, [">= 1.2.3"])
    s.add_dependency(%q<hoe>, [">= 1.8.0"])
  end
end
