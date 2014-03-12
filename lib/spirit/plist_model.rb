require_relative 'file_model'

module Spirit

  # Plist model extends file model by providing hash data about files, or parsing a plist related to the file
  class PlistModel < FileModel

    def initialize(name)
      @name = name
      @ext = '.plist'
      @path = File.join(self.class.path, name+@ext)
    end

    def to_hash

      #plist = CFPropertyList::List.new(:file => @path)
      plist = CFPropertyList::List.new(:data => File.read(@path)) # Changed to make testable
      CFPropertyList.native_types(plist.value)
    end

  end

end