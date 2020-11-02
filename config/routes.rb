Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  post '/process_dates', to: 'home#process_dates'
  get  'home/display'

  root 'home#index'
end
