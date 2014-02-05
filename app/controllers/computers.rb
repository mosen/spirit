# Computers
#
# Combines retrieval and storage of information about computers that have contacted the service,
# Group information, and Current computer activity.
#
# GET:
#
#- /computers/get/all
#- /computers/get/entry
#- /computers/groups/get/all
#- /computers/groups/get/default
#- /computers/groups/get/entry
#- /computers/status/get/all
#
# POST:
#
#- /computers/del/entries
#- /computers/del/entry
#- /computers/groups/del/default
#- /computers/groups/del/entry
#- /computers/groups/new/entry
#- /computers/groups/ren/entry
#- /computers/groups/set/default
#- /computers/groups/set/entry
#- /computers/import/entries
#- /computers/set/entry
#- /computers/status/set/entry

require 'CFPropertyList'
require_relative '../../lib/spirit/computer'

Spirit::App.controllers :computers do

  # Get an index of computers and computer groups
  get '/get/all' do
    serial = params[:id]

    computers = Spirit::Computer.all
    computers.to_plist(plist_format: CFPropertyList::List::FORMAT_XML, convert_unknown_to_string: true)
  end

  # Get or create a computer object
  #
  # Retrieve entry by serial
  # ?id={serial}&pk=sn
  #
  # Create entry with defaults
  # ?sn={serial}&mac={mac}&populate=yes
  get '/get/entry' do
    populate = params[:populate]

    # TODO: Read from group setting
    computer_prefix = 'spirit' # Computer name prefix

    if populate == 'yes'
      sn = params[:sn] # client serial
      mac = params[:mac] # client eth id

      # computer number  = computer key + 1
      #computer = Computers.create sn, mac
      computer = {
          sn => {
              'cn' => '3', # Computer number?
              'dstudio-auto-disable' => 'NO', # (?) Disable auto start
              'dstudio-auto-reset-workflow' => 'NO', # (?
              'dstudio-bootcamp-windows-computer-name' => '3', # prefix would be added to this
              'dstudio-disabled' => 'NO', # (?)
              'dstudio-group' => 'Default',
              'dstudio-host-new-network-location' => 'NO', # (?) depends on group config
              'dstudio-host-primary-key' => settings.computers_primary_key,
              'dstudio-host-serial-number' => sn,
              'dstudio-hostname' => computer_prefix + '3',
              'dstudio-users' => [
                  {
                      'dstudio-user-admin-status' => 'YES',
                      'dstudio-user-hidden-status' => 'NO',
                      'dstudio-user-name' => 'Administrator',
                      'dstudio-user-password' => 'CIPHERGOESHERE',
                      'dstudio-user-shortname' => 'admin'
                  }
              ]
          }
      }
    else
      id = params[:id] # computer primary key
      pk = params[:pk] # primary key (serial "sn" or ethernet id "?")

      computer = {
          id => {
              'cn' => '3', # Computer number?
              'dstudio-auto-disable' => 'NO', # (?) Disable auto start
              'dstudio-auto-reset-workflow' => 'NO', # (?
              'dstudio-bootcamp-windows-computer-name' => '3', # prefix would be added to this
              'dstudio-disabled' => 'NO', # (?)
              'dstudio-group' => 'Default',
              'dstudio-host-new-network-location' => 'NO', # (?) depends on group config
              'dstudio-host-primary-key' => settings.computers_primary_key,
              'dstudio-host-serial-number' => id,
              'dstudio-hostname' => computer_prefix + '3',
              'dstudio-users' => [
                  {
                      'dstudio-user-admin-status' => 'YES',
                      'dstudio-user-hidden-status' => 'NO',
                      'dstudio-user-name' => 'Administrator',
                      'dstudio-user-password' => 'CIPHERGOESHERE',
                      'dstudio-user-shortname' => 'admin'
                  }
              ]
          }
      }
    end

    computer.to_plist(plist_format: CFPropertyList::List::FORMAT_XML)
  end

  # Get a list of computer groups
  get '/groups/get/all' do
    groups_plist = CFPropertyList::List.new(:file => settings.group_settings)
    groups_native = CFPropertyList.native_types(groups_plist.value)

    groups = { 'groups' => groups_native.keys }
    groups.to_plist(plist_format: CFPropertyList::List::FORMAT_XML)
  end

  # Get the default group name
  get '/groups/get/default' do
    groups_plist = CFPropertyList::List.new(:file => settings.group_settings)
    groups_native = CFPropertyList.native_types(groups_plist.value)

    default_group = {
        'default' => groups_native['_dss_default']['dstudio-group-default-group-name']
    }

    default_group.to_plist(plist_format: CFPropertyList::List::FORMAT_XML)
  end

  # Get a computer group object
  get '/groups/get/entry' do
    group_name = params[:id]

    groups_plist = CFPropertyList::List.new(:file => settings.group_settings)
    groups_native = CFPropertyList.native_types(groups_plist.value)

    group_entry = groups_native.member?(group_name) ? groups_native[group_name] : {}
    group_entry.to_plist(plist_format: CFPropertyList::List::FORMAT_XML, convert_unknown_to_string: true)
  end

  # Get current status of all computers
  get '/status/get/all' do
    {}.to_plist(plist_format: CFPropertyList::List::FORMAT_XML)
  end

  # Set computer information (Not implemented)
  post '/set/entry' do
    serial = params[:id]


  end

# DeployStudio Runtime POSTs status about its running state.
# It posts quite frequently
  post '/status/set/entry' do
    serial = params[:id]
    tag = params[:tag] # Indicates the `type` of info posted (aka category)

  end

  post '/set/entry' do
    request.body.rewind

    computer = Spirit::Computer.new params[:id]
    computer.contents = request.body.read

    201
  end
end
