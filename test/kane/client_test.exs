defmodule Kane.ClientTest do
  use ExUnit.Case, async: false

  setup do
    bypass = Bypass.open()
    Application.put_env(:kane, :endpoint, "http://localhost:#{bypass.port}")
    {:ok, bypass: bypass}
  end

  test "uses the default account", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      assert get_auth_header(conn) == "Bearer default"

      Plug.Conn.resp(conn, 201, "")
    end)

    Kane.Client.get("")
  end

  test "uses the configured account", %{bypass: bypass} do
    original_account = Application.get_env(:kane, :account)

    Bypass.expect(bypass, fn conn ->
      assert get_auth_header(conn) == "Bearer test@account.com"

      Plug.Conn.resp(conn, 201, "")
    end)

    Application.put_env(:kane, :account, "test@account.com")
    Kane.Client.get("")

    Application.put_env(:kane, :account, original_account)
  end

  defp get_auth_header(conn) do
    %{req_headers: req_headers} = conn
    {_, auth_header} = Enum.find(req_headers, fn {header, _} -> header == "authorization" end)
    auth_header
  end
end
