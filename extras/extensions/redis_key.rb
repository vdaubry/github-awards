class String
  def redis_key
    self.downcase.gsub(" ", "_")
  end
end