require 'test_helper'

class PdfTest < Test::Unit::TestCase
  
  def setup
    @pdftk = PdfForms::PdftkWrapper.new 'pdftk'
  end
  
  def test_fields    
    pdf = PdfForms::Pdf.new 'test/fixtures/form.pdf', @pdftk
    assert fields = pdf.fields
    assert fields.any?
    assert fields.include?('program_name')
  end
  
end