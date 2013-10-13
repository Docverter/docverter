require 'yaml'

class DocverterServer::Manifest

  def pdf
    @pdf
  end

  def pdf_page_size
    @pdf_page_size
  end

  def self.load_file(filename)
    File.open(filename) do |f|
      self.load_stream(f)
    end
  end

  def self.load_stream(stream)
    self.new(YAML.load(stream))
  end
  
  def initialize(options={})
    @options = options
    @options['input_files'] ||= []
  end

  def [](key)
    @options[key]
  end

  def []=(key, val)
    @options[key] = val
  end

  def write(filename)
    File.open(filename, "w+") do |f|
      write_to_stream(f)
    end
  end

  def write_to_stream(stream)
    stream.write YAML.dump(@options)
  end

  def test_mode?
    @test_mode
  end

  def command_options
    options = @options.dup
    input_files = options.delete('input_files')
    raise "No input files provided!" unless input_files.length > 0

    @pdf_page_size = options.delete('pdf_page_size')

    if options['to'] == 'pdf'
      _ = options.delete 'to'
      @pdf = true
    end

    command_options = []

    @test_mode = options.delete('test_mode')

    options.each do |k,v|

      raise InvalidManifestError.new("Invalid option: #{k}") unless k.match(/^[a-z0-9-]+/)
      
      option_key = k.to_s.gsub('_', '-')
      [v].flatten.each do |option_val|
        raise InvalidManifestError.new("Invalid option value: #{option_val}") unless option_val.to_s.match(/^[a-zA-Z0-9._-]+/)
        if option_val.is_a?(TrueClass)
          command_options << "--#{option_key}"
        else
          command_options << "--#{option_key}=#{option_val}"
        end
      end
    end

    command_options += [input_files].flatten.compact

    command_options
  end

  def validate!(dir)
    raise InvalidManifestError.new("No input files found") unless @options['input_files'] && @options['input_files'].length > 0

    Dir.chdir(dir) do
      @options['input_files'].each do |filename|
        raise InvalidManifestError.new("Invalid input file: #{filename} not found") unless File.exists?(filename)
        raise InvalidManifestError.new("Invalid input file: #{filename} cannot start with /") if filename.strip[0] == '/'
      end

      raise InvalidManifestError.new("'from' key required") unless @options['from']
      raise InvalidManifestError.new("'to' key required") unless @options['to']

      raise InvalidManifestError.new("Not a valid 'from' type") unless
        DocverterServer::ConversionTypes.valid_input?(@options['from'])

      raise InvalidManifestError.new("Not a valid 'to' type") unless
        DocverterServer::ConversionTypes.valid_output?(@options['to'])
    end
  end
end
