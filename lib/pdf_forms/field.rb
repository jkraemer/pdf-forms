# coding: UTF-8

module PdfForms
  class Field

    # FieldType: Button
    # FieldName: Sprachoptionen_Inverssuche_Widerspruch
    # FieldFlags: 0
    # FieldJustification: Left
    # FieldStateOption: Ja
    # FieldStateOption: Off
    def initialize(field_description)
      field_description.each_line do |line|
        case line
        when /FieldType:\s*(.+?)\s*$/
          @type = $1
        when /FieldName:\s*(.+?)\s*$/
          @name = $1
        when /FieldStateOption:\s*(.*?)\s*$/
          (@options ||= []) << $1
        end
      end
    end

    attr_reader :name, :type, :options
  end
end
