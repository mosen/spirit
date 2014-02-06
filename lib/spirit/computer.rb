require_relative 'plist_model'

module Spirit

  class Computer < PlistModel

    class << self

      attr_accessor :groups_plist # Path to the group settings plist
      attr_accessor :template # Template for new computers
      attr_accessor :primary_key # DeployStudio Primary key (serial or eth id)

      @template = {
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
        'dstudio-users' => []
      }

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

      def create(serial, eth_id)

      end

    end


    def groups

    end

  end

end