# coding: UTF-8

require 'htmlentities'
require 'test_helper'
require 'pdftk_wrapper_test'

class XfdfPdftkWrapperTest < PdftkWrapperTest
  def data_format
    'XFdf'
  end

  def test_fill_form_with_japanese
    japanese_string = 'スペイン'
    @pdftk.fill_form 'test/fixtures/japanese.pdf', 'output.pdf', 'nationality' => japanese_string
    assert File.size('output.pdf') > 0

    assert field = @pdftk.get_fields('output.pdf').detect{|f| f.name == 'nationality'}
    assert value = field.value
    refute value.empty?
    assert_equal japanese_string, HTMLEntities.new.decode(value)

    assert field = @pdftk_utf8.get_fields('output.pdf').detect{|f| f.name == 'nationality'}
    assert value = field.value
    refute value.empty?
    assert_equal japanese_string, value

    FileUtils.rm 'output.pdf'
  end

end
