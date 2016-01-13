class UserRankPresenter
  include ActionView::Helpers
  include ActionView::Context
  include Rails.application.routes.url_helpers
  
  def initialize(user_rank)
    @user_rank = user_rank
    @user = user_rank.user
  end
  
  def language
    @user_rank.language.capitalize
  end
  
  def location_link(type)
    content_tag(:td, class: "col-md-3") do
      if type == :world
        link_to "Worldwide", users_path(language: @user_rank.language)
      else
        link_to @user.send(type).capitalize, users_path(language: @user_rank.language, type => @user.send(type))
      end
    end
  end
  
  def location_rank(type)
    rank = @user_rank.send("#{type}_rank")
    user_count = @user_rank.send("#{type}_user_count")
    content_tag(:td) do
      concat raw "<strong>#{rank.gh_format}</strong>"
      concat " / "
      concat user_count.gh_format
      concat raw " <i class='fa fa-trophy'></i>"
    end
  end
  
  def city_infos
    if @user.city
      location_link(:city) + location_rank(:city)
    else 
      content_tag(:td, colspan: 2) do
        concat(content_tag(:p, raw("We couldn't find your city from your location on GitHub :( ")))
        concat(
          content_tag(:p) do
            concat("You can manually search for ")
            concat(link_to("top #{@user_rank.language.capitalize} GitHub developers in your city", users_path(language: @user_rank.language)))
          end
        )
      end
    end
  end
  
  def country_infos
    if @user.country
      location_link(:country) + location_rank(:country)
    end
  end
  
  def world_infos
    location_link(:world) + location_rank(:world)
  end
end

class Fixnum
  include ActionView::Helpers::NumberHelper
  def gh_format
    number_with_delimiter(self, delimiter: " ")
  end
end
