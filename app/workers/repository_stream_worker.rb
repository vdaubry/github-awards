class RepositoryStreamWorker
  include Sidekiq::Worker

  def perform(filepath)
    event_stream = File.read(filepath); 0
    Models::StreamParser.new(event_stream).parse do |event|
      repo = Repository.where(:user_id => event["a_repository_owner"], :name => event["a_repository_name"]).first
      if repo
        repo.stars = event["a_repository_watchers"].to_i if repo.stars==0
        repo.language ||= event["a_repository_language"]
        repo.processed = true
        repo.save
        
        puts "updated with language = #{repo.language} , stars = #{repo.stars}"
      end
    end
  end
end
