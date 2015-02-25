class LanguageRankPresenter
  include ActionView::Helpers
  include ActionView::Context
  include Rails.application.routes.url_helpers
  
  def initialize(language_ranks)
    @language_ranks = language_ranks
  end

  def rank(type, language_rank)
    rank = language_rank.send("#{type}_rank")
    user_count = language_rank.send("#{type}_user_count")
    "<strong>#{rank.gh_format}</strong> / #{user_count.gh_format}".html_safe
  end

  def city_rank(language_rank)
    rank(:city, language_rank)
  end
  
  def country_rank(language_rank)
    rank(:country, language_rank)
  end
  
  def world_rank(language_rank)
    rank(:world, language_rank)
  end
  
  def best_rank
    lr = @language_ranks.min {|a, b| a.city_rank <=> b.city_rank}
    if lr && lr.city
      tweet_message = "I am the top #{lr.city_rank} #{lr.language} developer in #{lr.city.capitalize}. Check your Github ranking on Github-awards !"
      content_tag :p, class: "" do 
        "Tweet your <a href='http://twitter.com/share?text=#{tweet_message}&url=#{user_url(lr.user)}' title='Share github-awards on Twitter' target='_blank'>ranking <i class='fa fa-twitter'></i></a>".html_safe
      end
    end
  end
end


class Fixnum
  include ActionView::Helpers::NumberHelper
  def gh_format
    number_with_delimiter(self, :delimiter => " ")
  end
end
