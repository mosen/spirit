require_relative '../../lib/spirit/workflow'

Spirit::App.controllers :workflows do

  # Workflow index
  # Runtime will request this with the groups key indicating the group of the machine running the workflow
  get '/get/all' do
    client_serial = params[:id]
    groups = params[:groups]

    workflows = Spirit::Workflow.all_dict

    workflows.to_plist(plist_format: CFPropertyList::List::FORMAT_XML, convert_unknown_to_string: true)
  end

  # Read workflow
  get '/get/entry' do
    workflow = Spirit::Workflow.new params[:id]
    workflow.contents
  end

  # Create or replace workflow
  post '/set/entry' do
    request.body.rewind

    workflow = Spirit::Workflow.new params[:id]
    workflow.contents = request.body.read

    201
  end

  # Delete workflow
  post '/del/entry' do
    workflow = Spirit::Workflow.new params[:id]
    Spirit::Workflow.delete(workflow)

    201
  end

  # Duplicate workflow (never seems to get called)
  # Admin client always just posts another original
  post '/dup/entry' do
    500
  end

end
