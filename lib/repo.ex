defmodule Joffer.Repo do
  use Ecto.Repo,
    otp_app: :joffer,
    adapter: Ecto.Adapters.Postgres
end
