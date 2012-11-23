class DocverterServer::Runner::Calibre < DocverterServer::Runner::Base
  def run
    with_manifest do
      output = generate_output_filename('mobi')
      options = ["ebook-convert", input_filename, output]
      run_command(options)
      output
    end
  end
end
