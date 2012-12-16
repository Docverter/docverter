Languages
=========

Docverter has an [official Ruby Gem](http://rubygems.org/gems/docverter) ([Github](https://github.com/docverter/docverter-ruby)). The API described here can of course be used by any language that can make HTTP requests.

Conversions
===========

The API has one endpoint:

    POST http://c.docverter.com/convert

The contents of your POST should be `multipart/form-data` and consist of your input file(s) and options which describe your conversion. For example:

    curl \
      --form input_files[]=@chapter1.md \
      --form input_files[]=@chapter2.md \
      --form input_files[]=@chapter3.md \
      --form from=markdown \
      --form to=pdf \
      --form css=stylesheet.css \
      --form other_files[]=@stylesheet.css \
      http://c.docverter.com/convert
      
You can also use [httpie](https://github.com/jkbr/httpie), another `curl`-like command line tool:

    http --form -f POST http://c.docverter.com/convert \
      from=markdown \
      to=html \
      input_files[]@example.md \
      --output out.html

The `examples` directory contains several examples showing off various API options. 

Full Option Reference
=====================

General options
---------------

**`input_files[]`** *ATTACHMENT*

A single input file. This can be specified multiple times. The value should be a `multipart/form-data` file upload.

**`other_files[]`** *ATTACHMENT*

A single additional file. This can be speicifed multiple times. The value should be a `multipart/form-data` file upload.

**`from`**

Specify input format.  *FORMAT* can be `markdown` (markdown),
`textile` (Textile), `rst` (reStructuredText), `html` (HTML),
`docbook` (DocBook XML), or `latex` (LaTeX).

**`to`**

Specify output format.  *FORMAT* can be `markdown` (markdown), `rst` (reStructuredText), `html` (XHTML 1),
`latex` (LaTeX), `context` (ConTeXt), `mediawiki` (MediaWiki markup),
`textile` (Textile), `org` (Emacs Org-Mode), `texinfo` (GNU Texinfo),
`docbook` (DocBook XML), `docx` (Word docx), `epub` (EPUB book),
`mobi` (Kindle book), `asciidoc` (AsciiDoc),  or `rtf` (rich text format).


Reader options
--------------

**`strict`**

Use strict markdown syntax, with no docverter extensions or variants.
When the input format is HTML, this means that constructs that have no
equivalents in standard markdown (e.g. definition lists or strikeout
text) will be parsed as raw HTML.

**`parse_raw`**

Parse untranslatable HTML codes and LaTeX environments as raw HTML
or LaTeX, instead of ignoring them. 

**`smart`**

Produce typographically correct output, converting straight quotes
to curly quotes, `---` to em-dashes, `--` to en-dashes, and
`...` to ellipses. Nonbreaking spaces are inserted after certain
abbreviations, such as "Mr." (Note: This option is significant only when
the input format is `markdown` or `textile`. It is selected automatically
when the input format is `textile` or the output format is `latex` or
`context`, unless `--no-tex-ligatures` is used.)

**`base_header_level`** *NUMBER*

Specify the base level for headers (defaults to 1).

**`indented_code_classes`** *CLASSES*

Specify classes to use for indented code blocks--for example,
`perl,numberLines` or `haskell`. Multiple classes may be separated by commas.

**`normalize`**

Normalize the document after reading:  merge adjacent
`Str` or `Emph` elements, for example, and remove repeated `Space`s.

**`preserve_tabs`**

Preserve tabs instead of converting them to spaces (the default).

**`tab-stop`** *NUMBER*

Specify the number of spaces per tab (default is 4).

General writer options
----------------------

**`template`** *FILE*

Use *FILE* as a custom template for the generated document. See [Templates](#templates) below for a description
of template syntax. If no extension is specified, an extension
corresponding to the writer will be added, so that `template: special`
looks for `special.html` for HTML output. If this option is not used, a default
template appropriate for the output format will be used. This file must be included using `other_files[]`.

**`no_wrap`**

Disable text wrapping in output. By default, text is wrapped
appropriately for the output format.

**`columns`** *NUMBER*

Specify length of lines in characters (for text wrapping).

**`table_of_contents`**

Include an automatically generated table of contents (or, in
the case of `latex`, `context`, and `rst`, an instruction to create
one) in the output document.

**`no_highlight`**

Disables syntax highlighting for code blocks and inlines, even when
a language attribute is given.

**`highlight_style`** *STYLE*

Specifies the coloring style to be used in highlighted source code.
Options are `pygments` (the default), `kate`, `monochrome`,
`espresso`, `zenburn`, `haddock`, and `tango`.

**`include_in_header`** *FILE*

Include contents of *FILE*, verbatim, at the end of the header.
This can be used, for example, to include special
CSS or javascript in HTML documents.  This file must be included using `other_files[]`.

**`include_before_body`** *FILE*

Include contents of *FILE*, verbatim, at the beginning of the
document body (e.g. after the `<body>` tag in HTML, or the
`\begin{document}` command in LaTeX). This can be used to include
navigation bars or banners in HTML documents.  This file must be included using `other_files[]`.

**`include_after_body`** *FILE*

Include contents of *FILE*, verbatim, at the end of the document
body (before the `</body>` tag in HTML, or the
`\end{document}` command in LaTeX).  This file must be included using `other_files[]`.
    
**`variable`** *KEY[:VAL]*

Set the template variable *KEY* to the value *VAL* when rendering the
document in standalone mode. This is generally only useful when the
`template` option is used to specify a custom template, since
docverter automatically sets the variables used in the default
templates.  If no *VAL* is specified, the key will be given the
value `true`.

Options affecting specific writers
----------------------------------

**`ascii`**

Use only ascii characters in output.  Currently supported only
for HTML output (which uses numerical entities instead of
UTF-8 when this option is selected).

**`reference_links`**

Use reference-style links, rather than inline links, in writing markdown
or reStructuredText.  By default inline links are used.

**`atx_headers`**

Use ATX style headers in markdown output. The default is to use
setext-style headers for levels 1-2, and then ATX headers.

**`chapters`**

Treat top-level headers as chapters in LaTeX, ConTeXt, and DocBook
output.  When the LaTeX template uses the report, book, or
memoir class, this option is implied.

**`number_sections`**

Number section headings in LaTeX, ConTeXt, or HTML output.
By default, sections are not numbered.

**`no_tex_ligatures`**

Do not convert quotation marks, apostrophes, and dashes to
the TeX ligatures when writing LaTeX or ConTeXt. Instead, just
use literal unicode characters. This is needed for using advanced
OpenType features with XeLaTeX and LuaLaTeX. Note: normally
`smart` is selected automatically for LaTeX and ConTeXt
output, but it must be specified explicitly if `no_tex_ligatures`
is selected. If you use literal curly quotes, dashes, and ellipses
in your source, then you may want to use `no_tex_ligatures`
without `smart`.

**`listings`**

Use listings package for LaTeX code blocks

**`section_divs`**

Wrap sections in `<div>` tags (or `<section>` tags in HTML5),
and attach identifiers to the enclosing `<div>` (or `<section>`)
rather than the header itself.
See [Section identifiers](#header-identifiers-in-html-latex-and-context), below.

**`email_obfuscation`** *none|javascript|references*

Specify a method for obfuscating `mailto:` links in HTML documents.
*none* leaves `mailto:` links as they are.  *javascript* obfuscates
them using javascript. *references* obfuscates them by printing their
letters as decimal or hexadecimal character references.
If `strict` is specified, *references* is used regardless of the
presence of this option.

**`id_prefix`** *STRING*

Specify a prefix to be added to all automatically generated identifiers
in HTML output.  This is useful for preventing duplicate identifiers
when generating fragments to be included in other pages.

**`title_prefix`** *STRING*

Specify *STRING* as a prefix at the beginning of the title
that appears in the HTML header (but not in the title as it
appears at the beginning of the HTML body).

**`css=`** *URL*

Link to a CSS style sheet.

**`reference_docx`** *FILE*

Use the specified file as a style reference in producing a docx file.
For best results, the reference docx should be a modified version
of a docx file produced using docverter.  The contents of the reference docx
are ignored, but its stylesheets are used in the new docx.  This file must be included using `other_files[]`.

**`pdf_username`** *STRING*

Encrypt the output PDF with the given username.

**`pdf_password`** *STRING*

Encrypt the output PDF with the given password.

**`epub_stylesheet`** *FILE*

Use the specified CSS file to style the EPUB.  This file must be included using `other_files[]`.

**`epub_cover_image`** *FILE*

Use the specified image as the EPUB cover.  It is recommended
that the image be less than 1000px in width and height.  This file must be included using `other_files[]`.

**`epub_metadata`** *FILE*

Look in the specified XML file for metadata for the EPUB.
The file should contain a series of Dublin Core elements,
as documented at <http://dublincore.org/documents/dces/>.
For example:

     <dc:rights>Creative Commons</dc:rights>
     <dc:language>es-AR</dc:language>

By default, docverter will include the following metadata elements:
`<dc:title>` (from the document title), `<dc:creator>` (from the
document authors), `<dc:date>` (from the document date, which should
be in [ISO 8601 format]), `<dc:language>` (from the `lang`
variable, or, if is not set, the locale), and `<dc:identifier
id="BookId">` (a randomly generated UUID). Any of these may be
overridden by elements in the metadata file.  This file must be included using `other_files[]`.

**`epub_embed_font`** *FILE*

Embed the specified font in the EPUB. This option can be an
array to embed multiple fonts.  To use embedded fonts, you
will need to add declarations like the following to your CSS (see
`epub_stylesheet`):

    @font-face {
    font-family: DejaVuSans;
    font-style: normal;
    font-weight: normal;
    src:url("DejaVuSans-Regular.ttf");
    }
    @font-face {
    font-family: DejaVuSans;
    font-style: normal;
    font-weight: bold;
    src:url("DejaVuSans-Bold.ttf");
    }
    @font-face {
    font-family: DejaVuSans;
    font-style: italic;
    font-weight: normal;
    src:url("DejaVuSans-Oblique.ttf");
    }
    @font-face {
    font-family: DejaVuSans;
    font-style: italic;
    font-weight: bold;
    src:url("DejaVuSans-BoldOblique.ttf");
    }
    body { font-family: "DejaVuSans"; }

This file must be included using `other_files[]`.

Templates
=========

Docverter  uses a template to
add header and footer material that is needed for a self-standing
document.  A custom template
can be specified using the `template` option.

Templates may contain *variables*.  Variable names are sequences of
alphanumerics, `-`, and `_`, starting with a letter.  A variable name
surrounded by `$` signs will be replaced by its value.  For example,
the string `$title$` in

    <title>$title$</title>

will be replaced by the document title.

To write a literal `$` in a template, use `$$`.

Some variables are set automatically by docverter.  These vary somewhat
depending on the output format, but include:

**`header-includes`**

contents specified by `include_in_header` (may have multiple
values)

**`toc`**

non-null value if `table_of_contents` was specified

**`include-before`**

contents specified by `include_before_body` (may have
multiple values)

**`include-after`**

contents specified by `include_after_body` (may have
multiple values)

**`body`**

body of document

**`title`**

title of document, as specified in title block

**`author`**

author of document, as specified in title block (may have
multiple values)

**`date`**

date of document, as specified in title block

**`lang`**

language code for HTML or LaTeX documents

**`fontsize`**

font size (10pt, 11pt, 12pt) for LaTeX documents

**`documentclass`**

document class for LaTeX documents

**`geometry`**

options for LaTeX `geometry` class, e.g. `margin=1in`;
may be repeated for multiple options

**`mainfont`**, **`sansfont`**, **`monofont`**, **`mathfont`**

fonts for LaTeX documents (works only with xelatex
and lualatex)

**`linkcolor`**

color for internal links in LaTeX documents (`red`, `green`,
`magenta`, `cyan`, `blue`, `black`)

**`urlcolor`**

color for external links in LaTeX documents

**`links-as-notes`**

causes links to be printed as footnotes in LaTeX documents

Variables may be set in the manifest using the `variable`
option. This allows users to include custom variables in their
templates.

Templates may contain conditionals.  The syntax is as follows:

    $if(variable)$
    X
    $else$
    Y
    $endif$

This will include `X` in the template if `variable` has a non-null
value; otherwise it will include `Y`. `X` and `Y` are placeholders for
any valid template text, and may include interpolated variables or other
conditionals. The `$else$` section may be omitted.

When variables can have multiple values (for example, `author` in
a multi-author document), you can use the `$for$` keyword:

    $for(author)$
    <meta name="author" content="$author$" />
    $endfor$

You can optionally specify a separator to be used between
consecutive items:

    $for(author)$$author$$sep$, $endfor$

If you use custom templates, you may need to revise them as pandoc
changes.  We recommend tracking the changes in the default templates,
and modifying your custom templates accordingly. An easy way to do this
is to fork the pandoc-templates repository
(<http://github.com/jgm/pandoc-templates>) and merge in changes after each
pandoc release.

Docverter's markdown
====================

Docverter understands an extended and slightly revised version of
John Gruber's [markdown][] syntax.  This document explains the syntax,
noting differences from standard markdown. Except where noted, these
differences can be suppressed by specifying the `--strict` command-line
option.

Philosophy
----------

Markdown is designed to be easy to write, and, even more importantly,
easy to read:

> A Markdown-formatted document should be publishable as-is, as plain
> text, without looking like it's been marked up with tags or formatting
> instructions.
> -- [John Gruber](http://daringfireball.net/projects/markdown/syntax#philosophy)

This principle has guided docverter's decisions in finding syntax for
tables, footnotes, and other extensions.

There is, however, one respect in which docverter's aims are different
from the original aims of markdown.  Whereas markdown was originally
designed with HTML generation in mind, docverter is designed for multiple
output formats.  Thus, while docverter allows the embedding of raw HTML,
it discourages it, and provides other, non-HTMLish ways of representing
important document elements like definition lists, tables, mathematics, and
footnotes.

Paragraphs
----------

A paragraph is one or more lines of text followed by one or more blank line.
Newlines are treated as spaces, so you can reflow your paragraphs as you like.
If you need a hard line break, put two or more spaces at the end of a line,
or type a backslash followed by a newline.

Headers
-------

There are two kinds of headers, Setext and atx.

### Setext-style headers ###

A setext-style header is a line of text "underlined" with a row of `=` signs
(for a level one header) of `-` signs (for a level two header):

    A level-one header
    ==================

    A level-two header
    ------------------

The header text can contain inline formatting, such as emphasis (see
[Inline formatting](#inline-formatting), below).


### Atx-style headers ###

An Atx-style header consists of one to six `#` signs and a line of
text, optionally followed by any number of `#` signs.  The number of
`#` signs at the beginning of the line is the header level:

    ## A level-two header

    ### A level-three header ###

As with setext-style headers, the header text can contain formatting:

    # A level-one header with a [link](/url) and *emphasis*

Standard markdown syntax does not require a blank line before a header.
Docverter does require this (except, of course, at the beginning of the
document). The reason for the requirement is that it is all too easy for a
`#` to end up at the beginning of a line by accident (perhaps through line
wrapping). Consider, for example:

    I like several of their flavors of ice cream:
    #22, for example, and #5.


### Header identifiers in HTML, LaTeX, and ConTeXt ###

*Docverter extension*.

Each header element in docverter's HTML and ConTeXt output is given a
unique identifier. This identifier is based on the text of the header.
To derive the identifier from the header text,

  - Remove all formatting, links, etc.
  - Remove all punctuation, except underscores, hyphens, and periods.
  - Replace all spaces and newlines with hyphens.
  - Convert all alphabetic characters to lowercase.
  - Remove everything up to the first letter (identifiers may
    not begin with a number or punctuation mark).
  - If nothing is left after this, use the identifier `section`.

Thus, for example,

  Header                            Identifier
  -------------------------------   ----------------------------
  Header identifiers in HTML        `header-identifiers-in-html`
  *Dogs*?--in *my* house?           `dogs--in-my-house`
  [HTML], [S5], or [RTF]?           `html-s5-or-rtf`
  3. Applications                   `applications`
  33                                `section`

These rules should, in most cases, allow one to determine the identifier
from the header text. The exception is when several headers have the
same text; in this case, the first will get an identifier as described
above; the second will get the same identifier with `-1` appended; the
third with `-2`; and so on.

These identifiers are used to provide link targets in the table of
contents generated by the `--toc|--table-of-contents` option. They
also make it easy to provide links from one section of a document to
another. A link to this section, for example, might look like this:

    See the section on
    [header identifiers](#header-identifiers-in-html).

Note, however, that this method of providing links to sections works
only in HTML, LaTeX, and ConTeXt formats.

If the `--section-divs` option is specified, then each section will
be wrapped in a `div` (or a `section`, if `--html5` was specified),
and the identifier will be attached to the enclosing `<div>`
(or `<section>`) tag rather than the header itself. This allows entire
sections to be manipulated using javascript or treated differently in
CSS.


Block quotations
----------------

Markdown uses email conventions for quoting blocks of text.
A block quotation is one or more paragraphs or other block elements
(such as lists or headers), with each line preceded by a `>` character
and a space. (The `>` need not start at the left margin, but it should
not be indented more than three spaces.)

    > This is a block quote. This
    > paragraph has two lines.
    >
    > 1. This is a list inside a block quote.
    > 2. Second item.

A "lazy" form, which requires the `>` character only on the first
line of each block, is also allowed:

    > This is a block quote. This
    paragraph has two lines.

    > 1. This is a list inside a block quote.
    2. Second item.

Among the block elements that can be contained in a block quote are
other block quotes. That is, block quotes can be nested:

    > This is a block quote.
    >
    > > A block quote within a block quote.

Standard markdown syntax does not require a blank line before a block
quote.  Docverter does require this (except, of course, at the beginning of the
document). The reason for the requirement is that it is all too easy for a
`>` to end up at the beginning of a line by accident (perhaps through line
wrapping). So, unless `--strict` is used, the following does not produce
a nested block quote in docverter:

    > This is a block quote.
    >> Nested.


Verbatim (code) blocks
----------------------

### Indented code blocks ###

A block of text indented four spaces (or one tab) is treated as verbatim
text: that is, special characters do not trigger special formatting,
and all spaces and line breaks are preserved.  For example,

        if (a > 3) {
          moveShip(5 * gravity, DOWN);
        }

The initial (four space or one tab) indentation is not considered part
of the verbatim text, and is removed in the output.

Note: blank lines in the verbatim text need not begin with four spaces.


### Delimited code blocks ###

*Docverter extension*.

In addition to standard indented code blocks, Docverter supports
*delimited* code blocks.  These begin with a row of three or more
tildes (`~`) or backticks (`` ` ``) and end with a row of tildes or
backticks that must be at least as long as the starting row. Everything
between these lines is treated as code. No indentation is necessary:

    ~~~~~~~
    if (a > 3) {
      moveShip(5 * gravity, DOWN);
    }
    ~~~~~~~

Like regular code blocks, delimited code blocks must be separated
from surrounding text by blank lines.

If the code itself contains a row of tildes or backticks, just use a longer
row of tildes or backticks at the start and end:

    ~~~~~~~~~~~~~~~~
    ~~~~~~~~~~
    code including tildes
    ~~~~~~~~~~
    ~~~~~~~~~~~~~~~~

Optionally, you may attach attributes to the code block using
this syntax:

    ~~~~ {#mycode .haskell .numberLines startFrom="100"}
    qsort []     = []
    qsort (x:xs) = qsort (filter (< x) xs) ++ [x] ++
                   qsort (filter (>= x) xs)
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Here `mycode` is an identifier, `haskell` and `numberLines` are classes, and
`startFrom` is an attribute with value `100`. Some output formats can use this
information to do syntax highlighting. Currently, the only output formats
that uses this information are HTML and LaTeX. If highlighting is supported
for your output format and language, then the code block above will appear
highlighted, with numbered lines. (To see which languages are supported, do
`docverter --version`.) Otherwise, the code block above will appear as follows:

    <pre id="mycode" class="haskell numberLines" startFrom="100">
      <code>
      ...
      </code>
    </pre>

A shortcut form can also be used for specifying the language of
the code block:

    ```haskell
    qsort [] = []
    ```

This is equivalent to:

    ``` {.haskell}
    qsort [] = []
    ```

To prevent all highlighting, use the `--no-highlight` flag.
To set the highlighting style, use `--highlight-style`.

Lists
-----

### Bullet lists ###

A bullet list is a list of bulleted list items.  A bulleted list
item begins with a bullet (`*`, `+`, or `-`).  Here is a simple
example:

    * one
    * two
    * three

This will produce a "compact" list. If you want a "loose" list, in which
each item is formatted as a paragraph, put spaces between the items:

    * one

    * two

    * three

The bullets need not be flush with the left margin; they may be
indented one, two, or three spaces. The bullet must be followed
by whitespace.

List items look best if subsequent lines are flush with the first
line (after the bullet):

    * here is my first
      list item.
    * and my second.

But markdown also allows a "lazy" format:

    * here is my first
    list item.
    * and my second.

### The four-space rule ###

A list item may contain multiple paragraphs and other block-level
content. However, subsequent paragraphs must be preceded by a blank line
and indented four spaces or a tab. The list will look better if the first
paragraph is aligned with the rest:

      * First paragraph.

        Continued.

      * Second paragraph. With a code block, which must be indented
        eight spaces:

            { code }

List items may include other lists.  In this case the preceding blank
line is optional.  The nested list must be indented four spaces or
one tab:

    * fruits
        + apples
            - macintosh
            - red delicious
        + pears
        + peaches
    * vegetables
        + brocolli
        + chard

As noted above, markdown allows you to write list items "lazily," instead of
indenting continuation lines. However, if there are multiple paragraphs or
other blocks in a list item, the first line of each must be indented.

    + A lazy, lazy, list
    item.

    + Another one; this looks
    bad but is legal.

        Second paragraph of second
    list item.

**Note:**  Although the four-space rule for continuation paragraphs
comes from the official [markdown syntax guide], the reference implementation,
`Markdown.pl`, does not follow it. So docverter will give different results than
`Markdown.pl` when authors have indented continuation paragraphs fewer than
four spaces.

The [markdown syntax guide] is not explicit whether the four-space
rule applies to *all* block-level content in a list item; it only
mentions paragraphs and code blocks.  But it implies that the rule
applies to all block-level content (including nested lists), and
docverter interprets it that way.

  [markdown syntax guide]:
    http://daringfireball.net/projects/markdown/syntax#list

### Ordered lists ###

Ordered lists work just like bulleted lists, except that the items
begin with enumerators rather than bullets.

In standard markdown, enumerators are decimal numbers followed
by a period and a space.  The numbers themselves are ignored, so
there is no difference between this list:

    1.  one
    2.  two
    3.  three

and this one:

    5.  one
    7.  two
    1.  three

*Docverter extension*.

Unlike standard markdown, Docverter allows ordered list items to be marked
with uppercase and lowercase letters and roman numerals, in addition to
arabic numerals. List markers may be enclosed in parentheses or followed by a
single right-parentheses or period. They must be separated from the
text that follows by at least one space, and, if the list marker is a
capital letter with a period, by at least two spaces.

Docverter also pays attention to the type of list marker used, and to the
starting number, and both of these are preserved where possible in the
output format. Thus, the following yields a list with numbers followed
by a single parenthesis, starting with 9, and a sublist with lowercase
roman numerals:

     9)  Ninth
    10)  Tenth
    11)  Eleventh
           i. subone
          ii. subtwo
         iii. subthree

Docverter will start a new list each time a different type of list
marker is used.  So, the following will create three lists:

    (2) Two
    (5) Three
    1.  Four
    *   Five

If default list markers are desired, use `#.`:

    #.  one
    #.  two
    #.  three


### Definition lists ###

*Docverter extension*.

Docverter supports definition lists, using a syntax inspired by
[PHP Markdown Extra] and [reStructuredText]:

    Term 1

    :   Definition 1

    Term 2 with *inline markup*

    :   Definition 2

            { some code, part of Definition 2 }

        Third paragraph of definition 2.

Each term must fit on one line, which may optionally be followed by
a blank line, and must be followed by one or more definitions.
A definition begins with a colon or tilde, which may be indented one
or two spaces. The body of the definition (including the first line,
aside from the colon or tilde) should be indented four spaces. A term may have
multiple definitions, and each definition may consist of one or more block
elements (paragraph, code block, list, etc.), each indented four spaces or one
tab stop.

If you leave space after the definition (as in the example above),
the blocks of the definitions will be considered paragraphs. In some
output formats, this will mean greater spacing between term/definition
pairs. For a compact definition list, do not leave space between the
definition and the next term:

    Term 1
      ~ Definition 1
    Term 2
      ~ Definition 2a
      ~ Definition 2b

[PHP Markdown Extra]: http://www.michelf.com/projects/php-markdown/extra/


### Numbered example lists ###

*Docverter extension*.

The special list marker `@` can be used for sequentially numbered
examples. The first list item with a `@` marker will be numbered '1',
the next '2', and so on, throughout the document. The numbered examples
need not occur in a single list; each new list using `@` will take up
where the last stopped. So, for example:

    (@)  My first example will be numbered (1).
    (@)  My second example will be numbered (2).

    Explanation of examples.

    (@)  My third example will be numbered (3).

Numbered examples can be labeled and referred to elsewhere in the
document:

    (@good)  This is a good example.

    As (@good) illustrates, ...

The label can be any string of alphanumeric characters, underscores,
or hyphens.


### Compact and loose lists ###

Docverter behaves differently from `Markdown.pl` on some "edge
cases" involving lists.  Consider this source: 

    +   First
    +   Second:
    	-   Fee
    	-   Fie
    	-   Foe

    +   Third

Docverter transforms this into a "compact list" (with no `<p>` tags around
"First", "Second", or "Third"), while markdown puts `<p>` tags around
"Second" and "Third" (but not "First"), because of the blank space
around "Third". Docverter follows a simple rule: if the text is followed by
a blank line, it is treated as a paragraph. Since "Second" is followed
by a list, and not a blank line, it isn't treated as a paragraph. The
fact that the list is followed by a blank line is irrelevant. (Note:
Docverter works this way even when the `--strict` option is specified. This
behavior is consistent with the official markdown syntax description,
even though it is different from that of `Markdown.pl`.)


### Ending a list ###

What if you want to put an indented code block after a list?

    -   item one
    -   item two

        { my code block }

Trouble! Here docverter (like other markdown implementations) will treat
`{ my code block }` as the second paragraph of item two, and not as
a code block.

To "cut off" the list after item two, you can insert some non-indented
content, like an HTML comment, which won't produce visible output in
any format:

    -   item one
    -   item two

    <!-- end of list -->

        { my code block }

You can use the same trick if you want two consecutive lists instead
of one big list:

    1.  one
    2.  two
    3.  three

    <!-- -->

    1.  uno
    2.  dos
    3.  tres

Horizontal rules
----------------

A line containing a row of three or more `*`, `-`, or `_` characters
(optionally separated by spaces) produces a horizontal rule:

    *  *  *  *

    ---------------


Tables
------

*Docverter extension*.

Three kinds of tables may be used. All three kinds presuppose the use of
a fixed-width font, such as Courier.

**Simple tables** look like this:

      Right     Left     Center     Default
    -------     ------ ----------   -------
         12     12        12            12
        123     123       123          123
          1     1          1             1

    Table:  Demonstration of simple table syntax.

The headers and table rows must each fit on one line.  Column
alignments are determined by the position of the header text relative
to the dashed line below it:

  - If the dashed line is flush with the header text on the right side
    but extends beyond it on the left, the column is right-aligned.
  - If the dashed line is flush with the header text on the left side 
    but extends beyond it on the right, the column is left-aligned.
  - If the dashed line extends beyond the header text on both sides,
    the column is centered.
  - If the dashed line is flush with the header text on both sides,
    the default alignment is used (in most cases, this will be left).

The table must end with a blank line, or a line of dashes followed by
a blank line. A caption may optionally be provided (as illustrated in
the example above). A caption is a paragraph beginning with the string
`Table:` (or just `:`), which will be stripped off. It may appear either
before or after the table.

The column headers may be omitted, provided a dashed line is used
to end the table. For example:

    -------     ------ ----------   -------
         12     12        12             12
        123     123       123           123
          1     1          1              1
    -------     ------ ----------   -------

When headers are omitted, column alignments are determined on the basis
of the first line of the table body. So, in the tables above, the columns
would be right, left, center, and right aligned, respectively.

**Multiline tables** allow headers and table rows to span multiple lines
of text (but cells that span multiple columns or rows of the table are
not supported).  Here is an example:

    -------------------------------------------------------------
     Centered   Default           Right Left
      Header    Aligned         Aligned Aligned
    ----------- ------- --------------- -------------------------
       First    row                12.0 Example of a row that
                                        spans multiple lines.

      Second    row                 5.0 Here's another one. Note
                                        the blank line between
                                        rows.
    -------------------------------------------------------------

    Table: Here's the caption. It, too, may span
    multiple lines.

These work like simple tables, but with the following differences:

  - They must begin with a row of dashes, before the header text
    (unless the headers are omitted).
  - They must end with a row of dashes, then a blank line.
  - The rows must be separated by blank lines.

In multiline tables, the table parser pays attention to the widths of
the columns, and the writers try to reproduce these relative widths in
the output. So, if you find that one of the columns is too narrow in the
output, try widening it in the markdown source.

Headers may be omitted in multiline tables as well as simple tables:

    ----------- ------- --------------- -------------------------
       First    row                12.0 Example of a row that
                                        spans multiple lines.

      Second    row                 5.0 Here's another one. Note
                                        the blank line between
                                        rows.
    -------------------------------------------------------------

    : Here's a multiline table without headers.

It is possible for a multiline table to have just one row, but the row
should be followed by a blank line (and then the row of dashes that ends
the table), or the table may be interpreted as a simple table.

**Grid tables** look like this:

    : Sample grid table.

    +---------------+---------------+--------------------+
    | Fruit         | Price         | Advantages         |
    +===============+===============+====================+
    | Bananas       | $1.34         | - built-in wrapper |
    |               |               | - bright color     |
    +---------------+---------------+--------------------+
    | Oranges       | $2.10         | - cures scurvy     |
    |               |               | - tasty            |
    +---------------+---------------+--------------------+

The row of `=`s separates the header from the table body, and can be
omitted for a headerless table. The cells of grid tables may contain
arbitrary block elements (multiple paragraphs, code blocks, lists,
etc.). Alignments are not supported, nor are cells that span multiple
columns or rows. Grid tables can be created easily using [Emacs table mode].

  [Emacs table mode]: http://table.sourceforge.net/


Title block
-----------

*Docverter extension*.

If the file begins with a title block

    % title
    % author(s) (separated by semicolons)
    % date

it will be parsed as bibliographic information, not regular text.  (It
will be used, for example, in the title of standalone LaTeX or HTML
output.)  The block may contain just a title, a title and an author,
or all three elements. If you want to include an author but no
title, or a title and a date but no author, you need a blank line:

    %
    % Author

    % My title
    %
    % June 15, 2006

The title may occupy multiple lines, but continuation lines must
begin with leading space, thus:

    % My title
      on multiple lines

If a document has multiple authors, the authors may be put on
separate lines with leading space, or separated by semicolons, or
both.  So, all of the following are equivalent:

    % Author One
      Author Two

    % Author One; Author Two

    % Author One;
      Author Two

The date must fit on one line.

All three metadata fields may contain standard inline formatting
(italics, links, footnotes, etc.).

Title blocks will always be parsed, but they will affect the output only
when the `--standalone` (`-s`) option is chosen. In HTML output, titles
will appear twice: once in the document head -- this is the title that
will appear at the top of the window in a browser -- and once at the
beginning of the document body. The title in the document head can have
an optional prefix attached (`--title-prefix` or `-T` option). The title
in the body appears as an H1 element with class "title", so it can be
suppressed or reformatted with CSS. If a title prefix is specified with
`-T` and no title block appears in the document, the title prefix will
be used by itself as the HTML title.

The man page writer extracts a title, man page section number, and
other header and footer information from the title line. The title
is assumed to be the first word on the title line, which may optionally
end with a (single-digit) section number in parentheses. (There should
be no space between the title and the parentheses.)  Anything after
this is assumed to be additional footer and header text. A single pipe
character (`|`) should be used to separate the footer text from the header
text.  Thus,

    % DOCVERTER(1)

will yield a man page with the title `DOCVERTER` and section 1.

    % DOCVERTER(1) Docverter User Manuals

will also have "Docverter User Manuals" in the footer.

    % DOCVERTER(1) Docverter User Manuals | Version 4.0

will also have "Version 4.0" in the header.


Backslash escapes
-----------------

Except inside a code block or inline code, any punctuation or space
character preceded by a backslash will be treated literally, even if it
would normally indicate formatting.  Thus, for example, if one writes

    *\*hello\**

one will get

    <em>*hello*</em>

instead of

    <strong>hello</strong>

This rule is easier to remember than standard markdown's rule,
which allows only the following characters to be backslash-escaped:

    \`*_{}[]()>#+-.!

(However, if the `--strict` option is supplied, the standard
markdown rule will be used.)

A backslash-escaped space is parsed as a nonbreaking space.  It will
appear in TeX output as `~` and in HTML and XML as `\&#160;` or
`\&nbsp;`.

A backslash-escaped newline (i.e. a backslash occurring at the end of
a line) is parsed as a hard line break.  It will appear in TeX output as
`\\` and in HTML as `<br />`.  This is a nice alternative to
markdown's "invisible" way of indicating hard line breaks using
two trailing spaces on a line.

Backslash escapes do not work in verbatim contexts.

Smart punctuation
-----------------

*Docverter extension*.

If the `--smart` option is specified, docverter will produce typographically
correct output, converting straight quotes to curly quotes, `---` to
em-dashes, `--` to en-dashes, and `...` to ellipses. Nonbreaking spaces
are inserted after certain abbreviations, such as "Mr."

Note:  if your LaTeX template uses the `csquotes` package, docverter will
detect automatically this and use `\enquote{...}` for quoted text.

Inline formatting
-----------------

### Emphasis ###

To *emphasize* some text, surround it with `*`s or `_`, like this:

    This text is _emphasized with underscores_, and this
    is *emphasized with asterisks*.

Double `*` or `_` produces **strong emphasis**:

    This is **strong emphasis** and __with underscores__.

A `*` or `_` character surrounded by spaces, or backslash-escaped,
will not trigger emphasis:

    This is * not emphasized *, and \*neither is this\*.

Because `_` is sometimes used inside words and identifiers,
docverter does not interpret a `_` surrounded by alphanumeric
characters as an emphasis marker.  If you want to emphasize
just part of a word, use `*`:

    feas*ible*, not feas*able*.


### Strikeout ###

*Docverter extension*.

To strikeout a section of text with a horizontal line, begin and end it
with `~~`. Thus, for example,

    This ~~is deleted text.~~


### Superscripts and subscripts ###

*Docverter extension*.

Superscripts may be written by surrounding the superscripted text by `^`
characters; subscripts may be written by surrounding the subscripted
text by `~` characters.  Thus, for example,

    H~2~O is a liquid.  2^10^ is 1024.

If the superscripted or subscripted text contains spaces, these spaces
must be escaped with backslashes.  (This is to prevent accidental
superscripting and subscripting through the ordinary use of `~` and `^`.)
Thus, if you want the letter P with 'a cat' in subscripts, use
`P~a\ cat~`, not `P~a cat~`.


### Verbatim ###

To make a short span of text verbatim, put it inside backticks:

    What is the difference between `>>=` and `>>`?

If the verbatim text includes a backtick, use double backticks:

    Here is a literal backtick `` ` ``.

(The spaces after the opening backticks and before the closing
backticks will be ignored.)

The general rule is that a verbatim span starts with a string
of consecutive backticks (optionally followed by a space)
and ends with a string of the same number of backticks (optionally
preceded by a space).

Note that backslash-escapes (and other markdown constructs) do not
work in verbatim contexts:

    This is a backslash followed by an asterisk: `\*`.

Attributes can be attached to verbatim text, just as with
[delimited code blocks](#delimited-code-blocks):

    `<$>`{.haskell}


Raw HTML
--------

Markdown allows you to insert raw HTML (or DocBook) anywhere in a document
(except verbatim contexts, where `<`, `>`, and `&` are interpreted
literally).

The raw HTML is passed through unchanged in HTML, S5, Slidy, Slideous,
DZSlides, EPUB,
Markdown, and Textile output, and suppressed in other formats.

*Docverter extension*.

Standard markdown allows you to include HTML "blocks":  blocks
of HTML between balanced tags that are separated from the surrounding text
with blank lines, and start and end at the left margin.  Within
these blocks, everything is interpreted as HTML, not markdown;
so (for example), `*` does not signify emphasis.

Docverter behaves this way when `--strict` is specified; but by default,
Docverter interprets material between HTML block tags as markdown.
Thus, for example, Docverter will turn

    <table>
    	<tr>
    		<td>*one*</td>
    		<td>[a link](http://google.com)</td>
    	</tr>
    </table>

into

    <table>
    	<tr>
    		<td><em>one</em></td>
    		<td><a href="http://google.com">a link</a></td>
    	</tr>
    </table>

whereas `Markdown.pl` will preserve it as is.

There is one exception to this rule:  text between `<script>` and
`<style>` tags is not interpreted as markdown.

This departure from standard markdown should make it easier to mix
markdown with HTML block elements.  For example, one can surround
a block of markdown text with `<div>` tags without preventing it
from being interpreted as markdown.

Links
-----

Markdown allows links to be specified in several ways.

### Automatic links ###

If you enclose a URL or email address in pointy brackets, it
will become a link:

    <http://google.com>
    <sam@green.eggs.ham>


### Inline links ###

An inline link consists of the link text in square brackets,
followed by the URL in parentheses. (Optionally, the URL can
be followed by a link title, in quotes.)

    This is an [inline link](/url), and here's [one with
    a title](http://fsf.org "click here for a good time!").

There can be no space between the bracketed part and the parenthesized part.
The link text can contain formatting (such as emphasis), but the title cannot.


### Reference links ###

An *explicit* reference link has two parts, the link itself and the link
definition, which may occur elsewhere in the document (either
before or after the link).

The link consists of link text in square brackets, followed by a label in
square brackets. (There can be space between the two.) The link definition
must begin at the left margin or indented no more than three spaces. It
consists of the bracketed label, followed by a colon and a space, followed by
the URL, and optionally (after a space) a link title either in quotes or in
parentheses.

Here are some examples:

    [my label 1]: /foo/bar.html  "My title, optional"
    [my label 2]: /foo
    [my label 3]: http://fsf.org (The free software foundation)
    [my label 4]: /bar#special  'A title in single quotes'

The URL may optionally be surrounded by angle brackets:

    [my label 5]: <http://foo.bar.baz>

The title may go on the next line:

    [my label 3]: http://fsf.org
      "The free software foundation"

Note that link labels are not case sensitive.  So, this will work:

    Here is [my link][FOO]

    [Foo]: /bar/baz

In an *implicit* reference link, the second pair of brackets is
empty, or omitted entirely:

    See [my website][], or [my website].

    [my website]: http://foo.bar.baz

### Internal links

To link to another section of the same document, use the automatically
generated identifier (see [Header identifiers in HTML, LaTeX, and
ConTeXt](#header-identifiers-in-html-latex-and-context), below).
For example:

    See the [Introduction](#introduction).

or

    See the [Introduction].

    [Introduction]: #introduction

Internal links are currently supported for HTML formats (including
HTML slide shows and EPUB), LaTeX, and ConTeXt.

Images
------

A link immediately preceded by a `!` will be treated as an image.
The link text will be used as the image's alt text:

    ![la lune](lalune.jpg "Voyage to the moon")

    ![movie reel]

    [movie reel]: movie.gif

### Pictures with captions ###

*Docverter extension*.

An image occurring by itself in a paragraph will be rendered as
a figure with a caption. (In LaTeX, a figure environment will be
used; in HTML, the image will be placed in a `div` with class
`figure`, together with a caption in a `p` with class `caption`.)
The image's alt text will be used as the caption.

    ![This is the caption](/url/of/image.png)

If you just want a regular inline image, just make sure it is not
the only thing in the paragraph. One way to do this is to insert a
nonbreaking space after the image:

    ![This image won't be a figure](/url/of/image.png)\ 


Footnotes
---------

*Docverter extension*.

Docverter's markdown allows footnotes, using the following syntax:

    Here is a footnote reference,[^1] and another.[^longnote]

    [^1]: Here is the footnote.

    [^longnote]: Here's one with multiple blocks.

        Subsequent paragraphs are indented to show that they 
    belong to the previous footnote.

            { some.code }

        The whole paragraph can be indented, or just the first
        line.  In this way, multi-paragraph footnotes work like
        multi-paragraph list items.

    This paragraph won't be part of the note, because it
    isn't indented.

The identifiers in footnote references may not contain spaces, tabs,
or newlines.  These identifiers are used only to correlate the
footnote reference with the note itself; in the output, footnotes
will be numbered sequentially.

The footnotes themselves need not be placed at the end of the
document.  They may appear anywhere except inside other block elements
(lists, block quotes, tables, etc.).

Inline footnotes are also allowed (though, unlike regular notes,
they cannot contain multiple paragraphs).  The syntax is as follows:

    Here is an inline note.^[Inlines notes are easier to write, since
    you don't have to pick an identifier and move down to type the
    note.]

Inline and regular footnotes may be mixed freely.

PDF Styling
===========

Docverter PDF conversion supports all of CSS 2.1 and some of CSS 3, including
`@font-face` and paged media. Docverter uses Flying Saucer to render HTML
to PDF. See the [user's guide](http://flyingsaucerproject.github.com/flyingsaucer/r8/guide/users-guide-R8.html)
for extensive details. Here are a few useful things.

Fonts
-----

Use a `@font-face` delcaration to include fonts in your stylesheet. Any fonts should be
included in `other_files[]` as truetype font files. For example:

    @font-face {
      font-family: 'Arial';
      font-style: normal;
      font-weight: 400;
      src: url('arial.ttf');
      -fs-pdf-font-embed: embed;
      -fs-pdf-font-encoding: Identity-H;
    }
    body {
      font-family: 'Arial';
    }
    
**VERY IMPORTANT NOTE** You *must* include the `-fs-pdf-font-embed` and `-fs-pdf-font-encoding` attributes, and they must be the exact values as above. In addition, the font-family *must* be identical to the font family that is encoded in the font file itself.    

Page Attributes
---------------

See the W3C's [Paged Media](http://www.w3.org/TR/css3-page/) for details. A small example:

    @page {
      size: 8.5in 11in;
      margin: 27mm;
    }

Headers and Footers
-------------------

See the W3C's [Paged Media](http://www.w3.org/TR/css3-page/) for details. A small example:

    h1 {
      string-set: header content();
    }

    @page {
      @bottom-right {
        content: string(header, first); 
      }

      @bottom-left {
        content: counter(page)
      }
    }

This copies the contents of each `<h1>` into a string named `header`. Then, it inserts it into
the bottom right corner of each page. It also inserts a page counter into the bottom left corner
of each page.

Docverter supports both margin boxes, described above, and running elements as defined by the CSS3 spec.


Authors
=======

This is a copy of the Pandoc README file, modified to suit Docverter's manifest format.

Docverter © 2012 Pete Keen (pete@bugsplat.info) and released under the MIT license (see LICENSE)

Original © 2006-2011 John MacFarlane (jgm at berkeley dot edu). Pandoc
released under the [GPL], version 2 or greater.  This software carries no warranty of
any kind. 

Other contributors include Recai Oktaş, Paulo Tanimoto, Peter Wang,
Andrea Rossato, Eric Kow, infinity0x, Luke Plant, shreevatsa.public,
Puneeth Chaganti, Paul Rivier, rodja.trappe, Bradley Kuhn, thsutton,
Nathan Gass, Jonathan Daugherty, Jérémy Bobbio, Justin Bogner, qerub,
Christopher Sawicki, Kelsey Hightower, Masayoshi Takahashi, Antoine
Latter, Ralf Stephan, Eric Seidel, B. Scott Michel, Gavin Beatty,
Sergey Astanin.

[markdown]: http://daringfireball.net/projects/markdown/
[reStructuredText]: http://docutils.sourceforge.net/docs/ref/rst/introduction.html
[S5]: http://meyerweb.com/eric/tools/s5/
[Slidy]: http://www.w3.org/Talks/Tools/Slidy/
[Slideous]: http://goessner.net/articles/slideous/
[HTML]:  http://www.w3.org/TR/html40/
[HTML 5]:  http://www.w3.org/TR/html5/
[XHTML]:  http://www.w3.org/TR/xhtml1/
[LaTeX]: http://www.latex-project.org/
[beamer]: http://www.tex.ac.uk/CTAN/macros/latex/contrib/beamer
[ConTeXt]: http://www.pragma-ade.nl/ 
[RTF]:  http://en.wikipedia.org/wiki/Rich_Text_Format
[DocBook XML]:  http://www.docbook.org/
[OpenDocument XML]: http://opendocument.xml.org/ 
[ODT]: http://en.wikipedia.org/wiki/OpenDocument
[Textile]: http://redcloth.org/textile
[MediaWiki markup]: http://www.mediawiki.org/wiki/Help:Formatting
[groff man]: http://developer.apple.com/DOCUMENTATION/Darwin/Reference/ManPages/man7/groff_man.7.html
[Haskell]:  http://www.haskell.org/
[GNU Texinfo]: http://www.gnu.org/software/texinfo/
[Emacs Org-Mode]: http://orgmode.org
[AsciiDoc]: http://www.methods.co.nz/asciidoc/
[EPUB]: http://www.idpf.org/
[GPL]: http://www.gnu.org/copyleft/gpl.html "GNU General Public License"
[DZSlides]: http://paulrouget.com/dzslides/
[ISO 8601 format]: http://www.w3.org/TR/NOTE-datetime
[Word docx]: http://www.microsoft.com/interop/openup/openxml/default.aspx
[PDF]: http://www.adobe.com/pdf/
