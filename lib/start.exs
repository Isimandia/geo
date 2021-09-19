Supervisor.which_children(Joffer.Supervisor)
|> Enum.find(nil, fn {a, _, _, _} -> a == Joffer.Process.Upload end)
|> elem(1)
|> GenServer.call(:run)
