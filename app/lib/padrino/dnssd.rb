# This is a module to register the Padrino application as a DNSSD/Bonjour service.
require 'dnssd'

module Padrino
  module DNSSD
    def self.registered(app)
      app.set :dnssd_enabled, false
      app.set :dnssd_hostname, 'spirit.local'


    end
  end
end