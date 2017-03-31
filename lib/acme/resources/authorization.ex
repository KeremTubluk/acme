defmodule Acme.Authorization do
  defstruct [:status, :identifier, :expires, :challenges]

  alias Acme.{Identifier, Challenge}

  def from_map(%{
    "expires" => expires,
    "identifier" => identifier,
    "status" => status,
    "challenges" => challenges
  }) do
    {:ok, expires_datetime, _} = DateTime.from_iso8601(expires)
    %__MODULE__{
      status: status,
      expires: expires_datetime,
      identifier: Identifier.from_json(identifier),
      challenges: Enum.map(challenges, &Challenge.from_map/1)
    }
  end

  @types [:http, "http", :dns, "dns"]
  def fetch_challenge(%__MODULE__{challenges: challenges}, type) do
    Enum.find(challenges, &(&1.type == to_string(type)))
  end
end