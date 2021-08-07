defmodule Flightex.Bookings.Booking do
  @moduledoc """
  Booking is a struct that represents an user booking that
  have a date, a place of origin, a destination and an user
  id in the Flightex application.
  """

  @keys [:complete_date, :local_origin, :local_destination, :user_id, :id]
  @enforce_keys @keys
  defstruct @keys

  @type t :: %__MODULE__{
          id: String.t(),
          complete_date: NaiveDateTime.t(),
          local_origin: String.t(),
          local_destination: String.t(),
          user_id: String.t()
        }

  @doc """
  Builds a Booking struct with the given date and time, place of origin,
  destination and user id.

  ### Examples
      iex> Flightex.Bookings.Booking.build(
      ...> ~N[2021-08-07 15:38:32],
      ...> "Here",
      ...> "There",
      ...> "12345678-1234-4321-123456789012")
      %Flightex.Bookings.Booking{
        complete_date: ~N[2021-08-07 15:38:32],
        id: "28d9cefa-6262-41b8-9ae9-ca0cc886c51f",
        local_destination: "There",
        local_origin: "Here",
        user_id: "12345678-1234-4321-123456789012"
      }
  """
  @spec build(NaiveDateTime.t(), String.t(), String.t(), String.t()) :: __MODULE__.t()
  def build(complete_date, local_origin, local_destination, user_id) do
    uuid = UUID.uuid4()

    %__MODULE__{
      id: uuid,
      complete_date: complete_date,
      local_origin: local_origin,
      local_destination: local_destination,
      user_id: user_id
    }
  end
end
