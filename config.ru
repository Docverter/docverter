require 'docverter-server'

use DocverterServer::ErrorHandler
run DocverterServer::App.new
