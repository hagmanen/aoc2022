defmodule Day14 do
  @start {500,0}
  def input do
    File.read!("input14.txt")
    |> String.split("\n")
    |> Enum.map(&parseLines/1)
    |> List.flatten
    |> MapSet.new
  end

  def parseLines(text) do
    text
    |> String.split(" -> ")
    |> Enum.map(&parseCoords/1)
    |> linesToCoords
  end
  def linesToCoords([{_, _}]), do: []
  def linesToCoords([{x1,y1}|[{x2,y2}|ts]]) do
    for x <- x1..x2 do
      for y <- y1..y2, do: {x, y}
    end
    ++ linesToCoords([{x2,y2}|ts])
  end
  def parseCoords(text) do
    [x,y] = String.split(text, ",")
    {String.to_integer(x), String.to_integer(y)}
  end

  def flow(map, {x,y}) do
    cond do
      !MapSet.member?(map, {x-1,y}) -> dropGrain(map, {x-1,y})
      !MapSet.member?(map, {x+1,y}) -> dropGrain(map, {x+1,y})
      true -> {x, y-1}
    end
  end

  def dropGrain(map, {fx,fy}) do
    candidates = map
    |> Enum.filter(fn {x,y} -> fx == x && y > fy end) 
    if candidates == [] do
      []
    else
      pos = Enum.min_by(candidates, fn {_,y} -> y end)
      flow(map, pos)
    end
  end

  def solve(map, count) do
    case dropGrain(map, @start) do
      [] -> count
      @start -> count + 1
      p -> solve(MapSet.put(map, p), count + 1)
    end
  end

  def lowest(map) do
    map
    |> MapSet.to_list
    |> Enum.map(fn {_,y} -> y end)
    |> Enum.max()
  end

  def addFloor(map, level) do
     MapSet.union(map, MapSet.new(for x <- 500-level-1..500+level+1, do: {x,level}))
  end

  def main do
    map = input()
    IO.inspect(solve(map, 0))
    IO.inspect(solve(addFloor(map, lowest(map) + 2), 0))
  end
end

# 1133
# 120 low 27565 low