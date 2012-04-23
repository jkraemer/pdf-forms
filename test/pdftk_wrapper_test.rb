require 'test_helper'

class PdftkWrapperTest < Test::Unit::TestCase

  def setup
    @pdftk = PdfForms.new 'pdftk'
  end

  def test_field_names
    assert fields = @pdftk.get_field_names( 'test/fixtures/form.pdf' )
    assert fields.any?
    assert fields.include?('program_name')
  end

  def test_fill_form
    @pdftk.fill_form 'test/fixtures/form.pdf', 'output.pdf', 'program_name' => 'SOME TEXT'
    assert File.size('output.pdf') > 0
    FileUtils.rm 'output.pdf'
  end
end
