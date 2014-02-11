# coding: UTF-8

require 'test_helper'

class XfdfTest < Test::Unit::TestCase
  def test_fdf_generation
    fdf = PdfForms::XFdf.new :field1 => 'fieldvalue1', :other_field => 'some other value'
    assert fdf_text = fdf.to_fdf
    assert_match %r{<field name=\"field1\"><value>fieldvalue1</value></field>}, fdf_text
    assert_match %r{<field name=\"other_field\"><value>some other value</value></field>}, fdf_text
  end

  def test_quoting
    fdf = PdfForms::XFdf.new :field1 => 'some<1>'
    assert fdf_text = fdf.to_fdf
    assert_match %r{<field name=\"field1\"><value>some&lt;1&gt;</value></field>}, fdf_text
  end

  def test_multival
    fdf = PdfForms::XFdf.new :field1 => %w(one two)
    assert fdf_text = fdf.to_fdf
    assert_match %r{<field name=\"field1\"><value>one two</value></field>}, fdf_text
  end
end
