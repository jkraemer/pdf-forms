require 'tempfile'
module PdfForms
  class PdftkError < StandardError
  end

  # Wraps calls to PdfTk
  class PdftkWrapper

    attr_reader :pdftk, :options

    # PdftkWrapper.new('/usr/bin/pdftk', :flatten => true, :encrypt => true, :encrypt_options => 'allow Printing')
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
      command = pdftk_command %Q("#{template}"), 'fill_form', %Q("#{tmp.path}"), 'output', destination, add_options(tmp.path)
      output = %x{#{command}}
      unless File.readable?(destination) && File.size(destination) > 0
        raise PdftkError.new("failed to fill form with command\n#{command}\ncommand output was:\n#{output}")
      end
    ensure
      tmp.unlink if tmp
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
      %x{#{pdftk_command args}}
    end

    def cat(*files,output)
      files = files[0] if files[0].class == Array
      input = files.map{|f| %Q("#{f}")}
      call_pdftk(*input,'output',output)
    end

    protected

    def pdftk_command(*args)
      "#{pdftk} #{args.flatten.compact.join ' '} 2>&1"
    end


    def add_options(pwd)
      options = []
      if options[:flatten]
        options << ['flatten']
      end
      if options[:encrypt]
        options.concat ['encrypt_128bit', 'owner_pw', pwd, options[:encrypt_options]]
      end
      return options unless optons.empty?
    end



  end
end
