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
    
    def set_name_alt!(name_alt)
      @name_alt = name_alt
    end
    
    def set_max_length!(max_length)
      @max_length = max_length
    end
    
    def to_hash
      @hash ||= {
        name: @name,
        type: @type,
        options: @options,
        flags: @flags,
        justification: @justification,
        value: @value,
        value_default: @valuedefault,
        name_alt: @name_alt,
        max_length: @max_length
      }.delete_if {|k,v| v.nil?}
    end
    
    def to_json(*args)
      JSON.pretty_generate(to_hash)
    end

    # Common Fields
    attr_reader :name, :type, :options, 
                :flags, :justification, 
                :value, :valuedefault, 
                :name_alt, :max_length
  end
end
