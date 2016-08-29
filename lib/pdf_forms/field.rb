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
      last_value = nil
      field_description.each_line do |line|
        case line
        when /FieldStateOption:\s*(.*?)\s*$/
          (@options ||= []) << $1
        else
          line.strip!
          key, value = line.split(": ", 2)
          if key and key.gsub!(/Field/, "")
            key = key.split(/(?=[A-Z])/).map(&:downcase).join('_').split(":")[0]

            instance_variable_set("@#{key}", value)
            
            # dynamically add in fields that we didn't anticipate in ATTRS
            unless self.respond_to?(key.to_sym)
              proc = Proc.new { instance_variable_get("@#{key}".to_sym) }
              self.class.send(:define_method, key.to_sym, proc)
            end
            last_value = value
          else
            # pdftk returns a line that doesn't start with "Field"
            # It happens when a text field has multiple lines
            last_value << "\n" << line
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
