require_relative '../../lib/spirit/copy_file'

Spirit::App.controllers :files do

  get '/get/all' do
    files = Spirit::CopyFile.all

    file_hash = {
        'files' => files
    }

    file_hash.to_plist(plist_format: CFPropertyList::List::FORMAT_XML)
  end

end
