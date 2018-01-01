defmodule PolytextWeb.Router do
  use PolytextWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Polytext.BrowserAuth
  end

  pipeline :require_login do
    plug Polytext.Plugs.RequireLogin
  end

  pipeline :ensure_admin do 
    plug Polytext.Plugs.EnsureAdmin
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

  # User Routes
  scope "/", PolytextWeb do
    pipe_through [:browser, :require_login]

    # Dashboard
    resources "/documents", DocumentController
  end

  # Admin Routes
  scope "/admin", PolytextWeb.Admin, as: :admin do
    pipe_through [:browser, :require_login, :ensure_admin]
  end

  # Other scopes may use custom stacks.
  scope "/api", PolytextWeb.Api do
    pipe_through :api

    resources "/documents", DocumentController, only: [:index, :show]
  end
end
