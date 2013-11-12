class Rack::Eveauth

  set :views, ::File.join(::File.dirname(__FILE__), '..', '..', 'views')
  get('/auth.html') { erb :authscreen }

  post('/auth.html') do
    if params["auth_or_register"] == "register"
      if register!(params["password"])
        halt 200, "register successful"
      else
        redirect "/auth.html"
      end
    else
      auth_with_password(params["capsuleer_name"],params["password"])
    end
  end

  post('/auth.json') do
    data = JSON.parse request.body.read

    if data["auth_or_register"] == "register"
      if register!(data["password"])
        halt 200
      else
        halt 403
      end
    else
      auth_with_password(data["capsuleer_name"],data["password"])
    end
  end

end