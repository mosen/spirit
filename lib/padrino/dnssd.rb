# This is a module to register the Padrino application as a DNSSD/Bonjour service.

module Padrino
  module DNSSD
    class << self
      def registered?(app)

      end
    end
  end
end