module EveauthHelper

  class IGBRequest
    def initialize(request)
      @env = request
    end

    def method_missing(m)
      @env["HTTP_EVE_"+m.to_s.upcase]
    end

    def trusted?
      @env['HTTP_EVE_TRUSTED'] == "Yes"
    end
  end

  def auth_with_password(name,pass)
    c = ::Eveauth::Capsuleer.where({name: name}).first
    if c.is_this_your_password?(pass)
      auth!(c)
      redirect "/"
    else
      halt 403
    end
  end

  def auth!(capsuleer)
    capsuleer.authenticated=true
    session[:srmt] = capsuleer.secret_remember_me_token!
  end

  def register!(pass)
    if not ::Eveauth::Capsuleer.where({name: env[:capsuleer].name}).exists?
      env[:capsuleer].password = pass
      env[:capsuleer].authenticated = true
      auth!(env[:capsuleer])
    end
    env[:capsuleer].save
  end

end