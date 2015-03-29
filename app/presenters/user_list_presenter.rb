class UserListPresenter
  attr_reader :type, :language, :location
  
  def initialize(params)
    @type = sanitize_type(type: params[:type])
    @page = [params[:page].to_i, 1].max
    @location = params[@type].try(:downcase).try(:strip) || default_location
    @language = params[:language] || "JavaScript"
  end
  
  def languages
    Rails.cache.fetch("languages") { JSON.parse(File.read(Rails.root.join('app/assets/json/languages.json'))) }
  end
  
  def title
    @type==:world ? "worldwide" : "in #{@location.capitalize}"
  end
  
  def show_location_input?
    @type != :world
  end
  
  def location_input
    ActionController::Base.helpers.text_field_tag @type, @location.capitalize, :class => "form-control"
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
  
  def default_location
    if @type == :city
      "san francisco"
    elsif @type == :country
      "united states"
    end
  end
  
  def sanitize_type(type:)
    type = :city unless type && [:city, :country, :world].include?(type.to_sym)
    type
  end
end