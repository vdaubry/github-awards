module Api
  module V0
    class UserSerializer < ActiveModel::Serializer

        attributes :id,
                   :login,
                   :gravatar_url,
                   :city,
                   :country,
                   :type

        def type
          object.organization? ? 'organization' : 'user'
        end
    end
  end
end
