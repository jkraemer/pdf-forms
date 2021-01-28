# coding: UTF-8

require 'test_helper'

class PdfTest < Minitest::Test

  def setup
    @pdftk = PdfForms::PdftkWrapper.new 'pdftk'
  end

  def test_fields
    pdf = PdfForms::Pdf.new 'test/fixtures/form.pdf', @pdftk
    assert fields = pdf.fields
    assert fields.any?
    assert fields.detect{|f|f.name == 'program_name'}
  end

  def test_fields_utf8
    pdf = PdfForms::Pdf.new 'test/fixtures/utf8.pdf', @pdftk, utf8_fields: true
    assert fields = pdf.fields
    assert fields.any?
    assert fields.detect{|f|f.name == '•?((¯°·._.• µţƒ-8 ƒɨ€ℓď •._.·°¯))؟•'}
  end

  def test_should_have_field_metadata
    pdf = PdfForms::Pdf.new 'test/fixtures/form.pdf', @pdftk
    assert f = pdf.field('area5_answer4')
    assert_equal 'Button', f.type
    assert_equal ['NOT YET', 'Off', 'SOMETIMES', 'YES'], f.options.sort
  end

  def test_should_error_when_file_not_readable
    assert_raises(IOError){
      PdfForms::Pdf.new 'foo/bar.pdf', @pdftk
    }
  end
end
