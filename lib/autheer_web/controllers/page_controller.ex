defmodule AutheerWeb.PageController do
  use AutheerWeb, :controller

  def login(conn, _params) do
    render(conn, :login, layout: false)
  end
end
