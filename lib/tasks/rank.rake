namespace :rank do
  
  task create: :environment do
    res = ActiveRecord::Base.connection.execute(File.read("sql/rank.sql"))
  end
end