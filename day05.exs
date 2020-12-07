datums = File.read!("day05.txt") |> String.trim() |> String.split(",") |> Enum.map(&String.to_integer/1)

get_value = fn
  0, position, data -> Enum.at(data, position)
  1, value, _ -> value
end

run = fn f, idx, data, input, output ->
  inst = Enum.at(data, idx)
  opcode = rem(inst, 100)
  modes = div(inst, 100) |> Integer.digits() |> Enum.reverse()
  case {opcode, Enum.slice(data, idx + 1, 3)} do
    # Opcode 1 - Add
    {1, [x, y, pos | _]} -> f.(f, idx + 4, List.replace_at(data, pos, get_value.(Enum.at(modes, 0, 0), x, data) + get_value.(Enum.at(modes, 1, 0), y, data)), input, output)
    # Opcode 2 - Multiply
    {2, [x, y, pos | _]} -> f.(f, idx + 4, List.replace_at(data, pos, get_value.(Enum.at(modes, 0, 0), x, data) * get_value.(Enum.at(modes, 1, 0), y, data)), input, output)
    # Opcode 3 - read input
    {3, [pos | _]} -> f.(f, idx + 2, List.replace_at(data, pos, hd(input)), tl(input), output)
    # Opcode 4 - write output
    {4, [pos | _]} -> f.(f, idx + 2, data, input, output ++ [Enum.at(data, pos)])
    # Opcode 5 - jump-if-true
    {5, [x, pos | _]} -> f.(f, (if get_value.(Enum.at(modes, 0, 0), x, data) != 0, do: get_value.(Enum.at(modes, 1, 0), pos, data), else: idx + 3), data, input, output)
    # Opcode 6 - jump-if-false
    {6, [x, pos | _]} -> f.(f, (if get_value.(Enum.at(modes, 0, 0), x, data) === 0, do: get_value.(Enum.at(modes, 1, 0), pos, data), else: idx + 3), data, input, output)
    # Opcode 7 - less than
    {7, [x, y, pos | _]} -> f.(f, idx + 4, List.replace_at(data, pos, (if get_value.(Enum.at(modes, 0, 0), x, data) < get_value.(Enum.at(modes, 1, 0), y, data), do: 1, else: 0)), input, output)
    # Opcode 8 - equals
    {8, [x, y, pos | _]} -> f.(f, idx + 4, List.replace_at(data, pos, (if get_value.(Enum.at(modes, 0, 0), x, data) === get_value.(Enum.at(modes, 1, 0), y, data), do: 1, else: 0)), input, output)
    # Opcde 99 - Halt
    {99, _} -> {:ok, %{data: data, output: output}}
    _ -> {:error, idx, data}
  end
end

ans1 = run.(run, 0, datums, [1], [])
IO.inspect ans1

ans2 = run.(run, 0, datums, [5], [])
IO.inspect ans2
