namespace :repo do
  # desc "Crawl github API for repositories"
  # task crawl: :environment do
  #   Rails.logger.info "Start crawling"
  #   since = Repository.maximum(:github_id) || "0"
  #   Tasks::RepositoryImporter.new.crawl_github_repos(since)
  # end
  
  desc "Import repos from github archive"
  task import: :environment do
    RepositoryStreamWorker.new.perform(time: 1.day.ago)
  end
end