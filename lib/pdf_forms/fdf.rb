# coding: UTF-8

module PdfForms

  # Map keys and values to Adobe's FDF format.
  #
  # Straight port of Perl's PDF::FDF::Simple by Steffen Schwigon.
  # Parsing FDF files is not supported (yet).
  class Fdf < DataFormat

    def initialize(data = {}, options = {})
      super
    end

    private

    def encode_data(fdf)
      # I have yet to see a version of pdftk which can handle UTF8 input,
      # so we convert to ISO-8859-15 here, replacing unknown / invalid chars
      # with the default replacement which is '?'.
      if fdf.respond_to?(:encode!)
        # Ruby >= 1.9
        fdf.encode!('ISO-8859-15', :invalid => :replace, :undef => :replace)
      else
        # pre 1.9
        require 'iconv'
        Iconv.conv('ISO-8859-15//IGNORE', 'utf-8', fdf)
      end
    end

    # pp 559 https://www.adobe.com/content/dam/acom/en/devnet/pdf/pdfs/pdf_reference_archives/PDFReference.pdf
    def header
      header = +"%FDF-1.2\n\n1 0 obj\n<<\n/FDF << /Fields 2 0 R"

      # /F
      header << "/F (#{options[:file]})" if options[:file]
      # /UF
      header << "/UF (#{options[:ufile]})" if options[:ufile]
      # /ID
      header << "/ID[" << options[:id].join << "]" if options[:id]

      header << ">>\n>>\nendobj\n2 0 obj\n["
      header
    end

    # pp 561 https://www.adobe.com/content/dam/acom/en/devnet/pdf/pdfs/pdf_reference_archives/PDFReference.pdf
    def field(key, value)
      field = +"<<"
      field << "/T" + "(#{key})"
      field << "/V" + (Array === value ? "[#{value.map{ |v|"(#{quote(v)})" }.join}]" : "(#{quote(value)})")
      field << ">>\n"
      field
    end

    def quote(value)
      value.to_s.
        gsub( /(\\|\(|\))/ ) { '\\' + $1 }.
        gsub( /\n/, '\r' )
    end

    FOOTER =<<-EOFOOTER
]
endobj
trailer
<<
/Root 1 0 R

>>
%%EOF
EOFOOTER

    def footer
      FOOTER
    end

  end
end
