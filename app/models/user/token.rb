module User::Token
  def token
    authentication_providers.first.try(:token)
  end
end