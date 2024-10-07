defmodule AutheerWeb.CallbackControllerTest do
  use AutheerWeb.ConnCase

  setup :prepare_profile

  describe "when rb is empty" do
    test "app responces with bad request", %{conn: conn, profile: profile} do
      conn = conn |> get(~p"/callback", profile)

      assert response(conn, 400)
    end
  end

  describe "when rb is present" do
    setup :set_rb

    test "GET /callback with RB redirects", %{conn: conn, profile: profile} do
      conn = conn |> get(~p"/callback", profile)

      assert redirected_to(conn) =~ "http://example.com"
    end

    test "GET /callback with RB sets session", %{conn: conn, profile: profile} do
      conn = conn |> get(~p"/callback", profile)

      assert get_session(conn) == %{"profile" => profile}
    end
  end

  defp set_rb(%{conn: conn}) do
    %{conn: put_session(conn, "rb", "http://example.com")}
  end

  defp prepare_profile(_ctx) do
    profile = %{
      "id" => "123",
      "first_name" => "John",
      "last_name" => "Doe",
      "photo_url" => "Https://example.com/photo.jpg",
    }

    %{profile: profile}
  end
end
