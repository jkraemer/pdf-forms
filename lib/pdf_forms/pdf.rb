# coding: UTF-8

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

    # list of field objects for all defined fields
    def fields
      @fields ||= read_fields
    end

    # the field object for the named field
    def field(name)
      fields.detect{ |f| f.name == name }
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
