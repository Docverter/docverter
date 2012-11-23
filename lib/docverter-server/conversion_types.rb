class DocverterServer::ConversionTypes

  TYPES = [
    # file extension, pandoc name, visible name, mime type, input, output
    ['asciidoc', 'asciidoc', 'AsciiDoc', 'application/octet-stream', false, true],
    ['docx', 'docx', 'Docx', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', false, true],
    ['doc', 'doc', 'Doc', 'application/msword', true, false],
    ['epub', 'epub', 'ePub', 'application/epub+zip',  false, true],
    ['groff', 'groff', 'Groff', 'application/x-troff', false, true],
    ['html', 'html', 'HTML', 'text/html', true, true],
    ['md', 'markdown', 'Markdown', 'application/octet-stream', true, true],
    ['org', 'orgmode', 'Emacs Org-Mode', 'application/octet-stream', false, true],
    ['mobi', 'mobi', 'Mobi', 'application/octet-stream', false, true],
    ['pdf', 'pdf', 'PDF', 'application/pdf', false, true],
    ['rtf', 'rtf', 'RTF', 'text/rtf', false, true],
    ['rst', 'rst', 'reStructured Text', 'application/octet-stream', true, true],
    ['tex', 'context', 'ConTeXt', 'application/octet-stream', false, true],
    ['tex', 'latex', 'LaTeX', 'application/octet-stream', true, true],
    ['texi', 'texinfo', 'TexInfo', 'application/octet-stream', false, true],
    ['textile', 'textile', 'Textile', 'application/octet-stream', true, true],
    ['wiki', 'mediawiki', 'MediaWiki', 'application/octet-stream', false, true],
    ['xml', 'docbook', 'DocBook', 'application/docbook+xml', false, true],
  ]

  def self.extension(pandoc_name)
    for_pandoc(pandoc_name)[0]
  end

  def self.mime_type(pandoc_name)
    for_pandoc(pandoc_name)[3]
  end

  def self.for_pandoc(pandoc_name)
    TYPES.find { |t| t[1].downcase == pandoc_name.downcase }
  end

  def self.for_extension(extension)
    TYPES.find { |t| t[0].downcase == extension.downcase }
  end

  def self.inputs
    TYPES.find_all { |t| t[4] == true }
  end

  def self.outputs
    TYPES.find_all { |t| t[5] == true }
  end

  def self.valid_input?(input)
    type = for_pandoc(input)
    return type && type[4]
  end

  def self.valid_output?(output)
    type = for_pandoc(output)
    return type && type[5]
  end

end
