directions = %{"U" => :up, "D" => :down, "L" => :left, "R" => :right}

parse_point = fn << direction::binary-size(1), count::binary >> ->
  { directions[direction], String.to_integer(count) }
end

create_line = fn
  {:up, d}, {x, y} -> for v <- 1..d, do: {x, y+v}
  {:down, d}, {x, y} -> for v <- 1..d, do: {x, y-v}
  {:right, d}, {x, y} -> for v <- 1..d, do: {x+v, y}
  {:left, d}, {x, y} -> for v <- 1..d, do: {x-v, y}
end

create_wire = fn
  _f, _origin, [], points -> points
  f, origin, [next | rest], points ->
    new_points = create_line.(next, origin)
    f.(f, List.last(new_points), rest, points ++ new_points)
end

[wire1, wire2 | _ ] =
  File.stream!("day03.txt") |>
  Enum.map(&String.trim/1) |> 
  Enum.map(&(String.split(&1, ","))) |>
  Enum.map(fn tokens -> (Enum.map(tokens, &(parse_point.(&1)))) end) |>
  Enum.map(&(create_wire.(create_wire, {0,0}, &1, [])))

intersections = MapSet.intersection(MapSet.new(wire1, &(&1)), MapSet.new(wire2, &(&1)))

ans1 = Enum.min_by(intersections, fn {x,y} -> abs(x) + abs(y) end)

IO.inspect ans1

inter_distances =
  Enum.zip(Enum.map(intersections, fn pt -> Enum.find_index(wire1, &(&1 == pt)) + 1 end),
           Enum.map(intersections, fn pt -> Enum.find_index(wire2, &(&1 == pt)) + 1 end))

ans2 = Enum.min_by(inter_distances, fn {x,y} -> x+y end)

IO.inspect ans2