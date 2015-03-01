class UserStreamWorker
  include Sidekiq::Worker

  def perform(filepath)
    event_stream = File.read(filepath); 0
    Models::StreamParser.new(event_stream).parse do |event|
      
      if event.keys == ["login"]
        next
      end
      
      user = User.where(:login => event["login"].downcase).first
      
      if user
        user.name ||= event["name"]
        user.company ||= event["company"]
        user.location ||= event["location"]
        user.blog ||= event["blog"]
        user.email ||= event["email"]
        user.save!
      end
    end
  end
end