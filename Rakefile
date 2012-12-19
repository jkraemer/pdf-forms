require "bundler"
Bundler.setup

require 'rake/testtask'

desc 'Test the library.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib' << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

task :default => :test

gemspec = eval(File.read("pdf-forms.gemspec"))

task :build => "#{gemspec.full_name}.gem"

file "#{gemspec.full_name}.gem" => gemspec.files + ["pdf-forms.gemspec"] do
  system "gem build pdf-forms.gemspec"
  system "gem install pdf-forms-#{PdfForms::VERSION}.gem"
end
