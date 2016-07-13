# coding: UTF-8

require 'test_helper'

class FieldTest < Minitest::Test

  def setup
  end

  CHOICE_FIELD = <<-END
FieldType: Choice
FieldName: SomeChoiceField
FieldFlags: 71696384
FieldValue: http://github.com foo 
FieldValueDefault:  
FieldJustification: Left
FieldStateOption:  
FieldStateOption: 010 Foo Bar
FieldStateOption: Another option (xyz)
END

  def test_init_with_choice
    f = PdfForms::Field.new CHOICE_FIELD
    assert_equal 'Choice', f.type
    assert_equal 'SomeChoiceField', f.name
    assert_equal ['', '010 Foo Bar', 'Another option (xyz)'], f.options

    assert_equal "http://github.com foo", f.value
    assert_equal nil, f.value_default
    assert_equal "Left", f.justification
    assert_equal "71696384", f.flags
  end
  
  def test_to_hash
    f = PdfForms::Field.new CHOICE_FIELD
    assert f.respond_to?(:to_hash)
    assert_equal ['', '010 Foo Bar', 'Another option (xyz)'], f.to_hash[:options]
  end


  UNKNOWN_FIELD = <<-END
FieldType: Choice
FieldFoo: FooTown
FieldBar: BarTown
END

  def test_generate_new_field_key_accessors_on_the_fly
    f = PdfForms::Field.new UNKNOWN_FIELD
    assert_equal 'FooTown', f.foo
    assert_equal 'BarTown', f.bar
  end

  VALUE_WITH_COLON = <<-END
FieldType: Text
FieldName: Date
FieldNameAlt: Date: most recent
END

  def test_field_values_with_colons
    f = PdfForms::Field.new VALUE_WITH_COLON
    assert_equal 'Date: most recent', f.name_alt
  end

MULTILINE_TEXT_VALUE = <<-END
1. First element of my list;
2. Second element of my list;
3. Third element of my list.

This is my list.
END
MULTILINE_TEXT_FIELD = <<-END
FieldType: Text
FieldName: minhalista
FieldFlags: 4096
FieldValue: #{MULTILINE_TEXT_VALUE}
FieldJustification: Left
END

  def test_text_field_with_multiple_lines
    f = PdfForms::Field.new MULTILINE_TEXT_FIELD
    assert_equal MULTILINE_TEXT_VALUE, f.value
  end


end
