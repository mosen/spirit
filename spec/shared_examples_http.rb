require 'cfpropertylist'

shared_examples 'an xml plist response' do

  it 'has a HTTP response status of 200 ok' do
    expect(last_response.status).to eq(200)
  end

  it 'has a content type of text/xml' do
    expect(last_response.header['Content-Type']).to eq('text/xml;charset=utf8')
  end

  it 'is a parseable plist' do
    expect {
      plist = CFPropertyList::List.new(:data => last_response.body)
    }.to_not raise_error()
  end
end

shared_examples 'a binary plist response' do

  it 'has a HTTP response status of 200 ok' do
    expect(last_response.status).to eq(200)
  end

  # DeployStudio now sets Content-Type as empty string. It assumes all Request/Response bodies to be bplist
  # it 'has a content type of application/octet-stream' do
  #   expect(last_response.header['Content-Type']).to eq('application/octet-stream')
  # end

  it 'has a content length greater than zero' do
    expect(last_response.length).to be > 0
  end

  it 'is a parseable plist' do
    expect {
      plist = CFPropertyList::List.new(:data => last_response.body, :format => CFPropertyList::List::FORMAT_BINARY)
    }.to_not raise_error
  end

  it 'is in binary plist (bplist) format' do
    plist = CFPropertyList::List.new(:data => last_response.body)
    expect(plist.format).to eq(CFPropertyList::List::FORMAT_BINARY)
  end

end

shared_examples 'a successful post' do

  it 'should respond status 201 created' do
    expect(last_response.status).to eq(201)
  end

end