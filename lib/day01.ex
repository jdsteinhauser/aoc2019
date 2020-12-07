defmodule Day1 do

  def part1 do
    data()
    |> Enum.map(&fuel_required/1)
    |> Enum.sum()
  end

  def part2 do
    data()
    |> Enum.map(&fuel_required_cumulative/1)
    |> Enum.sum()
  end
    
  def fuel_required(mass), do: Integer.floor_div(mass, 3) - 2
  
  def fuel_required_cumulative(mass) do 
    mass
    |> Stream.iterate(&fuel_required/1)
    |> Enum.take_while(&(&1 > 0))
    |> tl()
    |> Enum.sum()
    end

  def data do
    "day01.txt"
    |> File.stream!()
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1)
  end
end
