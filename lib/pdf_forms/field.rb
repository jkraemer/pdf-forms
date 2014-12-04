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
          if match = line.match(/^\s*(?<key>[^:]+):\s*(?<value>.*)$/)
            key = match[:key].to_s.strip
            value = match[:value].to_s
            var_name = key.gsub(/Field/, '').downcase
            unless self.respond_to?(var_name)
              self.class.send(:define_method, var_name.to_sym, Proc.new{ instance_variable_get("@#{var_name}".to_sym) } ) # in case new or unknown fields crop up...
            end
            instance_variable_set("@#{key.gsub(/Field/, '').downcase}".to_sym, value)
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
    ATTRS = [:name, :type, :options, :flags, :justification, :value, :valuedefault, :namealt]
    ATTRS.each {|attribute| attr_reader attribute}
  end
end
