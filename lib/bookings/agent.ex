defmodule Flightex.Bookings.Agent do
  @moduledoc ~S"""
  Provides a set of functions to save and get Booking structs in an Agent.
  """

  use Agent

  alias Flightex.Bookings.Booking

  @doc ~S"""
  Starts an Agent process attached to the module name.

  ### Examples
      iex> Flightex.Bookings.Agent.start_link(%{})
      {:ok, #PID<0.248.0>}

      iex> Flightex.Bookings.Agent.start_link(%{})
      {:error, {:already_started, #PID<0.248.0>}}
  """
  @spec start_link(any()) :: {:ok, pid()} | {:error, any()}
  def start_link(%{}) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  @doc ~S"""
  Saves a Booking struct in the Agent, if a Booking with the given id
  already exists, overrides it.

  ### Examples
      iex> Flightex.Bookings.Agent.save(booking)
      {:ok, "1c9d8e2b-f69a-45bb-bf05-39ee14bd8f35"}
  """
  @spec save(Booking.t()) :: {:ok, String.t()}
  def save(%Booking{id: uuid} = booking) do
    Agent.update(__MODULE__, fn current_state -> update_state(current_state, booking) end)

    {:ok, uuid}
  end

  @doc ~S"""
  Try to find a Booking struct in the Agent's current state

  ### Examples
      iex> Flightex.Bookings.Agent.get("1c9d8e2b-f69a-45bb-bf05-39ee14bd8f35")
      {:ok,
        %Flightex.Bookings.Booking{
          complete_date: ~N[2021-08-07 15:38:32],
          id: "1c9d8e2b-f69a-45bb-bf05-39ee14bd8f35",
          local_destination: "There",
          local_origin: "Here",
          user_id: "12345678-1234-4321-123456789012"
        }}

      iex> Flightex.Users.Agent.get("00000000-0004-4000-0000-000000000000")
      {:error, "Booking not found"}
  """
  @spec get(String.t()) :: {:ok, Booking.t()} | {:error, String.t()}
  def get(uuid),
    do: Agent.get(__MODULE__, fn current_state -> get_booking(current_state, uuid) end)

  @doc ~S"""
  Returns a map with all registered Booking structs. If there are no Booking structs
  returns an empty map.

  ### Examples
      iex> Flightex.Bookings.Agent.get_all() # Have a Booking
      %{
        "1c9d8e2b-f69a-45bb-bf05-39ee14bd8f35" => %Flightex.Bookings.Booking{
          complete_date: ~N[2021-08-07 15:38:32],
          id: "1c9d8e2b-f69a-45bb-bf05-39ee14bd8f35",
          local_destination: "There",
          local_origin: "Here",
          user_id: "12345678-1234-4321-123456789012"
        }
      }

      iex> Flightex.Bookings.Agent.get_all() # Haven't a Booking
      %{}
  """
  @spec get_all :: %{String.t() => Booking.t()}
  def get_all, do: Agent.get(__MODULE__, fn current_state -> current_state end)

  defp update_state(current_state, %Booking{id: uuid} = booking) do
    Map.put(current_state, uuid, booking)
  end

  defp get_booking(current_state, uuid) do
    case Map.get(current_state, uuid) do
      nil -> {:error, "Booking not found"}
      booking -> {:ok, booking}
    end
  end
end
