defmodule Rinhabackend.Repo do
  use Ecto.Repo,
    otp_app: :rinhabackend,
    adapter: Ecto.Adapters.Postgres
end
