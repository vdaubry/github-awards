class RankWorker
  include Sidekiq::Worker
  
  def perform(type, value)
    marker = 0
    batch_size = 200
    loop do
      result = LanguageRank.where("#{type} = '#{value}' AND user_id > #{marker}").order("user_id ASC").limit(batch_size).each do |lr|
        key = "rank_#{value}"
        key += "_#{lr.language}" if type.to_s != "language"
        $redis.zadd(key, lr.score, lr.user_id)
      end
      
      marker = result.last.try(:user_id)
      break if result.count==0
    end
  end
end