# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

resources :clients
resources :taxes
resources :invoices, only: [:new]
resources :projects do
  resources :invoices, except: [:edit, :update] do
    member do
      get 'part_2'
    end
  end
  resources :payments
end
