class TopRank
  def initialize(type:, language:, location:)
    @type=type
    @language = language
    @location = location
  end
  
  def count
    $redis.zcard(key)
  end
  
  def user_ranks(page:, per:)
    current_index = (page-1)*per
    results = $redis.zrevrange(key, current_index, current_index+per).slice(0, per)
    
    users = User.find_as_sorted(results)
    .joins(:repositories)
    .select("users.id, users.city, users.country, users.gravatar_url, users.login, sum(stars) AS stars_count, count(repositories.id) as repository_count")
    .where(:repositories => {:language => @language})
    .group("users.id")
    
    users.map do |user| 
      UserRank.new(user, @language, user.stars_count, user.repository_count)
    end
  end
  
  private
  def key
    @type!=:world ? "user_#{@language}_#{@location}" : "user_#{@language}"
  end
end