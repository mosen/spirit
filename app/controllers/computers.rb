require 'cfpropertylist'
require_relative '../../lib/spirit/computer'
require_relative '../../lib/spirit/computer_group'

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

      groups = Spirit::ComputerGroup.all
      if groups.has_key?('_dss_default') && groups['_dss_default']['dstudio-group-default-group-name'] != ''
        default_group_name = groups['_dss_default']['dstudio-group-default-group-name']
        group_properties = groups[default_group_name]
        computer_hash = Spirit::Computer.create(sn, mac, group_properties)
      else
        computer_hash = Spirit::Computer.create(sn, mac)
      end

      response = { sn => computer_hash }

    else
      id = params[:id] # computer primary key
      pk = params[:pk] # primary key (serial "sn" or ethernet id "mac")

      computer = Spirit::Computer.new pk, id
      response = {
          id => computer.to_hash
      }
    end

    response.to_plist(plist_format: CFPropertyList::List::FORMAT_XML, convert_unknown_to_string: true)
  end

  # Get a list of computer groups
  get '/groups/get/all' do
    groups = Spirit::ComputerGroup.all

    group_names = { 'groups' => groups.keys }
    group_names.to_plist(plist_format: CFPropertyList::List::FORMAT_XML)
  end

  # Get the default group name
  get '/groups/get/default' do

    begin
      groups = Spirit::ComputerGroup.all

      default_group = {
          'default' => groups['_dss_default']['dstudio-group-default-group-name']
      }
    rescue
      default_group = { 'default' => '' }
    end

    default_group.to_plist(plist_format: CFPropertyList::List::FORMAT_XML)
  end

  # Get a computer group object
  get '/groups/get/entry' do
    group_name = params[:id]

    groups = Spirit::ComputerGroup.all

    if groups.member? group_name
      result = {
          group_name => groups[group_name]
      }
    else
      result = {}
    end

    result.to_plist(plist_format: CFPropertyList::List::FORMAT_XML, convert_unknown_to_string: true)
  end

  post '/groups/del/entry' do
    group_name = params[:id]

    Spirit::ComputerGroup.delete group_name

    201
  end

  post '/groups/new/entry' do
    Spirit::ComputerGroup.create

    201
  end

  post '/groups/ren/entry' do
    group_name_from = params[:id]
    group_name_to = params[:new_id]

    Spirit::ComputerGroup.rename group_name_from, group_name_to

    201
  end

  post '/groups/set/entry' do
    group_name = params[:id]

    group = Spirit::ComputerGroup.new group_name
    group.contents = @request_payload

    201
  end

  post '/groups/del/default' do
    group_name = params[:id]

    # TODO: does not verify that the `id` parameter was the default group that we want
    # to delete

    Spirit::ComputerGroup.delete '_dss_default'
    201
  end

  post '/groups/set/default' do
    group_name = params[:id]

    group = Spirit::ComputerGroup.new '_dss_default'
    group.contents = { 'dstudio-group-default-group-name' => group_name, 'dstudio-group-name' => '_dss_default' }

    201
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

    201
  end

# DeployStudio Runtime POSTs status about its running state.
# It posts quite frequently
  post '/status/set/entry' do
    serial = params[:id]
    tag = params[:tag] # Indicates the `type` of info posted (aka category)

    logger.info "Received status update for tag: %s" % tag
    logger.info @request_payload

  end

  post '/del/entries' do
    if @request_payload.member? 'ids'

      @request_payload['ids'].each do |id|
        computer = Spirit::Computer.new 'sn', id
        Spirit::Computer.delete(computer)
      end
      201
    else
      400
    end

  end
end
