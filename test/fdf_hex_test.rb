# coding: UTF-8

require 'test_helper'

# utf16 hex representation:
# foo: 0066006F006F
# bar: 006200610072
# qux: 007100750078

class FdfHexTest < Minitest::Test
  def test_fdf_generation
    fdf = PdfForms::FdfHex.new :field1 => 'foo', :other_field => 'bar qux'
    assert fdf_text = fdf.to_fdf
    assert_match %r{<</T\(field1\)/V<FEFF0066006F006F>>>}, fdf_text
    assert_match %r{<</T\(other_field\)/V<FEFF0062006100720020007100750078>>>}, fdf_text
  end

  def test_multival
    fdf = PdfForms::FdfHex.new :field1 => %w(foo bar)
    assert fdf_text = fdf.to_fdf
    assert_match '<</T(field1)/V[<FEFF0066006F006F><FEFF006200610072>]>>', fdf_text
  end
end
