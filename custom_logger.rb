require 'mongo'
require 'mongoid'
require 'rest_client'
require 'json'
require 'pry-coolline'
require 'find'
require 'colorize'
require 'filemagic'
require 'bunny'

require './models/log_client.rb'
require './models/log_processor.rb'
require './models/log_activity.rb'

class CustomLogger
  def initialize(queue_name, topic)
  	#binding.pry
    initialize_db
    @queue_name = queue_name
    @topic      = topic
    create_connection
  end

  def initialize_db
    @connection = Mongoid.load!('./config/mongoid.yml', :development)
  end

  def create_connection
    if $connection.nil?
       $connection = Bunny.new(ENV['HPF_AMQP_URL'])
       $connection.start
    end

    $connection
  end
  
  def publish(data)
  	@lc = LogClient.new($connection, @queue_name)
  	@lc.publish_topic(@topic, data)
  end

  def subscribe
  	@lp = LogProcessor.new($connection, @queue_name, @topic)
  	@lp.subscribe
  end

  def run(data)
  	publish(data)
  	subscribe
  end
end



if ARGV[0].nil?
  puts "@@@@ Please specify which one do you want to run: client/processor"
else
  c_logger = CustomLogger.new('log', 'topic_logs')

  method = ARGV[0]
  if method == "client"
    c_logger.publish({message: "test"})
  elsif method == "processor"
  	c_logger.subscribe
  end
end
  