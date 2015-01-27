require 'spec_helper'
require 'shared_examples_http'

# It is probable that asr multicasting will never be supported in spirit.
describe '/multicast' do

  # Start multicasting?
  # Returns plist with following values:
  # multicast_url - asr://192.168.x.x:7800
  # disk_image - (name of disk image, no path or subdir)
  describe '/join' do

  end

  # Executed directly after join, returns empty plist, 200 on success
  describe '/release' do

  end

  describe '/status' do

  end


  # GET /multicast/stop?disk_image=osx-10.9-13A603.hfs.dmg HTTP/1.1
  # Stop multicasting an image
  # Returns an empty plist, Status 200 on success
  describe '/stop' do

  end



end
