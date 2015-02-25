FactoryGirl.define do
  factory :language_rank do
    user
    sequence(:language) {|n| "string #{n}" }
    score               1.0
    city_rank           2
    country_rank        2
    world_rank          2
    repository_count    1
    stars_count         0
    city_user_count     4
    country_user_count  5
    world_user_count    6
  end
end