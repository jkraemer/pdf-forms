module PdfForms
  class Pdf
    attr_reader :path

    def initialize(path, pdftk)
      @path = path
      @pdftk = pdftk
    end

    def fields
      @fields ||= read_fields
    end

    protected

    def read_fields
      field_output = @pdftk.call_pdftk %Q("#{path}"), 'dump_data_fields'
      @fields = field_output.split(/^---\n/).map do |field_text|
        if field_text =~ /^FieldName: (\w+)$/
          $1
        end
      end.compact.uniq
    end
  end
end
