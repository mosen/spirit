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

require 'cfpropertylist'
require_relative '../../lib/spirit/computer'

Spirit::App.controllers :computers do

  # Get an index of computers and computer groups
  get '/get/all' do
    serial = params[:id]

    computers = Spirit::Computer.all
    computers_plist = computers.to_plist(plist_format: CFPropertyList::List::FORMAT_XML, convert_unknown_to_string: true)

    computers_plist
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

    if populate == 'yes'
      sn = params[:sn] # client serial
      mac = params[:mac] # client eth id

      computer_hash = Spirit::Computer.create(sn, mac)

      response = { sn => computer_hash }

    else
      id = params[:id] # computer primary key
      pk = params[:pk] # primary key (serial "sn" or ethernet id "mac")

      computer = Spirit::Computer.new pk, id
      response = {
          id => computer.to_hash
      }
    end

    response.to_plist(plist_format: CFPropertyList::List::FORMAT_XML)
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
        # TODO: _dss_default isn't always the right key, example: delete group settings and restart from PrefPane
        # the key will be `Default`
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

    request.body.rewind

    computer = Spirit::Computer.new 'sn', serial # TODO: Use primary key setting from config instead of "sn" literal
    computer.contents= request.body.read
  end

# DeployStudio Runtime POSTs status about its running state.
# It posts quite frequently
  post '/status/set/entry' do
    serial = params[:id]
    tag = params[:tag] # Indicates the `type` of info posted (aka category)

    logger.info "Received status update for tag: %s" % tag
    logger.info @request_payload

  end

  post '/set/entry' do
    request.body.rewind

    computer = Spirit::Computer.new params[:id]
    computer.contents = request.body.read

    201
  end
end
