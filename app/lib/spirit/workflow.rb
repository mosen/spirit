require 'cfpropertylist'
require_relative 'plist_model'

module Spirit

  class Workflow < PlistModel

    class << self
      attr_accessor :path

      # Get a dictionary containing all workflows keyed by filename
      def all_dict
        workflow_dir = Dir.new @path
        workflows = {}

        files = workflow_dir.entries.select do |entry|
          entry =~ /\.plist$/
        end

        files.each do |filename|
          begin
            plist = CFPropertyList::List.new(:file => File.join(@path, filename))
            workflows[filename] = CFPropertyList.native_types(plist.value)
          rescue NoMethodError
            next
          rescue CFFormatError
            logger.error "Failed to parse property list at path: #{filename}"
          rescue IOError
            logger.error "Failed to open property list at path: #{filename}"
          end
        end

        workflows
      end

      # Get a single workflow
      def find(uuid)
        file_path = File.join(@path, uuid+'.plist')

        File.new(file_path).read
      end

      # Create or replace a workflow
      def replace(uuid, content)
        file_path = File.join(@path, uuid+'.plist')

        File.open(file_path, File::WRONLY|File::CREAT) { |f|
          f.write(content)
        }
      end

      # Delete a workflow
      def delete(uuid)
        file_path = File.join(@path, uuid+'.plist')

        File.unlink(file_path)
      end
    end

  end

end