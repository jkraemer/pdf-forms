# coding: UTF-8

module PdfForms
  # Map keys and values to Adobe's FDF format.
  #
  # This is a variation of the original Fdf data format, values are encoded in UTF16 hexadesimal
  # notation to improve compatibility with non ascii charsets.
  #
  # Information about hexadesimal FDF values was found here:
  #
  # http://stackoverflow.com/questions/6047970/weird-characters-when-filling-pdf-with-pdftk
  #
  class FdfHex < Fdf
    private

    def field(key, value)
      "<</T(#{key})/V" +
        (Array === value ? encode_many(value) : encode_value_as_hex(value)) +
        ">>\n"
    end

    def encode_many(values)
      "[#{values.map { |v| encode_value_as_hex(v) }.join}]"
    end

    def encode_value_as_hex(value)
      value = value.to_s
      utf_16 = value.encode('UTF-16BE', :invalid => :replace, :undef => :replace)
      hex = utf_16.unpack('H*').first
      hex.force_encoding 'ASCII-8BIT' # jruby
      '<FEFF' + hex.upcase + '>'
    end

    # Fdf implementation encodes to ISO-8859-15 which we do not want here.
    def encode_data(fdf)
      fdf
    end
  end
end
