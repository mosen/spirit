require_relative 'file_model'
require 'cfpropertylist'

module Spirit

  class Master < FileModel

    class << self

      # Scan a masters directory for valid images, get a hash of image information for each
      def scan(filesystem)
        masters_dir = Dir.new(File.join(@path, filesystem))
        masters = {}  # Dont build with inject because FakeFS doesnt monkey patch Dir enumerable

        masters_dir.each do |entry|
          next if entry =~ /^\./

          master_path = File.join(@path, filesystem, entry)
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
              'filesystem' => filesystem,
              'modificationdate' => stats.mtime, # Format as ISO
              'name' => entry,
              'path' => master_path,
              'size' => (stats.size/1024000).round(1).to_s # Bytes to Mb
          }
        end

        masters
      end

      # Rebuild the keywords.plist in the masters directory.
      # This is used instead of our own database index to keep compatibility with DS.
      def rebuild_keywords()
        keywords = %w{DEV FAT HFS NTFS PC}.inject({}) do |result, fs|
          next result unless Dir.exists? File.join(@path, fs)
          result.merge(self.scan(fs))
        end

        keywords_plist = keywords.to_plist

        File.open(File.join(@path, 'keywords.plist'), 'wb') do |fd|
          fd.write(keywords_plist)
        end

        keywords
      end

      # keyword parameter can be a substring to match against the filename or the keywords list.
      def all_dict(keywords=nil)
        all_masters = rebuild_keywords

        return all_masters if keywords.nil?

        results = all_masters.keep_if do |key, value|
          next true if key.upcase.index(keywords.upcase)
          next true if value.include?('keywords') and value['keywords'].upcase.index(keywords.upcase)
          false
        end

        results
      end
    end

    def initialize(name)
      @name = name
      @ext = ''

      %w{HFS NTFS FAT DEV}.each do |fs|
        if File.exists?(File.join(self.class.path, fs, name))
          @path = File.join(self.class.path, fs, name)
        end
      end
    end

    # Set keywords associated with this master
    def keywords=(keywords)
      plist = CFPropertyList::List.new(:data => File.read(File.join(self.class.path, 'keywords.plist')))
      if plist.include? @name
        plist[@name]['keywords'] = keywords
        plist.save(File.join(self.class.path, 'keywords.plist'))
        plist
      else
        raise Exception('No keyword matches the master image requested')
      end
    end

  end

end