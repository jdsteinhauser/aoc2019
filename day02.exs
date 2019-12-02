run = fn f, position, data ->
  case Enum.slice(data, position .. position+3) do
  [1, x, y, loc] -> f.(f, (position + 4), List.replace_at(data, loc, Enum.at(data, x) + Enum.at(data, y)))
  [2, x, y, loc] -> f.(f, (position + 4), List.replace_at(data, loc, Enum.at(data, x) * Enum.at(data, y)))
  [99 | _] -> {:ok, data}
  _ -> {:error, data}
  end
end

datums = File.read!("day02.txt") |> String.trim() |> String.split(",") |> Enum.map(&String.to_integer/1)
modified_data = 
  datums |>
  List.replace_at(1, 12) |>
  List.replace_at(2, 2)

{:ok, [ans1 | _ ] } = run.(run, 0, modified_data)

IO.puts "Answer 1: #{ans1}"