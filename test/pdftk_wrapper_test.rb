# coding: utf-8

require 'test_helper'
class PdftkWrapperTest < Minitest::Test

  def setup
    @pdftk = PdfForms.new 'pdftk', :data_format => data_format
    @pdftk_utf8 = PdfForms.new 'pdftk', utf8_fields: true, data_format: data_format
    @pdftk_options = PdfForms.new :flatten => true, :encrypt => true, :data_format => data_format
    @pdftk_with_encrypt_options = PdfForms.new 'pdftk', :flatten => true, :encrypt => true, :data_format => data_format, :encrypt_options => 'allow printing'
  end

  def test_should_check_executable
    assert_raises(Cliver::Dependency::NotFound){ PdfForms.new('foobar') }
  end

  def test_get_fields_utf8
    assert fields = @pdftk_utf8.get_fields( 'test/fixtures/utf8.pdf' )
    assert fields.any?
    assert fields.detect{|f| f.name == '•?((¯°·._.• µţƒ-8 ƒɨ€ℓď •._.·°¯))؟•'}
  end

  def test_get_field_names_utf8
    assert fields = @pdftk_utf8.get_field_names( 'test/fixtures/utf8.pdf' )
    assert fields.any?
    assert fields.include?('•?((¯°·._.• µţƒ-8 ƒɨ€ℓď •._.·°¯))؟•')
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

  def test_fill_form_spaced_filename
    @pdftk.fill_form 'test/fixtures/form.pdf', 'out put.pdf', 'program_name' => 'SOME TEXT'
    assert File.size('out put.pdf') > 0
    FileUtils.rm 'out put.pdf'
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

  def test_fill_form_encrypted_and_flattened_with_encrypt_options
    @pdftk_with_encrypt_options.fill_form 'test/fixtures/form.pdf', 'output.pdf', 'program_name' => 'SOME TEXT'
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

  def test_cat_documents_page_ranges
    @pdftk.cat({'test/fixtures/form.pdf' => ["1-2", "4-5"]}, 'test/fixtures/one.pdf', {'test/fixtures/two.pdf' => ["1"]}, 'output.pdf')
    assert File.size('output.pdf') > 0
    FileUtils.rm 'output.pdf'
  end

  def test_stamp_document
    @pdftk.stamp 'test/fixtures/one.pdf', 'test/fixtures/stamp.pdf', 'output.pdf'
    assert File.size('output.pdf') > 0
    FileUtils.rm 'output.pdf'
  end

  def test_multistamp_document
    @pdftk.multistamp 'test/fixtures/one.pdf', 'test/fixtures/stamp.pdf', 'output.pdf'
    assert File.size('output.pdf') > 0
    FileUtils.rm 'output.pdf'
  end

  def test_fill_form_cli_injection
    @pdftk.fill_form 'test/fixtures/form.pdf', 'output.pdf"; touch "test/cli_injection', 'program_name' => 'SOME TEXT' rescue nil
    refute File.exist?('test/cli_injection'), "CLI injection successful"
  ensure
    FileUtils.rm 'output.pdf' if File.exist?('output.pdf')
    FileUtils.rm 'test/cli_injection' if File.exist?('test/cli_injection')
  end

  def data_format
    nil
  end
end
