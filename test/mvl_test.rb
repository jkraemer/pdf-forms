# coding: UTF-8

require 'test_helper'
class MvlTest < Test::Unit::TestCase

  def setup
    @pdftk = PdfForms.new 'pdftk'
    @pdftk_options = PdfForms.new 'pdftk', :flatten => true, :encrypt => true
  end

  def test_fill_form_with_non_ascii_iso_8859_chars
    u8 = IO.read('u8')
    @pdftk_options.fill_form 'Vertragsverlaengerung_Portal.pdf', 'output_umlauts.pdf', 'Lieferadresse' => u8
  end

end
