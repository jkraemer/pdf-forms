$:.unshift File.join(File.dirname(__FILE__), "lib")

require 'pdf_forms'
require 'rake/testtask'

%w[rubygems rake rake/clean fileutils newgem rubigen].each { |f| require f }

$hoe = Hoe.new('pdf-forms', PdfForms::VERSION) do |p|
  p.name = 'pdf-forms'
  p.author = 'Jens Kraemer'
  p.email = 'jk@jkraemer.net'
  p.summary = "Fill out PDF forms with pdftk (http://www.accesspdf.com/pdftk/)."
  # p.description = p.paragraphs_of('README.txt', 2..2).join("\n\n")
  p.changes = p.paragraphs_of("History.txt", 0..1).join("\n\n")
  p.extra_dev_deps = [
    ['newgem', ">= #{::Newgem::VERSION}"]
  ]

  p.clean_globs |= %w[**/.DS_Store tmp *.log ._*]
  path = (p.rubyforge_name == p.name) ? p.rubyforge_name : "\#{p.rubyforge_name}/\#{p.name}"
  p.remote_rdoc_dir = File.join(path.gsub(/^#{p.rubyforge_name}\/?/,''), 'rdoc')
  p.rsync_args = '-av --delete --ignore-errors'
end

require 'newgem/tasks' # load /tasks/*.rake
Dir['tasks/**/*.rake'].each { |t| load t }

# Run all tests
# Rake::TestTask.new("test") { |t|
#   t.test_files = FileList[
#     'test/**/*_test.rb',
#   ]
#   t.libs << "test"
#   #t.warning = true
#   t.verbose = true
# }
