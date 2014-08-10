Rails.application.routes.draw do
  # Search charities (for the autocomplete on the front page)
  # charities#search (i.e., the method "search" in CharitiesController)
  get 'charities/search'

  # Donate
  # payments#create
  get 'payment/create'

  # Start the Paypal authentication process
  # paypal#authenticate
  get 'paypal/authenticate'

  # resources automatically creates a whole heapload of routes (the ones
  # of which we use are documented below)
  resources :campaigns do
    # campaigns#show - show an individual campaign's details
    # campaigns#new - frontend form to create a new camaign
    # campaigns#create - backend stuff to create a new campaign from POSTed details
    collection do
      get 'share' # campaigns#share - share a campaign on social media
    end
  end

  resources :sessions do
    # sessions#new - frontend page to sign in
    # sessions#create - backend stuff to login via password authentication (details POSTed)
    collection do
      get 'destroy' # sessions#destroy - logout
    end
  end
  get "/auth/:provider/callback" => "sessions#create_oauth", as: :create_oauth # sessions#create: handle everything oauth
  get "/twitter_donate/:campaign/:amount" => "sessions#twitter_donate" # sessions#twitter_donate: setup the user as a new donor via a Twitter login
  get "/facebook_donate/:campaign/:amount" => "sessions#facebook_donate" # sessions#facebook_donate: setup the user as a new donor via a Facebook login

  resources :campaigners
  # campaigners#new - frontend stuff to register as a new campaigner
  # campaigners#create - backend stuff to actually register a new campaigner

  resources :donors
  # donors#new - frontend stuff to finish of the donor registration process (links to add more social authentications and login via paypal)

  # pages#home: the homepage with "that" form on
  get 'pages/home'
  root 'pages#home'
  # pages#handle_home - handles submission of "that" form
  post 'pages/handle_home'

  # pages#dashboard - the user dashboard
  get 'pages/dashboard'

  # paypal#authenticate - the URL that starts the whole paypal authentication flow
  get "/paypal/authenticate" => "paypal#authenticate"
  # paypal#ipn - the URL that's called by the paypal backend. See comments in PaypalController for more information.
  post "/paypal/ipn"
  # paypal#completed - the user is redirected here on successful completion of paypal authentication
  get "/paypal/completed"
  # paypal#completed - the user is redirected here if the paypal authentication flow is cancelled by them
  get "/paypal/cancelled"
  # paypal#completed - the user is redirected here if the paypal authentication flow fails
  get "/paypal/failed"
end
