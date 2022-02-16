defmodule KaneTest do
  use ExUnit.Case, async: false
  doctest Kane

  defmodule GothConfigMock do
    def get(:project_id) do
      {:ok, "default"}
    end

    def get(account, :project_id) do
      {:ok, account}
    end
  end

  describe "project/0" do
    test "with no account configured" do
      assert "default" == Kane.project(GothConfigMock)
    end

    test "with an account configured" do
      original_account = Application.get_env(:kane, :account)

      Application.put_env(:kane, :account, "test@account.com")
      assert "test@account.com" == Kane.project(GothConfigMock)

      Application.put_env(:kane, :account, original_account)
    end
  end
end
