defmodule Issues.GithubIssues do
  require Logger

  @moduledoc """
  Module that integrate with Github's API
  """
  @user_agent [{"User-Agent", "Elixir luizgustavo.caciatori@gmail.com"}]
  @github_url Application.get_env(:issues, :github_url)

  def fetch(user, project) do
    Logger.info("Fetching #{user}'s project #{project}'")

    issues_url(user, project)
    |> HTTPoison.get(@user_agent)
    |> handle_response()
  end

  @doc """
  Build a url with user and project.

  ## Examples

      iex> GithubIssues.issues_url("my_user", "my_project")
      "https://api.github.com/repos/my_user/my_project/issues"

  """
  def issues_url(user, project) do
    "#{@github_url}/repos/#{user}/#{project}/issues"
  end

  def handle_response({_, %{status_code: status_code, body: body}}) do
    Logger.info("Got response: status code=#{status_code}")
    Logger.debug(fn -> inspect(body) end)

    {
      status_code |> check_error(),
      body |> Poison.Parser.parse!()
    }
  end

  defp check_error(200), do: :ok
  defp check_error(_), do: :error
end
