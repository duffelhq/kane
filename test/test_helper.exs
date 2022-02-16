ExUnit.start()
Application.ensure_all_started(:bypass)

defmodule Kane.TestToken do
  def for_scope({account, scope}) do
    {:ok,
     %Goth.Token{
       account: account,
       scope: scope,
       expires: :os.system_time(:seconds) + 3600,
       type: "Bearer",
       # We use the account name as token to allow asserting on it during tests
       token: account
     }}
  end

  def for_scope(scope), do: for_scope({:default, scope})
end
