Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/copy', to: 'airtable#index', as: 'copy'
  get '/copy/refresh', to: 'airtable#refresh', as: 'copy_refresh'
  get '/copy/:key', to: 'airtable#show', as: 'copy_detail', constraints: { key: /[^\/]+/ }
end
