require_relative 'plist_model'

module Spirit

  class Computer < PlistModel

    class << self

      attr_accessor :groups_plist # Path to the group settings plist
      attr_accessor :template # Template for new computers
      attr_accessor :primary_key # DeployStudio Primary key (serial or eth id)

      def all
        computers = { 'groups' => {}, 'computers' => {} }

        Dir.entries(@path).each do |entry|
          next unless entry =~ /\.plist$/
          next if entry == 'group.settings.plist'

          full_path = File.join(@path, entry)

          begin
            computer = CFPropertyList::List.new(:file => full_path)
            computer_hash = CFPropertyList.native_types(computer.value)
            computers['computers'][computer_hash[@primary_key]] = computer_hash
          rescue Exception => e
            logger.debug e.message
            next
          end
        end


        groups_plist = CFPropertyList::List.new(:file => File.join(@path, 'group.settings.plist'))
        computers['groups'] = CFPropertyList.native_types(groups_plist.value)

        computers
      end

      def create(serial, eth_id, inherit_values = nil)

        computer_count = 0 # TODO: store sequence in db, this is temporary
        # TODO: DS Admin dictates sequence number precision via these properties:
        #   <key>dstudio-group-hosname-index-first-value</key>
        #<integer>1</integer>
        #   <key>dstudio-group-hosname-index-length</key>
        #<integer>2</integer>

        # Key values copied verbatim (no processing reqd)
        inherited_keys = %w(dstudio-auto-disable dstudio-auto-reset-workflow
          dstudio-bootcamp-windows-product-key dstudio-clientmanagement-computer-groups dstudio-custom-properties
          dstudio-disabled dstudio-host-ard-ignore-empty-fields dstudio-host-delete-other-locations
          dstudio-host-first-interface dstudio-host-interfaces dstudio-host-location dstudio-host-new-network-location
          dstudio-serial-number dstudio-users dstudio-xsan-license)

        # Inherit from group properties passed into this method
        unless inherit_values.nil?
          props = {
            'architecture' => 'i386', # TODO: Test to ensure that this IS the default
            'cn' => inherit_values['cn'] + (computer_count+1).to_s,
            'dstudio-group' => inherit_values['dstudio-group-name'],
            'dstudio-host-primary-key' => @primary_key,
            'dstudio-hostname' => inherit_values['dstudio-hostname'] + (computer_count+1).to_s,
            'dstudio-mac-addr' => eth_id,
            'dstudio-host-serial-number' => serial,
            'dstudio-host-ard-ignore-empty-fields' => 'NO' # Cannot be inherited
          }

          if inherit_values.has_key?('dstudio-bootcamp-windows-computer-name')
            props['dstudio-bootcamp-windows-computer-name'] = inherit_values['dstudio-bootcamp-windows-computer-name'] + (computer_count+1).to_s
          end

          inherit_whitelist = inherit_values.keep_if { |k, v| inherited_keys.include?(k) }

          props.merge! inherit_whitelist
        else
          # TODO: test DS populate response when there is no group at all.
          # This data does not currently conform to DS response with an empty default group
          props = {
              'cn' => '', # Computer ID, generated dynamically
              'dstudio-auto-disable' => 'NO', # (?) Disable auto start
              'dstudio-auto-reset-workflow' => 'NO', # (?
              'dstudio-bootcamp-windows-computer-name' => '3', # prefix would be added to this
              'dstudio-disabled' => 'NO', # (?)
              'dstudio-group' => 'Default',
              'dstudio-host-new-network-location' => 'NO', # (?) depends on group config
              'dstudio-host-primary-key' => '',
              'dstudio-host-serial-number' => '',
              'dstudio-hostname' => '', # Group prefix + ID
              'dstudio-users' => [],
              'dstudio-host-ard-ignore-empty-fields' => 'NO' # Cannot be inherited
          }
        end

        props
      end

    end

    attr_accessor :primary_key
    attr_accessor :id

    def initialize(primary_key, id)
      super(id)

      @primary_key = primary_key # "sn" or "mac"
      @id = id
    end

  end

end