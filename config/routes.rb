Rails.application.routes.draw do

  resources :wiki_searches
  resources :wiki_pages

  root to: 'static#home'

  get "/:page" => "static#show"
end
