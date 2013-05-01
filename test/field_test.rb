# coding: UTF-8

require 'test_helper'

class FieldTest < Test::Unit::TestCase

  def setup
  end

  CHOICE_FIELD = <<-END
FieldType: Choice
FieldName: SomeChoiceField
FieldFlags: 71696384
FieldValue: Abc123
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

    assert_equal "Abc123", f.value
    assert_equal "", f.valuedefault
    assert_equal "Left", f.justification
    assert_equal "71696384", f.flags
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

end

