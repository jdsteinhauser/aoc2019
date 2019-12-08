data = File.read!("day08.txt") |> String.to_integer() |> Integer.digits

layers = Enum.chunk_every(data, 25 * 6)

min_zeroes = Enum.min_by(layers, fn x -> Enum.count(x, &(&1 == 0)) end)

ans1 = Enum.count(min_zeroes, &(&1 == 1)) * Enum.count(min_zeroes, &(&1 == 2))

Enum.reduce(layers, List.duplicate(2, 25 * 6),
    fn x, acc ->
        Enum.zip(acc, x) |>
        Enum.map (fn {l,r} -> if l == 2, do: r, else: l end) end)
