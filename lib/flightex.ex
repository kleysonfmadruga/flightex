defmodule Flightex do
  @moduledoc """
  Provides a facade with a set of delegated functions to create,
  update and get User and Booking structs in the Flightex application.
  """

  alias Flightex.Bookings.Agent, as: BookingAgent
  alias Flightex.Bookings.Booking
  alias Flightex.Bookings.CreateOrUpdate, as: UpsertBooking
  alias Flightex.Bookings.Report, as: BookingReport
  alias Flightex.Users.Agent, as: UserAgent
  alias Flightex.Users.CreateOrUpdate, as: UpsertUser
  alias Flightex.Users.User

  @doc ~S"""
  Starts all application Agents.

  ### Examples
      iex> Flightex.start_agents()
      {:ok, #PID<0.248.0>}

      iex> Flightex.start_agentsk()
      {:error, {:already_started, #PID<0.248.0>}}
  """
  @spec start_agents :: {:ok, pid()} | {:error, any()}
  def start_agents do
    BookingAgent.start_link(%{})
    UserAgent.start_link(%{})
  end

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

      iex> Flightex.create_or_update_booking(booking_data)
      {:ok, "03e18053-f7a5-4c83-a3d8-5327b5bcca3e"}


      iex> booking_data = %{
      ...> complete_date: ~N[2021-08-07 17:48:38],
      ...> local_origin: "Here",
      ...> local_destination: "There",
      ...> user_id: "00000000-0000-4000-0000-000000000000"}

      iex> Flightex.create_or_update_booking(booking_data)
      {:error, "User not found"}
  """
  @spec create_or_update_booking(%{
          user_id: String.t(),
          complete_date: NaiveDateTime.t(),
          local_origin: String.t(),
          local_destination: String.t()
        }) :: {:ok, String.t()} | {:error, String.t()}
  defdelegate create_or_update_booking(booking_data), to: UpsertBooking, as: :call

  @doc ~S"""
  Try to create an User struct and save it in the Agent.

  ### Examples
      iex> user_data = %{name: "Joe", email: "joe@example.com", cpf: "12345678900"}
      iex> Flightex.create_or_update_user(user_data)
      {:ok,
        %Flightex.Users.User{
          cpf: "12345678900",
          email: "joe@example.com",
          id: "5e3ba51a-b3a6-4772-8afa-4826c164aee6",
          name: "Joe"
        }}

      iex> user_data = %{name: "Joe", email: "joe@example.com", cpf: 12_345_678_900}
      iex> Flightex.create_or_update_user(user_data)
      {:error, "Cpf must be a String"}
  """
  @spec create_or_update_user(%{
          name: String.t(),
          email: String.t(),
          cpf: String.t()
        }) :: {:ok, User.t()} | {:error, String.t()}
  defdelegate create_or_update_user(user_data), to: UpsertUser, as: :call

  @doc ~S"""
  Try to find a Booking struct in the Agent's current state.

  ### Examples
      iex> Flightex.get_booking("1c9d8e2b-f69a-45bb-bf05-39ee14bd8f35")
      {:ok,
        %Flightex.Bookings.Booking{
          complete_date: ~N[2021-08-07 15:38:32],
          id: "1c9d8e2b-f69a-45bb-bf05-39ee14bd8f35",
          local_destination: "There",
          local_origin: "Here",
          user_id: "12345678-1234-4321-123456789012"
        }}

      iex> Flightex.get_booking("00000000-0004-4000-0000-000000000000")
      {:error, "Booking not found"}
  """
  @spec get_booking(String.t()) :: {:ok, Booking.t()} | {:error, String.t()}
  defdelegate get_booking(booking_id), to: BookingAgent, as: :get

  @doc ~S"""
  Try to find an User struct in the Agent's current state.

  ### Examples
      iex> Flightex.get_user("b107c35e-f8e4-46bb-a2a8-6f4337b3ca38")
      {:ok,
        %Flightex.Users.User{
          cpf: "12345678900",
          email: "jp@banana.com",
          id: "b107c35e-f8e4-46bb-a2a8-6f4337b3ca38",
          name: "Jp"
        }}

      iex> Flightex.get_user("00000000-0004-4000-0000-000000000000")
      {:error, "User not found"}
  """
  @spec get_user(String.t()) :: {:ok, User.t()} | {:error, String.t()}
  defdelegate get_user(user_id), to: UserAgent, as: :get

  @doc ~S"""
  Generates a CSV file with the registered Bookings

  ### Examples
      iex> Flightex.generate_report()
      :ok # Generates a file named "report.csv"

      iex> Flightex.generate_report("foo_report.csv")
      :ok # Generates a file named "foo_report.csv"
  """
  @spec generate_report(String.t()) :: :ok | {:error, atom()}
  defdelegate generate_report(filename), to: BookingReport, as: :generate
end
