# coding: UTF-8

require 'rexml/document'

module PdfForms
  # Map keys and values to Adobe's XFDF format.
  class XFdf < DataFormat
    def initialize(data = {}, options = {})
      super
    end

    private

    def encode_data(pdf_data)
      pdf_data
    end

    def quote(value)
      REXML::Text.new(value.to_s).to_s
    end

    def escape(value)
      Array(value).map{ |v| quote(v) }.join(" ")
    end

    def header
      '<?xml version="1.0" encoding="UTF-8"?>
        <xfdf xmlns="http://ns.adobe.com/xfdf/" xml:space="preserve">
          <fields>
      '
    end
    
    def field(key, value)
      "<field name=\"#{escape(key)}\"><value>#{escape(value)}</value></field>"
    end

    def footer
      "</fields></xfdf>"
    end
  end
end
