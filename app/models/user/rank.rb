module User::Rank
  def user_ranks
    repos = repositories.with_language.select("count(*) as repository_count, sum(stars) AS stars_count, language").group(:language).order("stars_count DESC")
    repos.map do |r|
      UserRank.new(self, r.language, r["stars_count"], r["repository_count"])
    end
  end
  
  def update_rank
    RankWorker.perform_async(self.id)
  end
end