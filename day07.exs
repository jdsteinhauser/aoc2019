defmodule Computer do

  defp get(0, position, data), do: Enum.at(data, position)
  defp get(1, value, _), do: value

  def run(idx, data, input, output) do
  
    inst = Enum.at(data, idx)
    opcode = rem(inst, 100)
    modes = div(inst, 100) |> Integer.digits() |> Enum.reverse()

    process(opcode, modes, idx, Enum.slice(data, idx + 1, 3), data, input, output)
  end

  defp process(1, modes, idx, [x, y, pos | _], data, input, output) do  # Opcode 1 - Add
    l = get(Enum.at(modes, 0, 0), x, data)
    r = get(Enum.at(modes, 1, 0), y, data)
    run(idx + 4, List.replace_at(data, pos, l+r), input, output)
  end

  defp process(2, modes, idx, [x, y, pos | _], data, input, output) do  # Opcode 2 - Multiply
    l = get(Enum.at(modes, 0, 0), x, data)
    r = get(Enum.at(modes, 1, 0), y, data)
    run(idx + 4, List.replace_at(data, pos, l*r), input, output)
  end

  defp process(3, _modes, idx, [pos | _], data, input, output) do  # Opcode 3 - read input
    run(idx + 2, List.replace_at(data, pos, hd(input)), tl(input), output)
  end

  defp process(4, _modes, idx, [pos | _], data, input, output) do  # Opcode 4 - write output
    run(idx + 2, data, input, output ++ [Enum.at(data, pos)])
  end

  defp process(5, modes, idx, [x, pos | _], data, input, output) do  # Opcode 5 - jump-if-true
    val = get(Enum.at(modes, 0, 0), x, data)
    next_pos = if val != 0, do: get(Enum.at(modes, 1, 0), pos, data), else: idx + 3
    run(next_pos, data, input, output)
  end

  defp process(6, modes, idx, [x, pos | _], data, input, output) do  # Opcode 6 - jump-if-false
    val = get(Enum.at(modes, 0, 0), x, data)
    next_pos = if val == 0, do: get(Enum.at(modes, 1, 0), pos, data), else: idx + 3
    run(next_pos, data, input, output)
  end

  defp process(7, modes, idx, [x, y, pos | _], data, input, output) do  # Opcode 7 - less than
    l = get(Enum.at(modes, 0, 0), x, data)
    r = get(Enum.at(modes, 1, 0), y, data)
    val = if l < r, do: 1, else: 0
    run(idx + 4, List.replace_at(data, pos, val), input, output)
  end

  defp process(8, modes, idx, [x, y, pos | _], data, input, output) do  # Opcode 8 - equals
    l = get(Enum.at(modes, 0, 0), x, data)
    r = get(Enum.at(modes, 1, 0), y, data)
    val = if l == r, do: 1, else: 0
    run(idx + 4, List.replace_at(data, pos, val), input, output)
  end

  defp process(99, _, _, _, data, _, output), do: {:ok, %{data: data, output: output}}  # Opcode 99 - Halt
  
  defp process(_, _, idx, _, data, _, _), do: {:error, idx, data}
end

datums = File.read!("day07.txt") |> String.trim() |> String.split(",") |> Enum.map(&String.to_integer/1)

run_amps = fn 
  _f, _data, [], output -> output
  f, data, [x | rest], output ->
    {:ok, %{:output => [forward | _]}} = Computer.run(0, data, [x, output], [])
    f.(f, data, rest, forward)
end

permutations = fn
  _f, [] -> [[]]
  f, list -> for x <- list, rest <- f.(f, list -- [x]), do: [x | rest]
end

ans1 = 
  permutations.(permutations, [0,1,2,3,4]) |>
  Enum.map(fn x -> run_amps.(run_amps, datums, x, 0) end) |>
  Enum.max()

IO.puts "Answer 1: #{inspect ans1}"