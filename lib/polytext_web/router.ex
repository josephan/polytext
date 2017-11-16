defmodule PolytextWeb.Router do
  use PolytextWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :require_login do
    plug CueCard.Plugs.RequireLogin
  end

  pipeline :ensure_admin do 
    plug CueCard.Plugs.EnsureAdmin
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Public Routes
  scope "/", PolytextWeb do
    pipe_through :browser # Use the default browser stack

    # Static pages
    get "/", PageController, :index

    # Session management
    get "/login",     SessionController, :new
    post "/login",    SessionController, :create
    delete "/logout", SessionController, :delete

    # User signup
    get "/signup",  UserController, :new
    post "/signup", UserController, :create
  end

  # Admin Routes
  scope "/admin", PolytextWeb do
    pipe_through [:browser, :require_login, :ensure_admin]
  end

  # Other scopes may use custom stacks.
  # scope "/api", PolytextWeb do
  #   pipe_through :api
  # end
end
