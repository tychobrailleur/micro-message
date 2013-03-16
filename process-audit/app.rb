require 'sinatra'
require 'nokogiri'

post '/audit' do
  req = request.body.read
  doc = Nokogiri::XML(req)
  code = doc.at_xpath('/code').text()
  puts "code: #{code}"
end
