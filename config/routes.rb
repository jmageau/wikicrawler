Rails.application.routes.draw do

  resources :wiki_searches

  root to: 'static#home'

  get "/:page" => "static#show"
end
