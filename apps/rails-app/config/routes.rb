Rails.application.routes.draw do
  # твои остальные маршруты

  get '/health', to: proc { [200, {}, ['OK']] }
end

