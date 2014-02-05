module Spirit

  class Package

    class << self
      attr_accessor :path

      # Get all packages in the root or given subdir
      def all_dict(subdir='')
        packages_dir = Dir.new(File.join(@path, subdir))
        package_list = {}

        packages_dir.each do |entry|
          full_path = File.join(packages_dir.path, entry)

          next if entry =~ /^\./

          package_list[entry] = {
              'name' => entry,
              'path' => full_path
          }

          if File.directory? full_path
            children = Dir.entries(full_path).reject do |name|
              name[0] == '.'
            end

            stats = File.lstat(full_path)

            package_list[entry]['items'] = children.count
            package_list[entry]['size'] = stats.size
          end
        end

        package_list
      end

      # Get all package sets (basically just directories)
      def sets
        packages_dir = Dir.new(@path)

        sets = {}

        packages_dir.each do |entry|
          full_path = File.join(@path, entry)

          next if entry =~ /^\./
          next unless File.directory? full_path

          children = Dir.entries(full_path).reject do |name|
            name[0] == '.'
          end

          stats = File.lstat(full_path)

          sets[entry] = {
              'items' => children.count,
              'name' => entry,
              'path' => File.join(@path, entry),
              'size' => stats.size
          }
        end

        sets
      end

      # Delete a package (optionally from inside a set)
      def delete(package, set=nil)
        package_path = @path.to_s
        package_path << set unless set.nil?
        package_path << package

        File.unlink(File.join(*package_path))
      end

      # Create a new blank package set
      def create_set
        x = 1
        while Dir.exists?(File.join(@path, "Packages Set %d" % x)) do
          x = x.next
        end

        package_set = File.join(@path, "Packages Set %d" % x)
        Dir.mkdir(package_set)
      end

      # Rename a package set (usually a directory)
      def rename_set(from, to)
        original_name = File.join(@path, from)
        new_name = File.join(@path, to)

        File.rename(original_name, new_name)
      end
    end

  end
end