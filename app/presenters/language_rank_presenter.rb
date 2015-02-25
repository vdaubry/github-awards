class LanguageRankPresenter
  include ActionView::Helpers
  include ActionView::Context
  include Rails.application.routes.url_helpers
  
  def initialize(language_ranks)
    @language_ranks = language_ranks
  end
  
  def location_link(type, language_rank)
    content_tag(:td, :class => "col-md-3") do
      if type == :world
        link_to "Worldwide", users_path(:language => language_rank.language, :type => type)
      else
        link_to language_rank.user.send(type).capitalize, users_path(:language => language_rank.language, type => language_rank.user.send(type), :type => type)
      end
    end
  end
  
  def rank(type, language_rank)
    rank = language_rank.send("#{type}_rank")
    user_count = language_rank.send("#{type}_user_count")
    "<strong>#{rank.gh_format}</strong> / #{user_count.gh_format}".html_safe
  end

  def location_rank(type, language_rank)
    content_tag(:td) do
      rank(type, language_rank)+" <i class='fa fa-trophy'></i>".html_safe
    end
  end
  
  def city_infos(language_rank)
    if language_rank.city
      location_link(:city, language_rank) + location_rank(:city, language_rank)
    else 
      content_tag(:td, colspan: 2) do
        "<p> We couldn't find your city from your location on github :( </p>".html_safe +
        "<p>You can manually search for ".html_safe + link_to("top #{language_rank.language.capitalize} github developers in your city", users_path(:language => language_rank.language)) + "</p>".html_safe
      end
    end
  end
  
  def country_infos(language_rank)
    if language_rank.country
      location_link(:country, language_rank) + location_rank(:country, language_rank)
    end
  end
  
  def world_infos(language_rank)
    location_link(:world, language_rank) + location_rank(:world, language_rank)
  end
  
  
  
  def best_rank
    lr = @language_ranks.min {|a, b| a.city_rank <=> b.city_rank}
    if lr && lr.city
      tweet_message = "I am the top #{lr.city_rank} #{lr.language} developer in #{lr.city.capitalize}. Check your GitHub ranking on GitHub Awards !"
      content_tag :p, class: "" do 
        "Tweet your <a href='http://twitter.com/share?text=#{tweet_message}&url=#{user_url(lr.user)}' title='Share GitHub Awards on Twitter' target='_blank'>ranking <i class='fa fa-twitter'></i></a>".html_safe
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
