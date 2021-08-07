# Este teste é opcional, mas vale a pena tentar e se desafiar 😉
defmodule Flightex.Bookings.ReportTest do
  use ExUnit.Case, async: true

  import Flightex.Factory

  alias Flightex.Bookings.Report
  alias Flightex.Users.Agent, as: UserAgent

  describe "generate/1" do
    setup do
      Flightex.start_agents()

      {_ok, %Flightex.Users.User{id: id}} =
        :users
        |> build()
        |> UserAgent.save()

      {:ok, user_id: id}
    end

    test "when called, return the content", %{user_id: user_id} do
      params = %{
        complete_date: ~N[2001-05-07 12:00:00],
        local_origin: "Brasilia",
        local_destination: "Bananeiras",
        user_id: user_id,
        id: UUID.uuid4()
      }

      content = "#{user_id},Brasilia,Bananeiras,2001-05-07 12:00:00\n"

      Flightex.create_or_update_booking(params)

      Report.generate("report-test.csv")

      {:ok, file} = File.read("report-test.csv")
      assert file =~ content
    end
  end
end
