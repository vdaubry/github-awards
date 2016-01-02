module Api
  module V0
    class UserSerializer < ActiveModel::Serializer

        attributes :id,
                   :login,
                   :gravatar_url,
                   :city,
                   :country
    end
  end
end
