#
# User ranking page does not include unique content.
# So i guess it's useless to include 10 millions of user pages in the sitemap.
#

require 'sitemap_generator'

SitemapGenerator::Sitemap.default_host = 'http://github-awards.com'
SitemapGenerator::Sitemap.create do
  #Root url is included by default
  add '/about', :changefreq => 'weekly', :priority => 1
end