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

shared_examples 'an xml plist post' do

  it 'should respond status 201 created' do
    expect(last_response.status).to eq(201)
  end

end