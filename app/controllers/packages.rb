require_relative '../../lib/spirit/package'

Spirit::App.controllers :packages do

  # Get an index of the Package directory.
  # Package and Sets are listed. Sets also have an items key to
  # denote the number of child items.
  get '/get/all' do
    serial = params[:id]

    Spirit::Package.all_dict.to_plist
  end

  # Get package
  get '/get/entry' do
    set_name = params[:id]

    all_packages = Spirit::Package.all_dict

    if all_packages.has_key? set_name
      entry = {
          set_name => all_packages[set_name]
      }
      entry.to_plist
    else
      404
    end
  end

  # Get package sets
  # More or less the single entry format of a set given in the index
  get '/sets/get/all' do
    serial = params[:id]

    sets = Spirit::Package.sets

    sets.to_plist
  end

  # Get package set content
  # Index of the contents of the set name given in the id parameter.
  # Takes optional keywords parameter if you assign keywords to packages.
  get '/sets/get/entry' do
    set_name = params[:id]
    keywords = params[:keywords]

    puts 'Fetch set %s' % set_name

    Spirit::Package.all_dict(set_name).to_plist
  end

  # Delete a package
  post '/del/entry' do
    package_name = params[:id]
    set_name = params[:set]

    Spirit::Package.delete(package_name, set_name)

    201
  end

  # Add a package
  # NOTE: functionality not available, may not even be called by admin client.
  post '/set/entry' do
    500
  end

  # Add a package set
  # I could not find the function which calls this, usually sets/new/entry is called
  post '/sets/add/entry' do
    500
  end

  # Create a package set (Usually invoked by the plus button corresponding to sets)
  # Creates a new directory with a number `Package Set 1`
  post '/sets/new/entry' do
    Spirit::Package.create_set
    201
  end

  # Rename a package set
  post '/sets/ren/entry' do
    Spirit::Package.rename_set(params[:id], params[:new_id])
    201
  end

end
