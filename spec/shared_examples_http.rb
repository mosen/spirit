shared_examples 'an xml plist response' do

  it 'should respond status 200 ok' do
    expect(last_response.status).to eq(200)
  end

  it 'should respond with content text/xml' do
    expect(last_response.header['Content-Type']).to eq('text/xml')
  end

end

shared_examples 'a deploystudio post result' do

  it 'should respond status 201 created' do
    expect(last_response.status).to eq(201)
  end

end