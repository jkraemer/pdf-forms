# coding: UTF-8

module PdfForms
  # Map keys and values to Adobe's XFDF format.
  class XFdf < DataFormat
    def initialize(data = {}, options = {})
      super
    end

    protected

    def encode_data(pdf_data)
      pdf_data
    end

    def quote(value)
      require 'rexml/document'
      REXML::Text.new(value.to_s).to_s
    end

    def header
      '<?xml version="1.0" encoding="UTF-8"?>
        <xfdf xmlns="http://ns.adobe.com/xfdf/" xml:space="preserve">
          <fields>
      '
    end

    def field(key, value)
      "<field name=\"#{key}\"><value>#{Array(value).map{ |v| quote(v) }.join(" ")}</value></field>"
    end

    def footer
      "</fields></xfdf>"
    end
  end
end
