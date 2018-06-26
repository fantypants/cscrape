defmodule Cryptscrape.Router do
  use Cryptscrape.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Phauxth.Authenticate
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Cryptscrape do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/welcome", PageController, :welcome
    get "/pricing", PageController, :pricing
    get "/faq", PageController, :faq
    get "/about", PageController, :about
    get "/features", PageController, :features
    resources "/domains", DomainController
    get "/run", DomainController, :generatelist
    resources "/users", UserController
    resources "/sessions", SessionController, only: [:new, :create, :delete]

  end

  # Other scopes may use custom stacks.
  # scope "/api", Cryptscrape do
  #   pipe_through :api
  # end
end
