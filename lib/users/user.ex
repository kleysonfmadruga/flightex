defmodule Flightex.Users.User do
  @moduledoc ~S"""
  User is a struct that represents an user that have
  a name, an email and a CPF in the Flightex application.
  """

  @keys [:name, :email, :cpf, :id]
  @enforce_keys @keys
  defstruct @keys

  @type t :: %__MODULE__{name: String.t(), email: String.t(), cpf: String.t(), id: String.t()}

  @doc ~S"""
  Builds an User struct with the given name, email and CPF
  or returns an `:error` if the CPF isn't a bistring

  ### Examples
      iex> User.build("Joseph", "jo@example.com", "12345678900")
      {:ok,
        %Flightex.Users.User{
          cpf: "12345678900",
          email: "jo@example.com",
          id: "aa28423e-20f1-4623-9bad-515167460759",
          name: "Joseph"
      }}

      iex> User.build("Joseph", "jo@example.com", 12_345_678_900)
      {:error, "Cpf must be a String"}
  """
  @spec build(String.t(), String.t(), String.t()) :: {:ok, __MODULE__.t()} | {:error, String.t()}
  def build(name, email, cpf) when is_bitstring(cpf) do
    uuid = UUID.uuid4()

    {
      :ok,
      %__MODULE__{
        id: uuid,
        cpf: cpf,
        name: name,
        email: email
      }
    }
  end

  def build(_name, _email, _cpf), do: {:error, "Cpf must be a String"}
end
