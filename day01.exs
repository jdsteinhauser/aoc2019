fuel_required = fn mass -> Integer.floor_div(mass, 3) - 2 end
fuel_required_cumulative = fn mass -> 
  mass
  |> Stream.iterate(&(fuel_required.(&1)))
  |> Enum.take_while(&(&1 > 0))
  |> tl()
  |> Enum.sum()
  end

data = 
  File.stream!("day01.txt") |> 
  Enum.map(&String.trim/1) |> 
  Enum.map(&String.to_integer/1)

ans1 =
  data |> 
  Enum.map(&(fuel_required.(&1))) |> 
  Enum.sum()

# modified_weights = 
ans2 =
  data |>
  Enum.map(&(fuel_required_cumulative.(&1))) |> 
  Enum.sum()

# ans2 =
#   fuel_required_cumulative.(modified_weights)

IO.puts "Part 1: #{ans1}"
IO.puts "Part 2: #{ans2}"