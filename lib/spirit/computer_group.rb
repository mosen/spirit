require 'cfpropertylist'

module Spirit

  class ComputerGroup

    class << self

      attr_accessor :groups_plist # Path to group settings plist

      def all
        plist = CFPropertyList::List.new(:file => @groups_plist)
        groups = CFPropertyList.native_types(plist.value)

        groups
      end

      def default
        plist = CFPropertyList::List.new(:file => @groups_plist)
        groups = CFPropertyList.native_types(plist.value)

        groups['_dss_default']['dstudio-group-default-group-name']
      end

      def create
        groups = self.all

        x = 1
        while groups.key?("Group %d" % x) do
          x = x.next
        end

        groups[("Group %d" % x)] = {
            'dstudio-group-name' => "Group %d" % x
        }

        plist = CFPropertyList::List.new
        plist.value = CFPropertyList.guess(groups, convert_unknown_to_string: true)
        plist.save(self.groups_plist, CFPropertyList::List::FORMAT_XML)
      end

      def delete(name)
        groups = self.all
        groups.delete name

        plist = CFPropertyList::List.new
        plist.value = CFPropertyList.guess(groups, convert_unknown_to_string: true)
        plist.save(self.groups_plist, CFPropertyList::List::FORMAT_XML)
      end

      def rename(from, to)
        groups = self.all
        to_rename = groups.delete from
        to_rename['dstudio-group-name'] = to
        groups[to] = to_rename

        plist = CFPropertyList::List.new
        plist.value = CFPropertyList.guess(groups, convert_unknown_to_string: true)
        plist.save(self.groups_plist, CFPropertyList::List::FORMAT_XML)
      end

    end

    attr_accessor :id

    def initialize(id)
      @id = id
    end

    def contents
      self.class.all[@id]
    end

    def contents=(contents)
      groups = self.class.all
      groups[@id] = contents

      plist = CFPropertyList::List.new
      plist.value = CFPropertyList.guess(groups, convert_unknown_to_string: true)
      plist.save(self.class.groups_plist, CFPropertyList::List::FORMAT_XML)
    end

  end

end