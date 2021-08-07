defmodule Flightex.Users.CreateOrUpdate do
  @moduledoc ~S"""
  Provides a function to facilitate the User struct creation
  and saving in the Agent.
  """

  alias Flightex.Users.Agent, as: UserAgent
  alias Flightex.Users.User

  @doc ~S"""
  Try to create an User struct and save it in the Agent

  ### Examples
      iex> user_data = %{name: "Joe", email: "joe@example.com", cpf: "12345678900"}
      iex> Flightex.Users.CreateOrUpdate.call(user_data)
      {:ok,
        %Flightex.Users.User{
          cpf: "12345678900",
          email: "joe@example.com",
          id: "5e3ba51a-b3a6-4772-8afa-4826c164aee6",
          name: "Joe"
        }}

      iex> user_data = %{name: "Joe", email: "joe@example.com", cpf: 12_345_678_900}
      iex> Flightex.Users.CreateOrUpdate.call(user_data)
      {:error, "Cpf must be a String"}
  """
  @spec call(%{name: String.t(), email: String.t(), cpf: String.t()}) ::
          {:ok, User.t()} | {:error, String.t()}
  def call(%{name: name, email: email, cpf: cpf}) do
    case User.build(name, email, cpf) do
      {:ok, user} -> UserAgent.save(user)
      {:error, _reason} = error -> error
    end
  end
end
