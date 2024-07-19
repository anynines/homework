class HealthRoutes < Sinatra::Base
    
  get('/') do
    if request.env['AUTHED'] = true
      'App working OK'
    else
      status 403
    end
  end
end
