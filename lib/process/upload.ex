defmodule Joffer.Process.Upload do
  use GenServer
  alias Joffer.DbOperations.Professions
  alias Joffer.DbOperations.JobCategories
  alias Joffer.DbOperations.Professions

  @file_job "technical-test-jobs"
  @file_prof "technical-test-professions"
  @chunk_size 100

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{})
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call(:run, _from, _state) do
    Process.send(self(), :prof, [:noconnect])
    {:reply, :ok, :ok}
  end

  @impl true
  def handle_info({:offers, profs}, state) do
    dir = Application.fetch_env!(:joffer, :file_dir)

    IO.puts("Start processing job offers")

    file_offers =
      Path.join([
        dir,
        "technical-test-jobs.csv"
      ])

    if File.exists?(file_offers) do
      upload_offers(file_offers, profs)
    else
      IO.puts("#{@file_job}.csv file doesn't exist in #{dir}. Jobs won't be loaded")
    end

    {:noreply, state}
  end

  def handle_info(:prof, _state) do
    dir = Application.fetch_env!(:joffer, :file_dir)

    file_professions =
      Path.join([
        dir,
        "technical-test-professions.csv"
      ])

    profs =
      if File.exists?(file_professions) do
        {ids, _} = upload_professions(file_professions)

        # File.rename!(
        #   file_professions,
        #   Path.join([
        #     dir,
        #     "#{@file_prof}(processed - #{Ecto.UUID.generate()}).csv"
        #   ])
        # )

        # rely on file data
        ids
      else
        IO.puts("#{@file_prof}.csv file doesn't exist in #{dir}. Professions won't be loaded")
        # try to fetch persistent data
        Professions.get_all_id()
      end

    Process.send(self(), {:offers, profs}, [:noconnect])
    {:noreply, profs}
  end

  defp upload_professions(file_path) do
    file_path
    |> File.stream!()
    |> CSV.decode!()
    |> Stream.drop(1)
    |> Enum.reduce(
      {%{}, %{}},
      fn [id, name, category_name], {result, acc} ->
        case Map.fetch(acc, category_name) do
          {:ok, category_id} ->
            {%{
               id =>
                 Professions.insert!(%{
                   external_id: id,
                   name: name,
                   job_category_id: category_id
                 }).id
             }
             |> Map.merge(result), acc}

          :error ->
            category = JobCategories.insert!(%{name: category_name})

            {%{
               id =>
                 Professions.insert!(%{
                   external_id: id,
                   name: name,
                   job_category_id: category.id
                 }).id
             }
             |> Map.merge(result), Map.merge(%{category_name => category.id}, acc)}
        end
      end
    )
  end

  defp upload_offers(file_path, profs) do
    {acc, counter} =
      file_path
      |> File.stream!()
      |> CSV.decode!()
      |> Stream.drop(1)
      |> Enum.reduce({[], 0}, fn
        _x, {acc, counter} when counter == @chunk_size ->
          Joffer.Process.SuperOffer.process_chunk(acc, profs)
          {[], 0}

        x, {acc, counter} ->
          {[x] ++ acc, counter + 1}
      end)

    if counter > 0 do
      Joffer.Process.SuperOffer.process_chunk(acc, profs)
    end

    Joffer.Process.Update.init_form()
  end
end
