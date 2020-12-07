defmodule Day2 do

  def part1 do
    {:ok, [value | _ ] } = run(0, modify_init_positions(datums(), 12, 2))
    value
  end

  def part2 do
    for x <- 0..99, y <- 0..99 do
      case run(0, modify_init_positions(datums(), x, y)) do
        {:error, _ } -> :error
        {:ok, [19690720 | _]} -> x * 100 + y
        _ -> :nope
      end
    end
    |> Enum.find(&is_integer/1)
  end

  def run(position, data) do
    case Enum.slice(data, position .. position+3) do
    [1, x, y, loc] -> run((position + 4), List.replace_at(data, loc, Enum.at(data, x) + Enum.at(data, y)))
    [2, x, y, loc] -> run((position + 4), List.replace_at(data, loc, Enum.at(data, x) * Enum.at(data, y)))
    [99 | _] -> {:ok, data}
    _ -> {:error, data}
    end
  end

  def modify_init_positions(data, x, y) do
    data
    |> List.replace_at(1, x)
    |> List.replace_at(2, y)
  end

  def datums() do
    "day02.txt"
    |> File.read!()
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end
end