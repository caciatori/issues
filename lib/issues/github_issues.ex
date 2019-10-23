defmodule Issues.GithubIssues do
  @moduledoc """
  Module that integrate with Github's API
  """
  @user_agent [{"User-Agent", "Elixir luizgustavo.caciatori@gmail.com"}]

  def fetch(user, project) do
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
    "https://api.github.com/repos/#{user}/#{project}/issues"
  end

  @doc """
  Handle success response

  ## Examples

      iex> GithubIssues.handle_response({:ok, %{status_code: 200, body: {}}})
      {:ok, {}}

  """
  def handle_response({:ok, %{status_code: 200, body: body}}) do
    {:ok, body}
  end

  @doc """
  Handle error response

  ## Examples

      iex> GithubIssues.handle_response({:error, %{status_code: 401, body: {}}})
      {:error, {}}

  """
  def handle_response({_, %{status_code: _, body: body}}) do
    {:error, body}
  end
end
