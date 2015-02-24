#
# User ranking page does not include unique content.
# So i guess it's useless to include 10 millions of user pages in the sitemap.
#

require 'sitemap_generator'
include Rails.application.routes.url_helpers
include ActionView::Helpers::TagHelper

namespace :sitemap do
  desc "Generate Sitemap XML and store this on S3"
  task :generate => :environment do
    SitemapGenerator::Sitemap.default_host = 'http://github-awards.com'
    SitemapGenerator::Sitemap.create do
      # Root url ('/') is included by default
      add '/about', :changefreq => 'weekly', :priority => 1
      
      LanguageRank.select(:language, :city).where("city IS NOT NULL").group(:language, :city).each do |lr|
        add users_path(:type => :city, :language => lr.language, :city => lr.city)
      end
      
      LanguageRank.select(:language, :country).where("country IS NOT NULL").group(:language, :country).each do |lr|
        add users_path(:type => :country, :language => lr.language, :country => lr.country)
      end
    end
  end
end
