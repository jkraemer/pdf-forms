module PdfForms
  class Pdf

    include SafePath

    attr_reader :path

    def initialize(path, pdftk)
      @path = file_path(path)
      raise IOError unless File.readable?(@path)
      @pdftk = pdftk
    end

    def fields
      @fields ||= read_fields
    end

    protected

    def read_fields
      field_output = @pdftk.call_pdftk quote_path(path), 'dump_data_fields'
      @fields = field_output.split(/^---\n/).map do |field_text|
        if field_text =~ /^FieldName: (\w+)$/
          $1
        end
      end.compact.uniq
    end
  end
end
