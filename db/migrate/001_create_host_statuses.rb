migration 1, :create_host_statuses do
  up do
    create_table :host_statuses do
      column :id, Integer, :serial => true
      column :serial, DataMapper::Property::String, :length => 255
      column :IPv4, DataMapper::Property::String, :length => 16
      column :MACAddress, DataMapper::Property::String, :length => 17
      column :diskImageConversion, DataMapper::Property::Boolean
      column :hostname, DataMapper::Property::String, :length => 255
      column :identifier, DataMapper::Property::String, :length => 255
      column :multicastStream, DataMapper::Property::Boolean
      column :online, DataMapper::Property::Boolean
      column :dialogDescription, DataMapper::Property::String, :length => 255
    end
  end

  down do
    drop_table :host_statuses
  end
end
