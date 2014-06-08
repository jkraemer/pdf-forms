# coding: utf-8

require 'test_helper'
class PdftkWrapperTest < Test::Unit::TestCase

  def setup
    @pdftk = PdfForms.new 'pdftk', :data_format => data_format
    @pdftk_options = PdfForms.new 'pdftk', :flatten => true, :encrypt => true, :data_format => data_format
  end

  def test_should_check_executable
    assert_raises(RuntimeError){ PdfForms.new('foobar') }
  end

  def test_get_fields
    assert fields = @pdftk.get_fields( 'test/fixtures/form.pdf' )
    assert fields.any?
    assert fields.detect{|f| f.name == 'program_name'}
  end


  def test_get_field_names
    assert fields = @pdftk.get_field_names( 'test/fixtures/form.pdf' )
    assert fields.any?
    assert fields.include?('program_name')
  end

  def test_fill_form
    @pdftk.fill_form 'test/fixtures/form.pdf', 'output.pdf', 'program_name' => 'SOME TEXT'
    assert File.size('output.pdf') > 0
    FileUtils.rm 'output.pdf'
  end

  def test_fill_form_and_flatten
    @pdftk.fill_form 'test/fixtures/form.pdf', 'output.pdf',
                     {'program_name' => 'SOME TEXT'}, {:flatten => true}
    assert File.size('output.pdf') > 0
    fields = @pdftk.get_fields('output.pdf')
    assert fields.count == 0
    FileUtils.rm 'output.pdf'
  end

  def test_fill_form_encrypted_and_flattened
    @pdftk_options.fill_form 'test/fixtures/form.pdf', 'output.pdf', 'program_name' => 'SOME TEXT'
    assert File.size('output.pdf') > 0
    FileUtils.rm 'output.pdf'
  end

  def test_fill_form_with_non_ascii_iso_8859_chars
    @pdftk_options.fill_form 'test/fixtures/form.pdf', 'output_umlauts.pdf', 'program_name' => 'with ß and ümlaut'
    assert File.size('output_umlauts.pdf') > 0
    FileUtils.rm 'output_umlauts.pdf'
  end

  def test_cat_documents
    @pdftk.cat 'test/fixtures/one.pdf', 'test/fixtures/two.pdf', 'output.pdf'
    assert File.size('output.pdf') > 0
    FileUtils.rm 'output.pdf'
  end

  def data_format
    nil
  end
end
