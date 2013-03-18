require 'nokogiri'

java_import 'org.apache.camel.CamelContext'
java_import 'org.apache.camel.Exchange'
java_import 'org.apache.camel.impl.DefaultCamelContext'
java_import 'org.apache.camel.ProducerTemplate'
java_import 'org.apache.camel.impl.DefaultProducerTemplate'
java_import 'org.apache.camel.builder.RouteBuilder'

context = DefaultCamelContext.new
endpoint = context.get_endpoint("activemq:test.queue")
consumer = endpoint.create_polling_consumer()


class ClientRouter < RouteBuilder
  def configure
    from("activemq:test.queue").process do |exchange|
      message = exchange.get_in().body

      # Process incoming xml message
      doc = Nokogiri::XML(message)
      code = doc.at_xpath("/message/code").text()
  
      # Exit when code is END.
      if code == "END"
        puts "Bye."
        Java::JavaLang::System::exit(0)
      else
        exchange.get_out().body = "<code>#{code}</code>"
      end
    end.to("direct:path")

    from("direct:path").wire_tap("direct:audit")
      .set_header(Exchange::HTTP_METHOD, constant("POST"))
      .to("http://localhost:9495/process")

    from("direct:audit").set_header(Exchange::HTTP_METHOD, constant("POST")).to("http://localhost:4567/audit")
  end
end

context.add_routes(ClientRouter.new)
template = context.create_producer_template()

puts 'Starting...'
context.start()
