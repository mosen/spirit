module Spirit

  class FileModel

    class << self
      attr_accessor :path # Directory root for file operations

      # Get all directory entries
      def all(subdir=nil)
        scan_path = subdir.nil? ? @path : File.join(@path, subdir)

        Dir.entries(scan_path).reject do |filename|
          filename =~ /^\./ # Just hidden files
        end
      end

      # Delete the file represented by this model
      def delete(file_model)
        File.unlink(file_model.path)
      end
    end

    attr_accessor :name

    # Fully qualified path including extension
    attr_accessor :path

    # TODO: refactor out file extension, subclass constructor can append to path
    attr_accessor :ext

    def initialize(name)
      @name = name
      @ext = ''
      @path = File.join(self.class.path, name)
    end

    # Get absolute path
    def path
      @path
    end

    # Get contents
    def contents
      if File.exists? @path
        File.new(@path, File::RDONLY).read
      else
        nil
      end
    end

    # Set contents (automatically overwriting original)
    def contents=(contents)
      File.open(@path, File::WRONLY|File::CREAT) do |f|
        f.write(contents)
      end
    end

    # Rename to new filename
    def rename!(name)
      File.rename(@path, File.join(self.class.path, name+@ext))
      @name = name
      @path = File.join(self.class.path, name+@ext)
    end

    # Does the file exist?
    def exists?
      File.exists? @path
    end

  end

end