class LogActivity
  include Mongoid::Document
  include Mongoid::Timestamps
  store_in collection: 'log_activities'

  field :data,              type: Array
  field :message,           type: String
  field :log_type,          type: String


  def self.record(data)
    la = new 
    la.message = data["message"]
    la.save
    puts "Recorded Log: #{la.inspect}"
    la
  end
end