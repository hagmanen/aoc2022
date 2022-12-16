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
    |> Enum.map(fn p -> solve(p, map, open, left-1, released, [pos|trail]) end)
    |> Enum.max
  end

  def do_move_if_needed(pos, map, open, left, released, trail) do
    case Enum.count(map) == Enum.count(open) do
      true -> released
      false -> do_move(pos, map, open, left, released, trail)
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

  def repeated(_, 0), do: false
  def repeated(trail, i) do
    #IO.inspect({i, Enum.slice(trail, 0..i),Enum.slice(trail, i+1..(2*i)+1)})
    Enum.slice(trail, 0..i) == Enum.slice(trail, i+1..(2*i)+1)
  end

  def loopy([_]), do: false
  def loopy(trail), do: loopy(trail, Enum.to_list(0..div(Enum.count(trail),2)-1))
  def loopy(_, []), do: false
  def loopy(trail, [i|is]) do
    repeated(trail, i) || loopy(trail, is)
  end

  def solve(_, _, _, 0, released, _), do: released
  def solve(pos, map, open, left, released, trail) do
    case {loopy(trail), MapSet.member?(open, pos)} do
      {true,_} -> released
      {_,true} -> do_move(pos, map, open, left, released, trail)
      {_,false} -> max(do_open(pos, map, open, left, released, trail), do_move(pos, map, open, left, released, trail))
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
    IO.inspect(solve("AA", map, openBroken(map), 30, 0, ["AA"]))
  end
end

# 
# 
