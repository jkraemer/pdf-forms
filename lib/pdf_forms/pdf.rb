# coding: UTF-8

require 'pdf_forms/field'

module PdfForms
  class Pdf

    include SafePath

    attr_reader :path, :options

    def initialize(path, pdftk, options = {})
      @options = options
      @path = file_path(path)
      raise IOError unless File.readable?(@path)
      @pdftk = pdftk
    end

    # list of field objects for all defined fields
    #
    # Initialize the object with utf8_fields: true to get utf8 encoded field
    # names.
    def fields
      if @fields
        return @fields
      else # hacky, but gets use NameAlt, a human-friendly descriptor of the field.
        @fields = read_fields
        other_fields = read_other_fields      

        @fields.map do |f|        
          other_field = other_fields.select {|of| of['FieldName'] == f.name}.first
          
          f.set_name_alt!(other_field['FieldNameAlt'])
          f.set_max_length!(other_field['FieldMaxLength'])
          
          f
        end
      
        return @fields
      end
    end


    # the field object for the named field
    def field(name)
      fields.detect{ |f| f.name == name }
    end

    protected

    def read_fields
      dump_method = options[:utf8_fields] ? 'dump_data_fields_utf8' : 'dump_data_fields'
      field_output = @pdftk.call_pdftk quote_path(path), dump_method
      @fields = field_output.split(/^---\n/).map do |field_text|
        Field.new field_text if field_text =~ /FieldName:/
      end.compact
    end
    
    def read_other_fields
      dump_method = options[:utf8_fields] ? 'dump_data_fields_utf8' : 'dump_data_fields'
      fields = @pdftk.call_pdftk quote_path(path), dump_method
      fields = fields.split("---")
      @other_fields = []
      fields.each do |field|
        @hash = {}
        field.split("\n").each() do |line|
          next if line == ""
          key, value = line.split(": ")
          @hash[key] = value
        end
        next if @hash.empty?
        @other_fields.push @hash
      end
      
      @other_fields
    end
  end
end
