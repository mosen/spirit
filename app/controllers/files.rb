Spirit::App.controllers :files do

  get '/get/all' do
    files = Spirit::CopyFile.all

    file_hash = {
        'files' => files
    }

    file_hash.to_plist
  end

end
