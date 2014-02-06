class HostStatuses
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :serial, String
  property :IPv4, String
  property :MACAddress, String
  property :diskImageConversion, Boolean
  property :hostname, String
  property :identifier, String
  property :multicastStream, Boolean
  property :online, Boolean
  property :dialogDescription, String
end
