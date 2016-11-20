# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

resources :clients
resources :taxes
resources :invoices, only: [:new]
resources :projects do
  resources :invoices, except: [:edit, :update]
  resources :payments
end
