FactoryGirl.define do
  factory :host_status do
    IPv4 '192.168.99.99'
    MACAddress '00:11:22:33:44:55'
    diskImageConversion false
    hostname 'spirit-test.local'
    identifier 'SERIAL1234'
    multicastStream false
    online false
    dialogDescription 'Workflow selector'
  end
end