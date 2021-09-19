defmodule Joffer.Process.ChunkOffer do
  alias Joffer.DbOperations.JobOffers
  alias Joffer.DbOperations.ContractTypes
  require Logger
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, %{})
  end

  @impl true
  def init(_state) do
    {:ok, nil}
  end

  @impl true
  def handle_call({:run, chunk, professions}, _from, nil) do
    task = Task.async(fn -> upload_chunk_offers(chunk, professions) end)
    {:reply, :ok, task}
  end

  def handle_call({:run, chunk, professions}, _from, old_task) do
    Task.await(old_task)
    task = Task.async(fn -> upload_chunk_offers(chunk, professions) end)
    {:reply, :ok, task}
  end

  @impl true
  def handle_info({_, :ok}, _state) do
    {:noreply, nil}
  end

  def handle_info(_, _state) do
    {:noreply, nil}
  end

  def upload_chunk_offers(data, profs) do
    data
    |> Enum.reduce(%{}, fn
      ["" | x], acc ->
        Logger.error("Profession_id is empty for #{x}")
        acc

      [_, "" | x], acc ->
        Logger.error("Contract type is empty for #{x}")
        acc

      [_, _, "" | x], acc ->
        Logger.error("name is empty for #{x}")
        acc

      [_, _, name, "", _], acc ->
        Logger.error("office_latitude is empty for #{name}")
        acc

      [_, _, name, _, ""], acc ->
        Logger.error("office_longitude is empty for #{name}")
        acc

      [
        external_prof_id,
        contract_type_name,
        name,
        office_latitude,
        office_longitude
      ],
      acc ->
        prof_id = Map.fetch!(profs, external_prof_id)

        point = %Geo.Point{
          coordinates: {String.to_float(office_longitude), String.to_float(office_latitude)},
          srid: 4326
        }

        case Map.fetch(acc, contract_type_name) do
          {:ok, contract_type_id} ->
            JobOffers.insert!(%{
              name: name,
              contract_type_id: contract_type_id,
              profession_id: prof_id,
              office_point: point
            })

            acc

          :error ->
            contract_type = ContractTypes.insert!(%{name: contract_type_name})

            JobOffers.insert!(%{
              name: name,
              contract_type_id: contract_type.id,
              profession_id: prof_id,
              office_point: point
            })

            Map.merge(%{contract_type_name => contract_type.id}, acc)
        end
    end)

    :ok
  end
end
