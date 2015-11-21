module Api
  module V0
    module Users
      class Index < ActiveModel::Serializer

        attributes :id, :login, :gravatar_url, :city, :country

      end
    end
  end
end
