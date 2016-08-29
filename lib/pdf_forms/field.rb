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
    # Representation of a PDF Form Field
    def initialize(field_description)
      last_value = nil
      field_description.each_line do |line|
        line.chomp!

        if line =~ /^Field([A-Za-z]+):\s+(.*)/
          _, key, value = *$~

          if key == 'StateOption'
            (@options ||= []) << value

          else
            value.chomp!
            last_value = value
            key = key.split(/(?=[A-Z])/).map(&:downcase).join('_')
            instance_variable_set("@#{key}", value)

            # dynamically add in fields that we didn't anticipate in ATTRS
            unless self.respond_to?(key.to_sym)
              proc = Proc.new { instance_variable_get("@#{key}".to_sym) }
              self.class.send(:define_method, key.to_sym, proc)
            end
          end

        else
          # pdftk returns a line that doesn't start with "Field"
          # It happens when a text field has multiple lines
          last_value << "\n" << line
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
