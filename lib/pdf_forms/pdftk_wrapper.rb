require 'tempfile'
module PdfForms
  # Wraps calls to PdfTk
  class PdftkWrapper
    
    attr_reader :pdftk, :options
    
    # PdftkWrapper.new('/usr/bin/pdftk', :encrypt => true, :encrypt_options => 'allow Printing')
    def initialize(pdftk_path, options = {})
      @pdftk = pdftk_path
      @options = options
    end
    
    # pdftk.fill_form '/path/to/form.pdf', '/path/to/destination.pdf', :field1 => 'value 1'
    def fill_form(template, destination, data = {})
      fdf = Fdf.new(data)
      tmp = Tempfile.new('pdf_forms-fdf')
      tmp.close
      fdf.save_to tmp.path
      call_pdftk "'#{template}'", 'fill_form', tmp.path, 'output', destination, 'flatten', encrypt_options(tmp.path)
      tmp.unlink
    end
    
    # pdftk.read '/path/to/form.pdf'
    # returns an instance of PdfForms::Pdf representing the given template
    def read(path)
      Pdf.new path, self
    end
    
    def get_field_names(template)
      read(template).fields
    end
    
    def call_pdftk(*args)
      %x{#{pdftk} #{args.flatten.compact.join ' '}}
    end
    
    protected
    
    def encrypt_options(pwd)
      if options[:encrypt]
        ['encrypt_128bit', 'owner_pw', pwd, options[:encrypt_options]]
      end
    end
    
  end
end