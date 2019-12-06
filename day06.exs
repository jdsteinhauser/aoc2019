datums = 
  File.stream!("day06.txt") |>
  Enum.map(&String.trim/1) |>
  Map.new(fn x -> 
    [parent, child | _] = String.split(x, ")")
    {child, parent}
  end)

dist = fn 
  _, {_, "COM"} -> 1
  f, {_, parent} -> 1 + f.(f, {parent, datums[parent]})
end

ans1 = datums |> Enum.map(&(dist.(dist, &1))) |> Enum.sum()
IO.puts "Answer 1: #{ans1}"

orbit_path = fn
  _, path, "COM" -> ["COM" | path]
  f, path, obj -> f.(f, [obj | path] , datums[obj])
end

you_path = MapSet.new(orbit_path.(orbit_path, [], "YOU"))
santa_path = MapSet.new(orbit_path.(orbit_path, [], "SAN"))

common = MapSet.intersection(you_path, santa_path)

ans2 = MapSet.size(you_path) + MapSet.size(santa_path) - MapSet.size(common) * 2 - 2 # Need to take YOU and SAN out of the path

IO.puts "Answer 2: #{ans2}"