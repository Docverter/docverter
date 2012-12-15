class DocverterServer::Conversion < DocverterServer::Runner::Base

  def run
    with_manifest do |manifest|
      manifest.validate!(directory)

      if manifest['to'] == 'pdf'
        manifest['to'] = 'html'

        manifest.write('manifest.yml')

        if manifest['from'] != 'html'
          @html_filename = DocverterServer::Runner::Pandoc.new(directory).run
        else
          @html_filename = manifest['input_files'][0]
        end
        @output_filename = DocverterServer::Runner::PDF.new(directory, @html_filename).run
      elsif manifest['to'] == 'mobi'
        manifest['to'] = 'epub'
        manifest.write('manifest.yml')
        epub = DocverterServer::Runner::Pandoc.new('.').run
        @output_filename = DocverterServer::Runner::Calibre.new(directory, epub).run
      else
        @output_filename = DocverterServer::Runner::Pandoc.new(directory).run
      end
      @output_filename
    end
  end

  def output_mime_type
    DocverterServer::ConversionTypes.mime_type(@manifest.pdf ? 'pdf' : @manifest['to'])
  end
  
  def output_extension
    DocverterServer::ConversionTypes.extension(@manifest.pdf ? 'pdf' : @manifest['to'])
  end

end
