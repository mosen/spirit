class HostStatuses
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :serial, String
  property :IPv4, String
  property :MACAddress, String
  property :diskImageConversion, Bool
  property :hostname, String
  property :identifier, String
  property :multicastStream, Bool
  property :online, Bool
  property :dialogDescription, String
end
