class UserListPresenter
  attr_reader :type, :language, :location
  
  def initialize(params)
    @type = params[:type].try(:to_sym) || :city
    @page = params[:page] || 0
    @location = params[@type].try(:downcase) || default_location
    @language = params[:language].try(:downcase) || "javascript"
  end
  
  def languages
    Rails.cache.fetch("languages") { JSON.parse(File.read(Rails.root.join('app/assets/json/languages.json'))) }
  end
  
  def title
    @type==:world ? "worldwide" : "in #{@location.capitalize}"
  end
  
  def show_location_input
    @type != :world
  end
  
  def location_input
    ActionController::Base.helpers.text_field_tag @type, @location.capitalize, :class => "form-control"
  end
  
  def rank_label
    "#{@type} Rank"
  end
  
  def ranking(language_rank)
    language_rank.send("#{@type}_rank")
  end
  
  def language_ranks
    res = LanguageRank.includes(:user).where(:language => @language)
    if @type!=:world
      res = res.where(@type => @location)
    end
    res.order("#{@type}_rank ASC").page(@page).per(25)
  end
  
  def default_location
    if @type == :city
      "san francisco"
    elsif @type == :country
      "united states"
    end
  end
end