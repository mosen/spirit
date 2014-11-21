require_relative 'file_model'

module Spirit

  # Plist model extends file model by providing hash data about files, or parsing a plist related to the file
  # As of 1.6.12.1, Re-encodes the response as a binary plist, even if we are storing the plist in XML format.
  class PlistModel < FileModel

    def initialize(name)
      @name = name
      @ext = '.plist'
      @path = File.join(self.class.path, name+@ext)
    end

    def to_hash
      # Don't use List.new with :path parameter, it is not testable.
      plist = CFPropertyList::List.new(:data => File.read(@path))
      CFPropertyList.native_types(plist.value)
    end

    # Override contents method to return binary encoding
    def contents
      if File.exists? @path
        plist = CFPropertyList::List.new(:data => File.read(@path))
        plist.to_str
      else
        plist = CFPropertyList::List.new(:data => Hash.new())
        plist.to_str
      end
    end

  end

end