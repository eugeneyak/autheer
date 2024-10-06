defmodule AutheerWeb.CallbackController do
  use AutheerWeb, :controller

  def perform(conn, params) do
    if rb = get_session(conn, "rb") do
      conn
      |> put_session("profile", params)
      |> delete_session("rb")
      |> redirect(external: rb)
    else
      conn
      |> clear_session
      |> send_resp(:bad_request, "")
    end
  end
end
