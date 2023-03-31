class HealthRoutes < Sinatra::Base
  use AuthMiddleware

  get('/') do
    if request.env['AUTHED'] == true
      'App working OK'
    else
      status 403
    end
  end
end
