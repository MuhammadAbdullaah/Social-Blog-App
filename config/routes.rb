Rails.application.routes.draw do
  # Devise routes for user authentication
  devise_for :users

  # Profile routes
  resource :profile, only: [ :show, :edit, :update ]

  # User management routes (admin access to manage users)
  resources :users, only: [ :index, :edit, :update, :destroy, :show ]

  # Post and Comment routes with a custom route for viewing the current user's posts
  resources :posts do
    collection do
      get "my_posts"  # Route for users to view only their own posts
    end
    resources :comments, only: [ :create, :destroy ]
  end

  # Dashboard routes based on user roles
  authenticated :user, ->(u) { u.admin? } do
    get "dashboard", to: "dashboard#admin"
  end

  authenticated :user do
    get "dashboard", to: "dashboard#user"
  end

  # Static routes
  get "home/index", to: "home#index"

  # Root path
  root to: "posts#index"
end
