require 'multi_json'

module DocverterServer
  class ErrorHandler
    def initialize(app)
      @app = app
    end

    def call(env)
      begin
        @app.call env
      rescue => ex
        env['rack.errors'].puts ex
        env['rack.errors'].puts ex.backtrace.join("\n")
        env['rack.errors'].flush

        hash = { :error => ex.to_s }

        [500, {'Content-Type' => 'application/json'}, [MultiJson.dump(hash)]]
      end
    end
  end
end
