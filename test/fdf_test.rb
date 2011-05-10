require 'test_helper'

class FdfTest < Test::Unit::TestCase
  def test_fdf_generation
    fdf = PdfForms::Fdf.new :field1 => 'fieldvalue1', :other_field => 'some other value'
    assert fdf_text = fdf.to_fdf
    assert_match %r{<</T\(field1\)/V\(fieldvalue1\)>>}, fdf_text
    assert_match %r{<</T\(other_field\)/V\(some other value\)>>}, fdf_text
  end
  
  def test_quoting
    fdf = PdfForms::Fdf.new :field1 => 'field(va)lue1'
    assert fdf_text = fdf.to_fdf
    assert_match '<</T(field1)/V(field\(va\)lue1)>>', fdf_text
  end
  
  def test_multival
    fdf = PdfForms::Fdf.new :field1 => %w(one two)
    assert fdf_text = fdf.to_fdf
    assert_match '<</T(field1)/V[(one)(two)]>>', fdf_text
  end
end