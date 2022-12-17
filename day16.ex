defmodule Day16 do
  def input do
    File.read!("input16.txt")
    |> String.split("\n")
    |> Enum.map(&parseLine/1)
    |> Map.new()
  end
  def parseLine([_,valve,_,_,_,rate,_,_,_,_|valves]), do: {valve, {String.to_integer(rate), valves}}
  def parseLine(text) do
    text
    |> String.split([" ", ",", ";", "="], trim: true)
    |> parseLine()
  end

  def do_move(_, _, _, 0, released, trail), do: {released, trail}
  def do_move(pos, map, open, left, released, trail) do
    Map.fetch!(map, pos)
    |> elem(1)
    |> Enum.reduce({0,trail}, fn p, {r, a} -> do_solve(p, map, open, left-1, released, a, r) end)
  end
  def do_solve(pos, map, open, left, released, trail, best) do
    #IO.inspect({pos, left, released, trail, best})
    {r,t} = solve(pos, map, open, left, released, trail)
    case r > best do
      true -> {r,t}
      false -> {best, trail}
    end
  end

#  def better(trail, pos, current) do
#    case Map.fetch(trail, pos) do
#      :error -> false
#      {_, rel} -> current > rel
#    end
#  end

  def release(pos, map, left) do
    rate(pos, map) * left
  end

  def do_open(pos, map, open, left, released, trail) do
    do_move(pos, map, MapSet.put(open, pos), left - 1, (released + release(pos, map, left)), trail)
  end

  def do_open_and_move(pos, map, open, left, released, trail) do
    {r1, t1} = do_open(pos, map, open, left, released, trail)
    {r2, t2} = do_move(pos, map, open, left, released, t1)
    case r1 > r2 do
      true -> {r1, t1}
      false -> {r2, t2}
    end
  end

  def rate(pos, map) do
    Map.fetch!(map, pos)
    |> elem(0)
  end

  def have_seen_better(pos, released, trail) do
    case Map.fetch(trail, pos) do
      :error -> false
      {:ok, r} -> r > released
    end
  end

  def solve(_, _, _, 0, released, trail), do: {released, trail}
  def solve(pos, map, open, left, released, trail) do
    t = Map.put(trail, pos, released)
    case {MapSet.member?(open, pos), have_seen_better(pos, released, trail)} do
      {_, true} -> {0, t}
      {true, _} -> do_move(pos, map, open, left, released, t)
      _ -> do_open_and_move(pos, map, open, left, released, t)
    end
  end

  def openBroken(map) do
    map
    |> Enum.filter(fn {_, {r,_}} -> r == 0 end)
    |> Enum.map(fn {v,_} -> v end)
    |> MapSet.new()
  end

  def main do
    map = input()
    IO.inspect(solve("AA", map, openBroken(map), 30, 0, Map.new()))
  end
end

# sample 1651
# 
# 
