class Rack::Eveauth

  get('/auth/apikeys') do
    halt 403 unless env[:capsuleer].authenticated?

    @keys = env[:capsuleer].api_keys
    content_type :json
    @keys.to_json
  end

  post('/auth/apikeys') do
    halt 403 unless env[:capsuleer].authenticated?
    data = JSON.parse request.body.read

  end

  put('/auth/apikeys') do
    redirect to("/auth.html") unless env[:capsuleer].authenticated?

  end

  delete('/auth/apikeys') do
    redirect to("/auth.html") unless env[:capsuleer].authenticated?

  end

end