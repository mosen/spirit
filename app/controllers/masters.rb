Spirit::App.controllers :masters do

  get '/get/all' do
    client_id = params[:id]
    # Keywords may be either:
    # - A custom search term to match against filenames
    # - A custom search term to match against the values of the keywords property
    # - A reserved capitalised term indicating the filesystem: "HFS", "NTFS", "DEV"
    keywords = params[:keywords]

    results = Spirit::Master.all_dict(keywords)
    results.to_plist
  end

  get '/get/entry' do
    500
  end

  post '/compress/entry' do
    500
  end

  post '/del/entry' do
    master = Spirit::Master.new params[:id]
    Spirit::Master.delete(master)
    Spirit::Master.rebuild_keywords

    201
  end

  post '/ren/entry' do
    master = Spirit::Master.new params[:id]
    master.rename! params[:new_id]
    Spirit::Master.rebuild_keywords

    201
  end

  post '/scan/entry' do
    500
  end

  # Change keyword or status values in the keywords.plist "database"
  # Can post a bplist with { status => DISABLED } or { keywords => "foo bar baz" }
  post '/set/entry' do
    500
  end

  post '/workinprogress/finalize' do
    500
  end


end
