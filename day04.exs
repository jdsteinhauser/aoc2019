input = 245182..790572

possible? = fn num ->
  digits = Integer.digits(num)
  digits == Enum.sort(digits) &&
    length(digits) > length(Enum.uniq(digits))
end

ans1 = Enum.count(input, &(possible?.(&1)))

possible2? = fn num ->
  groups = Enum.group_by(Integer.digits(num), &(&1))
  Enum.any?(groups, fn {_,x} -> length(x) == 2 end)
end

ans2 = input |> Enum.filter(&(possible?.(&1))) |> Enum.count(&(possible2?.(&1)))