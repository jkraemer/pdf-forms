require 'test_helper'

class FieldTest < Test::Unit::TestCase

  def setup
  end

  CHOICE_FIELD = <<-END
FieldType: Choice
FieldName: SomeChoiceField
FieldFlags: 71696384
FieldValue:  
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
  end

end

