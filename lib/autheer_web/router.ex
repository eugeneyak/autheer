defmodule AutheerWeb.Router do
  use AutheerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {AutheerWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AutheerWeb do
    pipe_through :browser

    get "/",         PageController,     :login
    get "/auth",     AuthController,     :perform
    get "/callback", CallbackController, :perform
  end

  # Other scopes may use custom stacks.
  # scope "/api", AutheerWeb do
  #   pipe_through :api
  # end
end
