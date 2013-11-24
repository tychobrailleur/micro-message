import org.apache.camel.ProducerTemplate
import org.apache.camel.builder.RouteBuilder

class ProducerMain extends org.apache.camel.main.Main

object Main {
  def main(args: Array[String]) {
    println("Start...")
    val instance = new ProducerMain
    instance.enableHangupSupport()
    instance.addRouteBuilder(new ProducerRouter)
    instance.run(args)
  }
}

class ProducerRouter extends RouteBuilder {
  def configure():Unit = from("file:outbox?delay=750").wireTap("stream:out").to("activemq:test.queue")
}
