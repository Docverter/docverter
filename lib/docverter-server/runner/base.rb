module DocverterServer
  module Runner
    class Base
      attr_reader :directory, :input_filename, :options
    
      def initialize(directory, input_filename=nil, options={})
        @directory = directory
        @input_filename = input_filename
        @options = options
      end
    
      def run
        raise "implement in subclass"
      end
    
      def generate_output_filename(extension)
        "output.#{SecureRandom.hex(10)}.#{extension}"
      end
      
      def run_command(options)
        output = IO.popen(options) do |f|
          f.read
        end
        if $?.exitstatus != 0
          raise output
        end
      end
    
      def with_manifest
        Dir.chdir(directory) do
          yield DocverterServer::Manifest.load_file("manifest.yml")
        end
      end
    end
  end
end
