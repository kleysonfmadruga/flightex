defmodule Flightex.Bookings.CreateOrUpdate do
  @moduledoc ~S"""
  Provides a function to facilitate the Booking struct creation
  and saving in the Agent.
  """

  alias Flightex.Bookings.Agent, as: BookingAgent
  alias Flightex.Bookings.Booking
  alias Flightex.Users.Agent, as: UserAgent

  @doc ~S"""
  Try to create a Booking struct and save in the Agent.
  If there are no registered users with the given user_id, returns
  an error.

  ### Examples
      iex> booking_data = %{
      ...> complete_date: ~N[2021-08-07 17:48:38],
      ...> local_origin: "Here",
      ...> local_destination: "There",
      ...> user_id: "38950f88-af39-4e53-980b-93a6eea89081"}
      iex> Flightex.Bookings.CreateOrUpdate.call(booking_data)
      {:ok, "03e18053-f7a5-4c83-a3d8-5327b5bcca3e"}

      iex> booking_data = %{
      ...> complete_date: ~N[2021-08-07 17:48:38],
      ...> local_origin: "Here",
      ...> local_destination: "There",
      ...> user_id: "00000000-0000-4000-0000-000000000000"}
      iex> Flightex.Bookings.CreateOrUpdate.call(booking_data)
      {:error, "User not found"}
  """
  @spec call(%{
          complete_date: NaiveDateTime.t(),
          local_origin: String.t(),
          local_destination: String.t(),
          user_id: String.t()
        }) :: {:ok, String.t()} | {:error, String.t()}
  def call(%{
        complete_date: complete_date,
        local_origin: origin,
        local_destination: destination,
        user_id: user_id
      }) do
    case UserAgent.get(user_id) do
      {:ok, _user} ->
        complete_date
        |> Booking.build(origin, destination, user_id)
        |> BookingAgent.save()

      error ->
        error
    end
  end
end
