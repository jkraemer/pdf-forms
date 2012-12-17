require 'pdf_forms/field'

module PdfForms
  class Pdf

    include SafePath

    attr_reader :path

    def initialize(path, pdftk)
      @path = file_path(path)
      raise IOError unless File.readable?(@path)
      @pdftk = pdftk
    end

    # list of field names
    def fields
      field_objects.map{ |f| f.name }
    end

    # the field object for the named field
    def field(name)
      field_objects.detect{ |f| f.name == name }
    end

    # list of field objects for all defined fields
    def field_objects
      @fields ||= read_fields
    end

    protected

    def read_fields
      field_output = @pdftk.call_pdftk quote_path(path), 'dump_data_fields'
      @fields = field_output.split(/^---\n/).map do |field_text|
        Field.new field_text if field_text =~ /FieldName:/
      end.compact
    end
  end
end
