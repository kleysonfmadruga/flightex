defmodule Flightex.Users.Agent do
  @moduledoc ~S"""
  Provides a set of functions to save and get User structs in an Agent
  """

  use Agent

  alias Flightex.Users.User

  @doc ~S"""
  Starts an Agent process attached to the module name

  ### Examples
      iex> Flightex.Users.Agent.start_link(%{})
      {:ok, #PID<0.248.0>}

      iex> Flightex.Users.Agent.start_link(%{})
      {:error, {:already_started, #PID<0.248.0>}}
  """
  @spec start_link(any()) :: {:ok, pid()} | {:error, any()}
  def start_link(_context) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  @doc """
  Saves an User struct in the Agent

  ### Examples
      iex> Flightex.Users.Agent.save(user)
      {:ok,
        %Flightex.Users.User{
          cpf: "12345678900",
          email: "joe@example.com",
          id: "b107c35e-f8e4-46bb-a2a8-6f4337b3ca38",
          name: "Joe"
        }}
  """
  @spec save(User.t()) :: {:ok, User.t()}
  def save(user) do
    Agent.update(__MODULE__, fn current_state -> update_state(current_state, user) end)

    {:ok, user}
  end

  @doc """
  Try to find an User struct in the Agent's current state

  ### Examples
      iex> Flightex.Users.Agent.get("b107c35e-f8e4-46bb-a2a8-6f4337b3ca38")
      {:ok,
        %Flightex.Users.User{
          cpf: "12345678900",
          email: "jp@banana.com",
          id: "b107c35e-f8e4-46bb-a2a8-6f4337b3ca38",
          name: "Jp"
        }}

      iex> Flightex.Users.Agent.get("00000000-0004-4000-0000-000000000000")
      {:error, "User not found"}
  """
  @spec get(String.t()) :: {:ok, User.t()} | {:error, String.t()}
  def get(id), do: Agent.get(__MODULE__, fn current_state -> get_user(current_state, id) end)

  defp update_state(current_state, %User{id: id} = user) do
    Map.put(current_state, id, user)
  end

  defp get_user(current_state, id) do
    case Map.get(current_state, id) do
      nil -> {:error, "User not found"}
      user -> {:ok, user}
    end
  end
end
