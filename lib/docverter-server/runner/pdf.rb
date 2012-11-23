include Java

require 'flying_saucer'
require File.expand_path('../../jars/htmlcleaner-2.2.jar', __FILE__)
require File.expand_path('../../jars/bcprov-ext-jdk15-1.43.jar', __FILE__)

java_import org.xhtmlrenderer.pdf.ITextRenderer
java_import org.xhtmlrenderer.pdf.ITextUserAgent
java_import org.htmlcleaner.HtmlCleaner
java_import org.htmlcleaner.DomSerializer
java_import com.lowagie.text.pdf.PdfReader
java_import com.lowagie.text.pdf.PdfStamper
java_import com.lowagie.text.pdf.PdfEncryption

class DocverterServer::Runner::PDF < DocverterServer::Runner::Base

  def create_java_dom(html)
    cleaner = HtmlCleaner.new
    props = cleaner.get_properties
    props.setTranslateSpecialEntities(true)
    props.setAdvancedXmlEscape(true)
    props.setRecognizeUnicodeChars(true)
    node = cleaner.clean(html)
    DomSerializer.new(props, true).createDOM(node)
  end

  def build_renderer(dom)
    renderer = ITextRenderer.new
    agent = UserAgent.new(renderer.output_device)
    agent.shared_context = renderer.shared_context
    renderer.shared_context.user_agent_callback = agent
    renderer.set_document(dom, path_to_url(directory))
    renderer.layout
    renderer
  end

  def path_to_url(path)
    java.io.File.new(path).to_uri.to_url.to_string
  end

  def run
    with_manifest do |manifest|

      io = StringIO.new
      dom = create_java_dom(File.open(input_filename).read)

      renderer = build_renderer(dom)
      renderer.create_pdf(io.to_outputstream)

      if manifest['pdf_username'] && manifest['pdf_password']
        io = encrypt_pdf(io, manifest)
      end

      @output = generate_output_filename('pdf')
      File.open(@output, "w+") do |f|
        f.write(io.string)
      end
    end
    @output
  end

  def encrypt_pdf(io, manifest)
    temp = Tempfile.new('temp')
    temp.write io.string
    temp.flush
    temp.rewind
    out = StringIO.new
    reader = PdfReader.new(temp.to_inputstream)
    stamper = PdfStamper.new(reader, out.to_outputstream)
    stamper.setEncryption(PdfEncryption::STANDARD_ENCRYPTION_40, manifest['pdf_username'], manifest['pdf_password'], 1)
    stamper.close
    out
  end

  class UserAgent < org.xhtmlrenderer.pdf.ITextUserAgent

    def initialize(output_device)
      super
    end

    def resolveURI(uri)
      if uri =~ /^\//
        super(uri[1..uri.length])
      else
        super(uri)
      end
    end
    alias :resolve_uri :resolveURI
  end

end
