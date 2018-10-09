require 'mongo'
class LogClient
  def initialize(connection, queue_name)
    @ch = connection.create_channel
    @queue_name = queue_name
  end

  def publish_topic(topic, data)
    json = data.to_json
    puts "[x] LogClient started ..."
    puts "Data: #{data}"
    topic_exchange(topic).publish(json, routing_key: @queue_name, :persistent => true, :auto_delete => false,
                                 :durable => true, :exclusive => false)
  end
  
  def queue
    @queue
  end

  def ch
    @ch
  end

  def default_exchange
    @ch.exchange('')
  end

  def direct_exchange(name)
    @ch.exchange(name)
  end

  def topic_exchange(topic_name)
    @ch.topic(topic_name)
  end

  def queue
    @queue
  end

  def channel
    @ch
  end

  def close_channel
    @ch.close
  end

  def ack(msg)
    @ch.ack(msg)
  end
end