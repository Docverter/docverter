require 'sinatra/base'
require 'fileutils'

class DocverterServer::App < Sinatra::Base

  set :show_exceptions, false
  set :dump_errors, false
  set :raise_errors, true

  post '/convert' do

    dir = Dir.mktmpdir

    Dir.chdir(dir) do
      manifest = DocverterServer::Manifest.new

      input_files = params.delete('input_files') || []
      other_files = params.delete('other_files') || []

      input_files.each do |upload|
        FileUtils.cp upload[:tempfile].path, upload[:filename]
        manifest['input_files'] << upload[:filename]
      end

      other_files.each do |upload|
        FileUtils.cp upload[:tempfile].path, upload[:filename]
      end

      params.each do |key,val|
        next if key == 'controller' || key == 'action'
        key = key.gsub("'", '') if key.is_a?(String)
        val = val.gsub("'", '') if val.is_a?(String)

        manifest[key] = val
      end

      manifest.write('manifest.yml')

      output_file = DocverterServer::Conversion.new(dir).run

      content_type(DocverterServer::ConversionTypes.mime_type(manifest['to']))

      num_tries = 0
      max_retries = 10
      @output = nil

      while num_tries < max_retries
        begin
          File.open(output_file) do |f|
            @output = f.read
          end
          break
        rescue
          puts "Failed to open #{output_file}; num_tries = #{num_tries}"
          sleep 0.020
        end
        num_tries += 1
      end

      @output
    end

  end

  get '/' do
    'hi'
  end
end
