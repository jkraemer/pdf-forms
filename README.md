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

### Using the Java port of PDFTK

The PDFTK package was dropped from most (all?) current versions of major Linux distributions.
As contributed in [this issue](https://github.com/jkraemer/pdf-forms/issues/75#issuecomment-698436643), you can use the [Java version of PDFTK](https://gitlab.com/pdftk-java/pdftk)
with this gem, as well. Just create a small shell script:

~~~shell
#!/bin/sh
MYSELF=`which "$0" 2>/dev/null`
[ $? -gt 0 -a -f "$0" ] && MYSELF="./$0"
java=java
if test -n "$JAVA_HOME"; then
    java="$JAVA_HOME/bin/java"
fi
exec "$java" $java_args -jar $MYSELF "$@"
exit 1
~~~

Next, concatenate the wrapper script and the Jar file, and you end up with an executable that 
can be used with pdf-forms:

~~~
cat stub.sh pdftk-all.jar > pdftk.run && chmod +x pdftk.run
~~~


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
# add :data_format => 'FdfHex' option to generate FDF with values passed in
# UTF16 hexadecimal format (Hexadecimal format has also proven more reliable
# for passing latin accented characters to pdftk)
# add :utf8_fields => true in order to get UTF8 encoded field metadata (this
# will use dump_data_fields_utf8 instead of dump_data_fields in the call to
# pdftk)
pdftk = PdfForms.new('/usr/local/bin/pdftk')

# find out the field names that are present in form.pdf
pdftk.get_field_names 'path/to/form.pdf'

# take form.pdf, set the 'foo' field to 'bar' and save the document to myform.pdf
pdftk.fill_form '/path/to/form.pdf', 'myform.pdf', :foo => 'bar'

# optionally, add the :flatten option to prevent editing of a filled out form.
# Other supported options are :drop_xfa and :drop_xmp.
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

### Field names with HTML entities

In case your form's field names contain HTML entities (like
`Stra&#223;e Hausnummer`), make sure you unescape those before using them, i.e.
`CGI.unescapeHTML(name)`.  Thanks to @phoet for figuring this out in #65.

### Non-ASCII Characters (UTF8 etc) are not displayed in the filled out PDF

First, check if the field value has been stored properly in the output PDF using `pdftk output.pdf dump_data_fields_utf8`.

If it has been stored but is not rendered, your input PDF lacks the proper font for your kind of characters. Re-create it and embed any necessary fonts.
If the value has not been stored, there is a problem with filling out the form, either on your side, of with this gem.

Also see [UTF-8 chars are not displayed in the filled PDF](https://github.com/jkraemer/pdf-forms/issues/53)

### Prior Art

The FDF generation part is a straight port of Steffen Schwigon's PDF::FDF::Simple perl module. Didn't port the FDF parsing, though ;-)

## License

Created by [Jens Kraemer](http://jkraemer.net/) and licensed under the MIT License.

