require 'net/http'

class RepositoryStreamWorker
  include Sidekiq::Worker

  def perform(time:)
    stream = Models::Stream.new(time: time)
    stream.parse
    stream.each do |repo_name|
      login = repo_name.split("/")[0]
      user = User.where(login: login.downcase).first
      if user.nil?
        Rails.logger.info("Creating user #{login}")
        UserUpdateWorker.perform_in(job_delay, login, true)
      else
        repo = repo_name.split("/")[1]
        Rails.logger.info("Updating repo #{repo}")
        RepositoryUpdateWorker.perform_in(job_delay, user.id, repo)
      end
    end
  end

  def job_delay
    rand(0..60*60).seconds
  end
end
