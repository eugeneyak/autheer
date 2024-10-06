defmodule AutheerWeb.AuthController do
  use AutheerWeb, :controller

  require Logger

  def perform(conn, _params) do
    case profile = get_session(conn, "profile") do
      %{"id" => id, "first_name" => name} ->
        Logger.info "Permissions granted as #{id} #{name}"
        render_profile(conn, profile)

      _ ->
        Logger.info "Session was not found, redirecting to the login page"
        login_redirect(conn)
    end
  end

  defp render_profile(conn, profile) do
    conn = put_resp_header(conn, "auth-user-id", Map.get(profile, "id"))
    conn = put_resp_header(conn, "auth-user-name", Map.get(profile, "first_name"))

    conn = if last_name = Map.get(profile, "last_name"),
      do:   put_resp_header(conn, "auth-user-last-name", last_name),
      else: conn

    conn = if username = Map.get(profile, "username"),
      do:   put_resp_header(conn, "auth-user-username", username),
      else: conn

    conn = if photo_url = Map.get(profile, "photo_url"),
      do:   put_resp_header(conn, "auth-user-photo-url", photo_url),
      else: conn

    conn
    |> send_resp(:ok, "Permissions granted as #{Map.get(profile, "id")}")
  end

  defp login_redirect(conn) do
    [method] = get_req_header(conn, "x-forwarded-method")

    case method do
      "GET" ->
        [uri]   = get_req_header(conn, "x-forwarded-uri")
        [proto] = get_req_header(conn, "x-forwarded-proto")
        [host]  = get_req_header(conn, "x-forwarded-host")

        conn
        |> put_session("rb", "#{proto}://#{host}#{uri}")
        |> redirect(external: Application.fetch_env!(:autheer, :host))

      _ ->
        send_resp(conn, :unauthorized, "Unauthorized")
    end
  end
end
