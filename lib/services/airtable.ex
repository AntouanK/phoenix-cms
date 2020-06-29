defmodule Services.Airtable do
  @moduledoc """
  Airtable HTTP client
  """

  @spec all(String.t()) :: {:ok, term} | {:error, non_neg_integer}
  def all(table) do
    client()
    |> Tesla.get("/#{table}")
    |> case do
      {:ok, %{status: 200, body: body}} ->
        {:ok, body}

      {:ok, %{status: status}} ->
        {:error, status}
    end
  end

  @spec get(String.t(), String.t()) :: {:ok, term} | {:error, non_neg_integer}
  def get(table, record_id) do
    client()
    |> Tesla.get("/#{table}/#{record_id}")
    |> case do
      {:ok, %{status: 200, body: body}} ->
        {:ok, body}

      {:ok, %{status: status}} ->
        {:error, status}
    end
  end

  defp client do
    middleware = [
      {Tesla.Middleware.BaseUrl, "https://api.airtable.com/v0/" <> base_id()},
      Tesla.Middleware.JSON,
      Tesla.Middleware.Logger,
      {Tesla.Middleware.Headers, [{"authorization", "Bearer " <> api_key()}]}
    ]

    Tesla.client(middleware)
  end

  defp api_key, do: Application.get_env(:phoenix_cms, __MODULE__)[:api_key]
  defp base_id, do: Application.get_env(:phoenix_cms, __MODULE__)[:base_id]
end
