defmodule Flightex.Bookings.Report do
  @moduledoc ~S"""
  Provides a function to generate a CSV report file containing
  the Booking structs registered in the Booking's Agent
  """

  alias Flightex.Bookings.Agent, as: BookingAgent
  alias Flightex.Bookings.Booking

  @doc ~S"""
  Generates a CSV file with the registered Bookings

  ### Examples
      iex> Flightex.Bookings.Report.generate()
      :ok # Generates a file named "report.csv"

      iex> Flightex.Bookings.Report.generate("foo_report.csv")
      :ok # Generates a file named "foo_report.csv"
  """
  @spec generate(String.t()) :: :ok | {:error, atom()}
  def generate(filename \\ "report.csv") do
    booking_list =
      BookingAgent.get_all()
      |> Map.values()
      |> Enum.map(fn booking -> handle_bookings(booking) end)

    File.write(filename, booking_list)
  end

  defp handle_bookings(%Booking{
        complete_date: booking_date,
        local_destination: destination,
        local_origin: origin,
        user_id: user_id
      }) do
    "#{user_id},#{origin},#{destination},#{booking_date}\n"
  end
end
