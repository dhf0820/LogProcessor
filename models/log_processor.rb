class LogProcessor
  def initialize(connection, queue_name, topic_name)
    $connection = connection
    @ch         = $connection.create_channel
    @topic      = @ch.topic(topic_name)
    @queue      = @ch.queue('', exclusive: true)

    @queue.bind(@topic, :routing_key => queue_name)
  end

  def subscribe
    begin
      puts "[x] LogProcessor is waiting for job on #{@queue.name}"

      @queue.subscribe(:block => true) do |delivery_info, properties, body|
        puts "[x] Received Data ...#{body}"
        data = JSON.parse(body)
        LogActivity.record(data)
      end
    rescue Exception => e
      puts "EXCEPTION:  #{e.message}"
      $ch.close
      $connection.close
    end
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