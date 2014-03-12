class CreateHostStatuses < ActiveRecord::Migration
  def self.up
    create_table :host_statuses do |t|
      t.column :IPv4, :string, :limit => 16
      t.column :MACAddress, :string, :limit => 17
      t.column :diskImageConversion, :boolean
      t.column :hostname, :string
      t.column :identifier, :string # primary key, usually serial
      t.column :multicastStream, :boolean
      t.column :online, :boolean
      t.column :dialogDescription, :string
    end
  end

  def self.down
    drop_table :host_statuses
  end
end
