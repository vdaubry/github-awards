namespace :export do
  
  desc "Export language list to JSON (ordered according to githut.info)"
  task languages: :environment do
    File.open(Rails.root.join('app/assets/json/languages.json'), 'w+') do |f|
      languages = Repository.select(:language).order("language ASC").distinct.map{ |l| l.language}.to_a
      new_positions = ["JavaScript", "Java", "Python", "CSS", "PHP", "Ruby", "C++", "C", "Shell", "C#", "Objective-C", "R", "Swift", "Scala", "Clojure"]
      new_positions.each_with_index do |lang, new_pos|
        old_pos = languages.index(lang)
        languages[old_pos], languages[new_pos] = languages[new_pos], languages[old_pos]
      end
      f.puts languages.to_json
    end
  end
  
  desc "Export city list to JSON"
  task cities: :environment do
    File.open(Rails.root.join('app/assets/json/cities.json'), 'w') do |f|
      cities = Repository.select(:city).where("city IS NOT NULL").order("city ASC").distinct
      cities = cities.map{ |l| l.city.gsub(/[^0-9A-Za-z ]/, '').strip.capitalize}.to_a.reject(&:empty?)
      f.puts cities.to_json
    end
  end
  
  desc "Export city list to JSON"
  task countries: :environment do
    File.open(Rails.root.join('app/assets/json/countries.json'), 'w') do |f|
      countries = Repository.select(:country).where("country IS NOT NULL").order("country ASC").distinct
      countries = countries.map{ |l| l.country.gsub(/[^0-9A-Za-z ]/, '').strip.capitalize}.to_a.reject(&:empty?)
      f.puts countries.to_json
    end
  end
  
  desc "Convert images to PNG"
  task png: :environment do
    require 'pathname'
    width=150
    
    #Converts SVG
    Dir.glob(Rails.root.join("app/assets/images/languages/*.svg")).each do |f| 
      filename = File.basename( f, ".*" )
      dirname = File.dirname(f)
      `inkscape -z -e #{dirname}/#{filename}.png -w #{width} #{dirname}/#{filename}.svg`
    end
    
    #Converts JPG
    Dir.glob(Rails.root.join("app/assets/images/languages/*.jpg")).each do |f| 
      filename = File.basename( f, ".*" )
      dirname = File.dirname(f)
      `convert -resize #{width} #{dirname}/#{filename}.jpg #{dirname}/#{filename}.png`
    end
    
  end
  
end