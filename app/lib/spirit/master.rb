require_relative 'plist_model'

module Spirit

  class Master < PlistModel

    class << self

      def all_dict(keyword=nil)
          master_list = {}

          if keyword.nil?
            %w{DEV FAT HFS NTFS PC}.each do |fs|
              master_list.merge!(self.all_dict(fs))
            end

            master_list
          else
            masters_dir = Dir.new(File.join(@path, keyword))
            masters_dir.each do |entry|
              next if entry =~ /^\./

              master_path = File.join(@path, keyword, entry)
              stats = File.stat(master_path)
              name_parts = entry.split '.'

              # TODO: verify actual list of valid architectures
              architecture = %w{i386}.include? name_parts[-2] ? name_parts[-2] : 'PC'

              master_list[entry] = {
                  'architecture' => architecture,
                  'creationdate' => stats.ctime, # Format as ISO
                  'filesystem' => keyword,
                  'modificationdate' => stats.mtime, # Format as ISO
                  'name' => entry,
                  'path' => master_path,
                  'size' => stats.size/1024000 # Bytes to Mb
              }
            end

            master_list
          end
      end

    end

  end

end