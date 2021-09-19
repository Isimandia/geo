defmodule Joffer.Process.Update do
  use GenServer
  alias Joffer.DbOperations.JobOffers

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{})
  end

  @impl true
  def init(state) do
    schedule_work()
    {:ok, state}
  end

  @impl true
  def handle_info(:work, _state) do
    init_form()
    schedule_work()
    {:noreply, nil}
  end

  def init_form do
    if JobOffers.update_regions() == :ok do
      Joffer.DbOperations.Aggregates.fill_table!()
      form_file()
    end
  end

  defp schedule_work() do
    Process.send_after(self(), :work, 60 * 60 * 1000)
  end

  defp form_file() do
    fetch_data()
    |> CSV.encode()
    |> Stream.into(
      File.stream!(
        Path.join([
          Application.fetch_env!(:joffer, :file_dir),
          "aggregates.csv"
        ]),
        [:write, :utf8]
      )
    )
    |> Stream.run()

    :ok
  end

  @spec fetch_data :: list()
  defp fetch_data() do
    data = Joffer.DbOperations.Aggregates.select_all_aggregates()

    grouped_by_category =
      data
      |> Enum.group_by(fn x -> x.job_category.name end, fn x ->
        {x.continent_id, x.continent.name, x.amount}
      end)

    grouped_by_continent =
      data
      |> Enum.group_by(fn x -> x.continent.name end, fn x ->
        {x.job_category.name, x.amount}
      end)

    {header, {total, subtotals}} =
      grouped_by_category
      |> Enum.map_reduce({0, %{}}, fn {category, details}, {total, mapsubtotal} ->
        subtotal = Enum.reduce(details, 0, fn {_, _, x}, acc -> x + acc end)
        {category, {total + subtotal, Map.merge(%{category => subtotal}, mapsubtotal)}}
      end)

    body =
      grouped_by_continent
      |> Enum.map(fn {continent, details} ->
        total = Enum.reduce(details, 0, fn {_, x}, acc -> x + acc end)

        [continent, total] ++
          Enum.map(header, fn x ->
            case Enum.find(details, nil, fn
                   {^x, _} -> true
                   _ -> false
                 end) do
              nil -> 0
              {_, a} -> a
            end
          end)
      end)

    [
      ["", "Total"] ++ header,
      ["Total", total] ++ Enum.map(header, fn category -> Map.fetch!(subtotals, category) end)
    ] ++
      body
  end
end
