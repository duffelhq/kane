defmodule Kane do
  @moduledoc """
  Kane. Citizen Kane. Charles Foster Kane, to be exact, Publisher extraordinaire.

  Rosebud.

  Kane is for publishing and subscribing to topics using Google Cloud Pub/Sub.
  """

  @doc """
  Retrieves the default Oauth scope for retrieving an access token

      iex> Kane.oauth_scope
      "https://www.googleapis.com/auth/pubsub"
  """
  def oauth_scope, do: "https://www.googleapis.com/auth/pubsub"

  @doc """
  Retrieves the Google Cloud project name from the configured credentials
  """
  @spec project :: String.t()
  def project(goth_config_mod \\ Goth.Config) do
    {:ok, project} =
      case Application.get_env(:kane, :account) do
        nil -> goth_config_mod.get(:project_id)
        account -> goth_config_mod.get(account, :project_id)
      end

    project
  end
end
