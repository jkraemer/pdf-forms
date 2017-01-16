# coding: UTF-8

require 'pdf_forms/field'

module PdfForms
  class Pdf
    include NormalizePath

    attr_reader :path, :options

    def initialize(path, pdftk, options = {})
      @options = options
      @path = normalize_path(path)
      raise IOError unless File.readable?(@path)
      @pdftk = pdftk
    end

    # list of field objects for all defined fields
    #
    # Initialize the object with utf8_fields: true to get utf8 encoded field
    # names.
    def fields
      @fields ||= read_fields
    end
    def fields_utf8
      @fields ||= read_fields_utf8
    end
    def read_fields_utf8
      field_output = @pdftk.call_pdftk quote_path(path), 'dump_data_fields_utf8'
      @fields = field_output.split(/^---\n/).map do |field_text|
        Field.new field_text if field_text =~ /FieldName:/
      end.compact
    end
    # the field object for the named field
    def field(name)
      fields.detect{ |f| f.name == name }
    end

    private

    def read_fields
      dump_method = options[:utf8_fields] ? 'dump_data_fields_utf8' : 'dump_data_fields'
      field_output = @pdftk.call_pdftk path, dump_method
      @fields = field_output.split(/^---\n/).map do |field_text|
        Field.new field_text if field_text =~ /FieldName:/
      end.compact
    end
  end
end
