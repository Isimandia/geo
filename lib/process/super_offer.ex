defmodule Joffer.Process.SuperOffer do
  use Supervisor

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def start_child(opts) do
    Supervisor.start_child(__MODULE__, opts)
  end

  def process_chunk(chunk, professions) do
    {_, child, _, _} =
      Supervisor.which_children(Joffer.Process.SuperOffer)
      |> Enum.random()

    GenServer.call(child, {:run, chunk, professions})
  end

  @impl true
  def init(_init_arg) do
    children = [
      %{id: :up_1, start: {Joffer.Process.ChunkOffer, :start_link, []}},
      %{id: :up_2, start: {Joffer.Process.ChunkOffer, :start_link, []}},
      %{id: :up_3, start: {Joffer.Process.ChunkOffer, :start_link, []}}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
