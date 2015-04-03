class Oauth::Authorization
  def authorize(auth_hash:)
    authentication_provider = AuthenticationProvider.where(:uid => auth_hash["uid"]).first
    
    if authentication_provider.nil?
      user = User.where(:github_id => auth_hash["uid"]).first_or_initialize
      authentication_provider = AuthenticationProvider.new
      authentication_provider.user = user
    end
    
    user = authentication_provider.user
    begin
      update_user(user: user, auth_hash: auth_hash)
    rescue ActiveRecord::RecordNotUnique => e
      user = User.where(:login => user.login).first
      update_user(user: user, auth_hash: auth_hash)
    end
    update_authentication_provider(authentication_provider: authentication_provider, auth_hash: auth_hash)
    
    return user
  end
  
  def update_user(user:, auth_hash:)
    user.github_id = auth_hash.uid
    user.email = auth_hash.info.email
    user.login = auth_hash.extra.raw_info.login
    user.name = auth_hash.extra.raw_info.name
    user.company = auth_hash.extra.raw_info.company
    user.blog = auth_hash.extra.raw_info.blog
    user.gravatar_url = auth_hash.extra.raw_info.avatar_url
    user.location = auth_hash.extra.raw_info.location
    user.organization = auth_hash.extra.raw_info.type!="User"
    user.save
  end
  
  def update_authentication_provider(authentication_provider:, auth_hash:)
    authentication_provider.user_id = authentication_provider.user.id
    authentication_provider.uid = auth_hash.uid
    authentication_provider.token = auth_hash.credentials.token
    authentication_provider.provider = auth_hash.provider
    authentication_provider.save
  end
end