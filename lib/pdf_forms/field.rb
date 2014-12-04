# coding: UTF-8

module PdfForms
  class Field
    # FieldType: Button
    # FieldName: Sprachoptionen_Inverssuche_Widerspruch
    # FieldFlags: 0
    # FieldJustification: Left
    # FieldStateOption: Ja
    # FieldStateOption: Off
    #
    # Represenation of a PDF Form Field
    def initialize(field_description)
      field_description.each_line do |line|
        case line
        when /FieldStateOption:\s*(.*?)\s*$/
          (@options ||= []) << $1
        else
          line.strip!
          key, value = line.split(": ")
          key.gsub!(/Field/, "")
          key = key.split(/(?=[A-Z])/).map(&:downcase).join('_').split(":")[0]
          
          instance_variable_set("@#{key}", value)
          
          # dynamically add in fields that we didn't anticipate in ATTRS
          unless self.respond_to?(key.to_sym)
            proc = Proc.new { instance_variable_get("@#{key}".to_sym) }
            self.class.send(:define_method, key.to_sym, proc)
          end
        end
      end
    end
    
    def to_hash
      hash = {}
      ATTRS.each do |attribute|
        hash[attribute] = self.send(attribute)
      end
      
      hash
    end

    # Common Fields
    ATTRS = [:name, :type, :options, :flags, :justification, :value, :value_default, :name_alt, :max_length]
    ATTRS.each {|attribute| attr_reader attribute}
  end
end
