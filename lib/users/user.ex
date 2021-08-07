defmodule Flightex.Users.User do
  @moduledoc ~S"""
  User is a struct that represents an user that have
  a name, an email and a CPF in the Flightex application.
  """

  @keys [:name, :email, :cpf, :id]
  @enforce_keys @keys
  defstruct @keys

  def build do
    # TO DO
  end
end
