class LanguageRankPresenter
  def initialize(language_rank)
    @language_rank = language_rank
  end
  
  def city_rank
    "<strong>#{@language_rank.city_rank.gh_format}</strong> / #{@language_rank.city_user_count.gh_format}"
  end
  
  def country_rank
    "<strong>#{@language_rank.country_rank.gh_format}</strong> / #{@language_rank.country_user_count.gh_format}"
  end
  
  def world_rank
    "<strong>#{@language_rank.world_rank.gh_format}</strong> / #{@language_rank.world_user_count.gh_format}"
  end
end


class Fixnum
  include ActionView::Helpers::NumberHelper
  def gh_format
    number_with_delimiter(self, :delimiter => " ")
  end
end
