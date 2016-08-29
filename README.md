# pdf-forms [![Build Status](https://travis-ci.org/jkraemer/pdf-forms.png?branch=master)](https://travis-ci.org/jkraemer/pdf-forms)

http://github.com/jkraemer/pdf-forms/

## Description

Fill out PDF forms with [pdftk](http://www.pdflabs.com/tools/pdftk-server/).

## Installation

You'll need a working `pdftk` binary. Either get a binary package from
http://www.pdflabs.com/tools/pdftk-server/ and install it, or run
`apt-get install pdftk` if you're on Debian or similar.

After that, add `pdf-forms` to your Gemfile or manually install the gem. Nothing
unusual here.


## Usage

### FDF/XFdf creation

```ruby
require 'pdf_forms'
fdf = PdfForms::Fdf.new :key => 'value', :other_key => 'other value'
# use to_pdf_data if you just want the fdf data, without writing it to a file
puts fdf.to_pdf_data
# write fdf file
fdf.save_to 'path/to/file.fdf'
```

To generate XFDF instead of FDF instantiate `PdfForms::XFdf` instead of `PdfForms::Fdf`

### Query form fields and fill out PDF forms with pdftk

```ruby
require 'pdf_forms'

# adjust the pdftk path to suit your pdftk installation
# add :data_format => 'XFdf' option to generate XFDF instead of FDF when
# filling a form (XFDF is supposed to have better support for non-western
# encodings)
# add :utf8_fields => true in order to get UTF8 encoded field metadata (this
# will use dump_data_fields_utf8 instead of dump_data_fields in the call to
# pdftk)
pdftk = PdfForms.new('/usr/local/bin/pdftk')

# find out the field names that are present in form.pdf
pdftk.get_field_names 'path/to/form.pdf'

# take form.pdf, set the 'foo' field to 'bar' and save the document to myform.pdf
pdftk.fill_form '/path/to/form.pdf', 'myform.pdf', :foo => 'bar'

# optionally, add the :flatten option to prevent editing of a filled out form
pdftk.fill_form '/path/to/form.pdf', 'myform.pdf', {:foo => 'bar'}, :flatten => true

# to enable PDF encryption, pass encrypt: true. By default, a random 'owner
# password' will be used, but you can also set one with the :encrypt_pw option.
pdftk.fill_form '/path/to/form.pdf', 'myform.pdf', {foo: 'bar'}, encrypt: true, encrypt_options: 'allow printing'

# you can also protect the PDF even from opening by specifying an additional user_pw option:
pdftk.fill_form '/path/to/form.pdf', 'myform.pdf', {foo: 'bar'}, encrypt: true, encrypt_options: 'user_pw secret'
```

Any options shown above can also be set when initializing the PdfForms
instance. In this case, options given to `fill_form` will override the global
options.

### Prior Art

The FDF generation part is a straight port of Steffen Schwigon's PDF::FDF::Simple perl module. Didn't port the FDF parsing, though ;-)

## License

Created by [Jens Kraemer](http://jkraemer.net/) and licensed under the MIT License.

