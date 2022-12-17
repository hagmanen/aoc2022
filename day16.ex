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

  def do_move(_, _, _, 0, released, _), do: released
  def do_move(pos, map, open, left, released, trail) do
    Map.fetch!(map, pos)
    |> elem(1)
    |> Enum.map(fn p -> solve(p, map, open, left-1, released, trail) end)
    |> Enum.max
  end

  def better(trail, pos, current) do
    case Map.fetch(trail, pos) do
      :error -> false
      {_, rel} -> current > rel
    end
  end

  def do_move_if_needed(pos, map, open, left, released, trail) do
    case {better(trail, pos, released) ,Enum.count(map) == Enum.count(open)} do
      {_, true} -> released
      _ -> do_move(pos, map, open, left, released, Map.put(trail, pos, released))
    end
  end

  def release(pos, map, left) do
    rate(pos, map) * left
  end

  def do_open(pos, map, open, left, released, trail) do
    do_move_if_needed(pos, map, MapSet.put(open, pos), left - 1, (released + release(pos, map, left)), trail)
  end

  def rate(pos, map) do
    Map.fetch!(map, pos)
    |> elem(0)
  end

  def solve(_, _, _, 0, released, _), do: released
  def solve(pos, map, open, left, released, trail) do
    #no_open = do_move_if_needed(pos, map, open, left, released, trail)
    case MapSet.member?(open, pos) do
      true -> do_move_if_needed(pos, map, open, left, released, trail)
      false -> do_open(pos, map, open, left, released, trail) #max(do_open(pos, map, open, left, released, trail), no_open)
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
