shared_context 'parsed plist response' do
  let (:plist_hash) {
    plist = CFPropertyList::List.new(:data => last_response.body)
    CFPropertyList.native_types(plist.value)
  }
end