class UserListPresenter
  attr_reader :type, :language, :location

  def initialize(params)
    @type = (params.keys.map(&:to_sym) & [:city, :country]).first || :world
    @page = [params[:page].to_i, 1].max
    @location = params.with_indifferent_access[@type].try(:downcase).try(:strip)
    @language = get_language(params)
  end

  def get_language(params)
    lang = params[:language] || "JavaScript"
    URI.decode_www_form_component(lang)
  end

  def languages
    Languages::Index.get(sort: :popularity).map {|language| [language, language.downcase] }
  end

  def title
    @type==:world ? "worldwide" : "in #{@location.capitalize}"
  end

  def show_location_input?
    @type != :world
  end

  def empty_message
    "Could not find any user for <strong> #{@type} </strong> '#{ERB::Util.html_escape @location}'. Use the auto completion to avoid spelling errors, or go to Top users by country for country search".html_safe
  end

  def location_input
    ActionController::Base.helpers.text_field_tag @type, @location.capitalize, class: "form-control"
  end

  def rank_label
    "#{@type.capitalize} rank"
  end

  def ranking(user_rank)
    user_rank.send("#{@type}_rank")
  end

  def user_ranks
    top_rank = TopRank.new(type: @type, language: @language, location: @location)
    user_ranks = top_rank.user_ranks(page: @page, per: 25)
    Kaminari.paginate_array(user_ranks, total_count: top_rank.count).page(@page).per(25)
  end
end