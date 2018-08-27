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
    post("/stripe/webhook", Cryptscrape.Payment, :webhook)
  end

  scope "/", Cryptscrape do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/welcome", PageController, :welcome
    get "/pricing", PageController, :pricing
    get "/faq", PageController, :faq
    get "/domains/:id/add_vote", DomainController, :add_vote
    get "/watch/domains/", DomainController, :watch_index
    post "/watch/domains/:id/add_vote", DomainController, :add_vote
    get "/watch/domains/:id/add_vote", DomainController, :add_vote
    post "/watch/domains/:id/add_negvote", DomainController, :add_negvote
    get "/watch/domains/:id/add_negvote", DomainController, :add_negvote

    get "/direct/domains/", DomainController, :direct_index
    post "/direct/domains/:id/add_vote", DomainController, :add_vote
    get "/direct/domains/:id/add_vote", DomainController, :add_vote
    post "/direct/domains/:id/add_negvote", DomainController, :add_negvote
    get "/direct/domains/:id/add_negvote", DomainController, :add_negvote


    get "/potential/domains/", DomainController, :potential_index
    post "/potential/domains/:id/add_vote", DomainController, :add_vote
    get "/potential/domains/:id/add_vote", DomainController, :add_vote
    post "/potential/domains/:id/add_negvote", DomainController, :add_negvote
    get "/potential/domains/:id/add_negvote", DomainController, :add_negvote
    get "/users/:id/billing", UserController, :billing
    post "/users/:id/billing", UserController, :billing
    post "/domains/:id/add_vote", DomainController, :add_vote
    post "/domains/:id/add_negvote", DomainController, :add_negvote
    get "/about", PageController, :about
    get "/features", PageController, :features

    get "/run", DomainController, :generatelist
    get "/interim", DomainController, :intermin_check
    get "users/:id/success_charge", UserController, :success_charge

    get "users/:id/charge", UserController, :charge
    post "users/:id/charge", UserController, :charge
    post "users/:id/create_charge", UserController, :create_charge
    get "users/:id/customers", UserController, :customers

    get "/csv", Csv, :export
    get "users/:id/csvupload", UserController, :csvupload
    post "users/:id/csvupload", UserController, :csvupload
    get "users/:id/csvupload", Csv, :csvupload
    post "users/:id/csvupload", Csv, :csvupload
    get "users/:id/insert", Csv, :insert
    post "users/:id/insert", Csv, :insert

    get "/users/:id/admin", UserController, :admin
    post "/users/:id/admin", UserController, :admin
    get "/users/:id/edit_domains", DomainController, :edit_domains
    post "/users/:id/edit_domains", DomainController, :edit_domains
    get "/domains/:id/delete_domain", DomainController, :delete_domain
    post "/domains/:id/delete_domain", DomainController, :delete_domain
    get "/domains/:id/make_active", DomainController, :make_active
    post "/domains/:id/make_active", DomainController, :make_active
    resources "/users", UserController
    resources "/sessions", SessionController, only: [:new, :create, :delete]
    resources "/domains", DomainController

    get "/viewemails", UserController, :view_emails
    post "/viewemails", UserController, :view_emails
    get "/resetpassword", UserController, :reset_password
    post "/resetpassword", UserController, :reset_password
    get "/passwordreset", UserController, :passwordreset
    post "/passwordreset", UserController, :passwordreset

  end

  # Other scopes may use custom stacks.
  # scope "/api", Cryptscrape do
  #   pipe_through :api
  # end
end
