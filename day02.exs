run = fn f, position, data ->
  case Enum.slice(data, position .. position+3) do
  [1, x, y, loc] -> f.(f, (position + 4), List.replace_at(data, loc, Enum.at(data, x) + Enum.at(data, y)))
  [2, x, y, loc] -> f.(f, (position + 4), List.replace_at(data, loc, Enum.at(data, x) * Enum.at(data, y)))
  [99 | _] -> {:ok, data}
  _ -> {:error, data}
  end
end

datums = File.read!("day02.txt") |> String.trim() |> String.split(",") |> Enum.map(&String.to_integer/1)

modify_init_positions = fn data, x, y ->
  data |>
  List.replace_at(1, x) |>
  List.replace_at(2, y)
end

{:ok, [ans1 | _ ] } = run.(run, 0, modify_init_positions.(datums, 12, 2))

IO.puts "Answer 1: #{ans1}"

ans2_ =
for x <- 0..99, y <- 0..99 do
  case run.(run, 0, modify_init_positions.(datums, x, y)) do
    {:error, _ } -> :error
    {:ok, [19690720 | _]} -> x * 100 + y
    _ -> :nope
  end
end

ans2 = Enum.find(ans2_, &is_integer/1)

IO.puts "Answer 2: #{ans2}"
