# coding: UTF-8

require 'tempfile'
module PdfForms
  class PdftkError < StandardError
  end

  # Wraps calls to PdfTk
  class PdftkWrapper

    include SafePath

    attr_reader :pdftk, :options

    # PdftkWrapper.new('/usr/bin/pdftk', :flatten => true, :encrypt => true, :encrypt_options => 'allow Printing')
    def initialize(pdftk_path, options = {})
      @pdftk = file_path(pdftk_path)
      raise "pdftk executable #{@pdftk} not found" unless call_pdftk('-h') =~ /pdftk\s+\d/i
      @options = options
    end

    # pdftk.fill_form '/path/to/form.pdf', '/path/to/destination.pdf', :field1 => 'value 1'
    def fill_form(template, destination, data = {})
      q_template = safe_path(template)
      q_destination = safe_path(destination)
      fdf = Fdf.new(data)
      tmp = Tempfile.new('pdf_forms-fdf')
      tmp.close
      fdf.save_to tmp.path
      command = pdftk_command q_template, 'fill_form', safe_path(tmp.path), 'output', q_destination, add_options(tmp.path)
      output = %x{#{command}}
      unless File.readable?(destination) && File.size(destination) > 0
        fdf_path = nil
        begin
          fdf_path = File.join(File.dirname(tmp.path), "#{Time.now.strftime '%Y%m%d%H%M%S'}.fdf")
          fdf.save_to fdf_path
        rescue Exception
          fdf_path = "#{$!}\n#{$!.backtrace.join("\n")}"
        end
        raise PdftkError.new("failed to fill form with command\n#{command}\ncommand output was:\n#{output}\nfailing form data has been saved to #{fdf_path}")
      end
    ensure
      tmp.unlink if tmp
    end

    # pdftk.read '/path/to/form.pdf'
    # returns an instance of PdfForms::Pdf representing the given template
    def read(path)
      Pdf.new path, self
    end

    def get_fields(template)
      read(template).fields
    end

    def get_field_names(template)
      read(template).fields.map{|f| f.name}
    end

    def call_pdftk(*args)
      %x{#{pdftk_command args}}
    end

    # concatenate documents
    #
    # args: in_file1, in_file2, ... , in_file_n, output
    def cat(*args)
      arguments = args.flatten.compact.map{|path| safe_path(path)}
      output = arguments.pop
      call_pdftk(*([arguments, 'output', output].flatten))
    end

    protected

    def pdftk_command(*args)
      quote_path(pdftk) + " #{args.flatten.compact.join ' '} 2>&1"
    end

    def add_options(pwd)
      return if options.empty?
      opt_args = []
      if options[:flatten]
        opt_args << 'flatten'
      end
      if options[:encrypt]
        opt_args.concat ['encrypt_128bit', 'owner_pw', pwd, options[:encrypt_options]]
      end
      opt_args
    end



  end
end
