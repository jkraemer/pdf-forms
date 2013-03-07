# coding: UTF-8

require 'test_helper'

class PdfTest < Test::Unit::TestCase

  def setup
    @pdftk = PdfForms::PdftkWrapper.new 'pdftk'
  end

  def test_fields
    pdf = PdfForms::Pdf.new 'test/fixtures/form.pdf', @pdftk
    assert fields = pdf.fields
    assert fields.any?
    assert fields.detect{|f|f.name == 'program_name'}
  end

  def test_should_have_field_metadata
    pdf = PdfForms::Pdf.new 'test/fixtures/form.pdf', @pdftk
    assert f = pdf.field('area5_answer4')
    assert_equal 'Button', f.type
    assert_equal ['NOT YET', 'Off', 'SOMETIMES', 'YES'], f.options
  end

  def test_should_error_when_file_not_readable
    assert_raises(IOError){
      PdfForms::Pdf.new 'foo/bar.pdf', @pdftk
    }
  end
end
