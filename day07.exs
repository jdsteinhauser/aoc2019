defmodule Computer do

  defp get_value(0, position, data), do: Enum.at(data, position)
  defp get_value(1, value, _), do: value

  def run(idx, data, input, output) do
  
    inst = Enum.at(data, idx)
    opcode = rem(inst, 100)
    modes = div(inst, 100) |> Integer.digits() |> Enum.reverse()
    
    case {opcode, Enum.slice(data, idx + 1, 3)} do
      # Opcode 1 - Add
      {1, [x, y, pos | _]} -> run(idx + 4, List.replace_at(data, pos, get_value(Enum.at(modes, 0, 0), x, data) + get_value(Enum.at(modes, 1, 0), y, data)), input, output)
      # Opcode 2 - Multiply
      {2, [x, y, pos | _]} -> run(idx + 4, List.replace_at(data, pos, get_value(Enum.at(modes, 0, 0), x, data) * get_value(Enum.at(modes, 1, 0), y, data)), input, output)
      # Opcode 3 - read input
      {3, [pos | _]} -> run(idx + 2, List.replace_at(data, pos, hd(input)), tl(input), output)
      # Opcode 4 - write output
      {4, [pos | _]} -> run(idx + 2, data, input, output ++ [Enum.at(data, pos)])
      # Opcode 5 - jump-if-true
      {5, [x, pos | _]} -> run((if get_value(Enum.at(modes, 0, 0), x, data) != 0, do: get_value(Enum.at(modes, 1, 0), pos, data), else: idx + 3), data, input, output)
      # Opcode 6 - jump-if-false
      {6, [x, pos | _]} -> run((if get_value(Enum.at(modes, 0, 0), x, data) === 0, do: get_value(Enum.at(modes, 1, 0), pos, data), else: idx + 3), data, input, output)
      # Opcode 7 - less than
      {7, [x, y, pos | _]} -> run(idx + 4, List.replace_at(data, pos, (if get_value(Enum.at(modes, 0, 0), x, data) < get_value(Enum.at(modes, 1, 0), y, data), do: 1, else: 0)), input, output)
      # Opcode 8 - equals
      {8, [x, y, pos | _]} -> run(idx + 4, List.replace_at(data, pos, (if get_value(Enum.at(modes, 0, 0), x, data) === get_value(Enum.at(modes, 1, 0), y, data), do: 1, else: 0)), input, output)
      # Opcde 99 - Halt
      {99, _} -> {:ok, %{data: data, output: output}}
      _ -> {:error, idx, data}
    end
  end
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