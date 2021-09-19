defmodule Joffer.Application do
  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Joffer.Repo,

      # Start file analysis
      Joffer.Process.Upload,
      Joffer.Process.SuperOffer,

      # Update Region information
      # Aggregate data
      Joffer.Process.Update
    ]

    opts = [strategy: :one_for_one, name: Joffer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def stop(_state) do
    Joffer.Repo.stop()
  end
end
