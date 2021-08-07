defmodule Flightex.Bookings.CreateOrUpdateTest do
  use ExUnit.Case, async: false

  alias Flightex.Bookings.Agent, as: BookingAgent
  alias Flightex.Bookings.CreateOrUpdate, as: UpsertBooking
  alias Flightex.Users.Agent, as: UserAgent

  import Flightex.Factory

  describe "call/1" do
    setup do
      Flightex.start_agents()

      {_ok, %Flightex.Users.User{id: id}} =
        :users
        |> build()
        |> UserAgent.save()

      {:ok, user_id: id}
    end

    test "when all params are valid, returns a valid tuple", %{user_id: user_id} do
      params = %{
        complete_date: ~N[2001-05-07 03:05:00],
        local_origin: "Brasilia",
        local_destination: "Bananeiras",
        user_id: user_id
      }

      {:ok, uuid} = UpsertBooking.call(params)

      {:ok, response} = BookingAgent.get(uuid)

      expected_response = %Flightex.Bookings.Booking{
        id: response.id,
        complete_date: ~N[2001-05-07 03:05:00],
        local_destination: "Bananeiras",
        local_origin: "Brasilia",
        user_id: user_id
      }

      assert response == expected_response
    end
  end
end
