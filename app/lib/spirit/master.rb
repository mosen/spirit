require_relative 'plist_model'

module Spirit

  class Master < PlistModel

    class << self

      # keyword parameter is a string which indicates the filesystem type to return eg. "HFS", "NTFS"
      def all_dict(keyword=nil)
        if keyword.nil?
          %w{DEV FAT HFS NTFS PC}.inject({}) do |result, fs|
            result.merge(self.all_dict(fs))
          end
        else
          masters_dir = Dir.new(File.join(@path, keyword))
          masters = {}  # Dont build with inject because FakeFS doesnt monkey patch Dir enumerable

          masters_dir.each do |entry|
            next if entry =~ /^\./

            master_path = File.join(@path, keyword, entry)
            stats = File.stat(master_path)
            name_parts = entry.split '.'

            # Ignore files that dont match the filesystem naming i.e hfs.dmg or ntfs.dmg
            next unless %w{hfs ntfs}.include? name_parts[-2]

            # TODO: verify actual list of valid architectures
            if name_parts[-2] == 'i386'
              architecture = 'i386'
            else
              architecture = 'PC'
            end

            masters[entry] = {
                'architecture' => architecture,
                'creationdate' => stats.ctime, # Format as ISO
                'filesystem' => keyword,
                'modificationdate' => stats.mtime, # Format as ISO
                'name' => entry,
                'path' => master_path,
                'size' => (stats.size/1024000).round(1).to_s # Bytes to Mb
            }
          end

          masters
        end
      end

    end

  end

end