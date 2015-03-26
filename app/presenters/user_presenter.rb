class UserPresenter
  include ActionView::Helpers
  include ActionView::Context
  include Rails.application.routes.url_helpers
  
  def initialize(user)
    @user = user
    @user_ranks = @user.user_ranks
  end
  
  def user_ranks
    @user_ranks
  end
  
  def city
    @user.city.try(:capitalize)
  end
  
  def country
    @user.country.try(:capitalize)
  end 
  
  def best_rank_tweet
    if @user_ranks.present? && @user.city
      lr = @user_ranks.first
      tweet_message = "I am the top #{lr.city_rank} #{lr.language} developer in #{@user.city.capitalize}. Check your GitHub ranking on GitHub Awards !"
      content_tag :p do 
        "Tweet your <a href='http://twitter.com/share?text=#{tweet_message}&url=#{user_url(@user)}' title='Share GitHub Awards on Twitter' target='_blank'>ranking <i class='fa fa-twitter'></i></a>".html_safe
      end
    end
  end
end