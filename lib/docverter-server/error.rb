module DocverterServer
  class InvalidManifestError < RuntimeError
    def to_s
      "invalid manifest: #{super}"
    end
  end

  class CommandError < RuntimeError
    def to_s
      "command error: #{super}"
    end
  end
end
