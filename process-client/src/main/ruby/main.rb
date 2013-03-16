puts 'Starting...'

java_import 'org.apache.camel.CamelContext'
java_import 'org.apache.camel.impl.DefaultCamelContext'

context = DefaultCamelContext.new
endpoint = context.get_endpoint("activemq:test.queue")
consumer = endpoint.create_polling_consumer()
exchange = consumer.receive()

puts 'Done.'
