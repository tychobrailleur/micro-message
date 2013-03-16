require 'nokogiri'

java_import 'org.apache.camel.CamelContext'
java_import 'org.apache.camel.impl.DefaultCamelContext'

context = DefaultCamelContext.new
endpoint = context.get_endpoint("activemq:test.queue")
consumer = endpoint.create_polling_consumer()

puts 'Starting...'
while true
  exchange = consumer.receive()
  message = exchange.get_in().body

  # Process incoming xml message
  doc = Nokogiri::XML(message)
  code = doc.at_xpath("/message/code").text()
  
  # Exit when code is END.
  if code == "END"
    puts "Bye."
    Java::JavaLang::System::exit(0)
  else
    puts "Code: #{code}"
  end
end
