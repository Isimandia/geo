defmodule Joffer.Api do
  def get_destinations(latitude, longitude, radius) do
    file_form =
      Path.join([
        Application.fetch_env!(:joffer, :file_dir),
        "api result.csv"
      ])

    Joffer.DbOperations.JobOffers.get_destinations(latitude, longitude, radius)
    |> Enum.map(
      &[&1.name, elem(&1.office_point.coordinates, 0), elem(&1.office_point.coordinates, 1)]
    )
    |> add_header(latitude, longitude, radius)
    |> CSV.encode()
    |> Stream.into(File.stream!(file_form, [:write, :utf8]))
    |> Stream.run()

    IO.puts("Output file #{file_form} is formed")
  end

  defp add_header(list, latitude, longitude, radius) do
    [["", "longitude: #{longitude}", "latitude: #{latitude}", "radius: #{radius}"]] ++ list
  end
end
