FactoryGirl.define do
  factory :repository do
    sequence(:name)     {|n| "string#{n}"}
    user
    stars               "string"
    language            "string"
    organization        "string"
    github_id           1234
    forked              false
    processed           false
  end
end