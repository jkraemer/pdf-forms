require "bundler"
Bundler.setup

require 'rake/testtask'

desc 'Test the library.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib' << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
  t.warning = false
end

task :default => :test

gemspec = eval(File.read("pdf-forms.gemspec"))

task :build => "#{gemspec.full_name}.gem"

file "#{gemspec.full_name}.gem" => gemspec.files + ["pdf-forms.gemspec"] do
  system "gem build pdf-forms.gemspec"
  system "gem install pdf-forms-#{PdfForms::VERSION}.gem"
end


desc "Manage the encoding header of Ruby files"
task :utf8_encode_headers do
  files = Array.new
  ["*.rb", "*.rake"].each do |extension|
    files.concat(Dir[ File.join(Dir.getwd.split(/\\/), "**", extension) ])
  end

  files.each do |file|
    content = File.read(file)
    next if content[0..16] == "# coding: UTF-8\n\n" ||
            content[0..22] == "# -*- coding: utf-8 -*-"

   ["\n\n", "\n"].each do |file_end|
      content = content.gsub(/(# encoding: UTF-8#{file_end})|(# coding: UTF-8#{file_end})|(# -*- coding: UTF-8 -*-#{file_end})|(# -*- coding: utf-8 -*-#{file_end})/i, "")
    end

    new_file = File.open(file, "w")
    new_file.write("# coding: UTF-8\n\n"+content)
    new_file.close
  end
end

