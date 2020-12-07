defmodule Computer do

  defp get(0, position, _, data), do: Enum.at(data, position)
  defp get(1, value, _, _), do: value
  defp get(2, position, rel_base, data), do: Enum.at(data, rel_base + position)

  def run(idx, rel_base, data, input, output) do
    inst = Enum.at(data, idx)
    opcode = rem(inst, 100)
    modes = div(inst, 100) |> Integer.digits() |> Enum.reverse()

    process(opcode, rel_base, modes, idx, Enum.slice(data, idx + 1, 3), data, input, output)
  end

  defp process(1, rel_base, modes, idx, [x, y, pos | _], data, input, output) do  # Opcode 1 - Add
    l = get(Enum.at(modes, 0, 0), x, rel_base, data)
    r = get(Enum.at(modes, 1, 0), y, rel_base, data)
    position = if Enum.at(modes, 2, 0) == 2, do: rel_base + pos, else: pos
    run(idx + 4, rel_base, List.replace_at(data, position, l+r), input, output)
  end

  defp process(2, rel_base, modes, idx, [x, y, pos | _], data, input, output) do  # Opcode 2 - Multiply
    l = get(Enum.at(modes, 0, 0), x, rel_base, data)
    r = get(Enum.at(modes, 1, 0), y, rel_base, data)
    position = if Enum.at(modes, 2, 0) == 2, do: rel_base + pos, else: pos
    run(idx + 4, rel_base, List.replace_at(data, position, l*r), input, output)
  end

  defp process(3, rel_base, modes, idx, [pos | _], data, input, output) do  # Opcode 3 - read input
    val = if Enum.at(modes, 0, 0) == 2, do: rel_base + pos, else: pos
    run(idx + 2, rel_base, List.replace_at(data, val, hd(input)), tl(input), output)
  end

  defp process(4, rel_base, modes, idx, [pos | _], data, input, output) do  # Opcode 4 - write output
    val = if Enum.at(modes, 0, 0) == 2, do: rel_base + pos, else: pos
    run(idx + 2, rel_base, data, input, output ++ [Enum.at(data, val)])
  end

  defp process(5, rel_base, modes, idx, [x, pos | _], data, input, output) do  # Opcode 5 - jump-if-true
    val = get(Enum.at(modes, 0, 0), x, rel_base, data)
    next_pos = if val != 0, do: get(Enum.at(modes, 1, 0), pos, rel_base, data), else: idx + 3
    run(next_pos, rel_base, data, input, output)
  end

  defp process(6, rel_base, modes, idx, [x, pos | _], data, input, output) do  # Opcode 6 - jump-if-false
    val = get(Enum.at(modes, 0, 0), x, rel_base, data)
    next_pos = if val == 0, do: get(Enum.at(modes, 1, 0), pos, rel_base, data), else: idx + 3
    run(next_pos, rel_base, data, input, output)
  end

  defp process(7, rel_base, modes, idx, [x, y, pos | _], data, input, output) do  # Opcode 7 - less than
    l = get(Enum.at(modes, 0, 0), x, rel_base, data)
    r = get(Enum.at(modes, 1, 0), y, rel_base, data)
    val = if l < r, do: 1, else: 0
    position = if Enum.at(modes, 2, 0) == 2, do: rel_base + pos, else: pos
    run(idx + 4, rel_base, List.replace_at(data, position, val), input, output)
  end

  defp process(8, rel_base,  modes, idx, [x, y, pos | _], data, input, output) do  # Opcode 8 - equals
    l = get(Enum.at(modes, 0, 0), x, rel_base, data)
    r = get(Enum.at(modes, 1, 0), y, rel_base, data)
    val = if l == r, do: 1, else: 0
    position = if Enum.at(modes, 2, 0) == 2, do: rel_base + pos, else: pos
    run(idx + 4, rel_base, List.replace_at(data, position, val), input, output)
  end

  defp process(9, rel_base, modes, idx, [pos | _], data, input, output) do  # Opcode 9 - Move relative base
    offset = get(Enum.at(modes, 0, 0), pos, rel_base, data)
    run(idx + 2, rel_base + offset, data, input, output)
  end

  defp process(99, _, _, _, _, data, _, output), do: {:ok, %{data: data, output: output}}  # Opcode 99 - Halt
  
  defp process(_, _, _, idx, _, data, _, _), do: {:error, idx, data}
end