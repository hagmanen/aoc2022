defmodule Day16 do
  use Bitwise, only_operators: true
  def input do
    File.read!("input16.txt")
    |> String.split("\n")
    |> Enum.with_index
    |> Enum.map(&parseLine/1)
    |> optimize
  end
  def parseLine([_,valve,_,_,_,rate,_,_,_,_|valves], i), do: {valve, {String.to_integer(rate), i, valves}}
  def parseLine({text, i}) do
    text
    |> String.split([" ", ",", ";", "="], trim: true)
    |> parseLine(i)
  end

  def translate([],_), do: []
  def translate([v|vs], map), do: [elem(Map.fetch!(map, v), 1)|translate(vs, map)]
  def optimize({_, {rate, _, valves}}, map) do
    {rate, translate(valves, map)}
  end
  def optimize(map) do
    m = Map.new(map)
    {elem(Map.fetch!(m, "AA"), 1), Enum.map(map, fn r -> optimize(r, m) end)}
  end

  def do_move(pos, map, open, left, released, cache, nodes) do
    Enum.at(map, pos)
    |> elem(1)
    |> Enum.reduce({released, cache}, fn p, {r, c} -> do_solve(p, map, open, left-1, released, r, c, nodes) end)
  end
  def do_solve(pos, map, open, left, released, best, cache, nodes) do
    {r, c} = solve(pos, map, open, left, released, cache, nodes)
    case r > best do
      true -> {r, c}
      false -> {best, c}
    end
  end

  def release(pos, map, left) do
    rate(pos, map) * left
  end

  def do_open(pos, map, open, left, released, cache, nodes) do
    l = left-1
    r = released + release(pos, map, l)
    o = open(open, pos)
    solve(pos, map, o, l, r, cache, nodes)
  end

  def do_open_and_move(pos, map, open, left, released, cache, nodes) do
    {r1, c1} = do_open(pos, map, open, left, released, cache, nodes)
    {r2, c2} = do_move(pos, map, open, left, released, c1, nodes)
    case r1 > r2 do
      true -> {r1, c2}
      false -> {r2, c2}
    end
  end

  def rate(pos, map) do
    Enum.at(map, pos)
    |> elem(0)
  end

  def cacheKey(pos, nodes, open, left) do
    (open*nodes*31) + (pos*31) + left
  end

  def updateCache(cache, pos, nodes, open, left, released) do
    Map.put(cache, cacheKey(pos, nodes, open, left), released)
  end

  def allOpen(nodes) do
    (1 <<< nodes)-1
  end

  def solve(pos, _, open, 0, released, cache, nodes), do: {released, updateCache(cache, pos, nodes, open, 0, released)}
  def solve(pos, map, open, left, released, cache, nodes) do
    c = Map.fetch(cache, cacheKey(pos, nodes, open, left))
    cond do
      :error == c -> solvex(pos, map, open, left, released, updateCache(cache, pos, nodes, open, left, released), nodes)
      elem(c,1) >= released -> {released, cache}
      true -> solvex(pos, map, open, left, released, updateCache(cache, pos, nodes, open, left, released), nodes)
    end
  end
  def solvex(pos, map, open, left, released, cache, nodes) do
    cond do
      allOpen(nodes) == open -> {released, cache}
      isOpen(open, pos) -> do_move(pos, map, open, left, released, cache, nodes)
      true -> do_open_and_move(pos, map, open, left, released, cache, nodes)
    end
  end

  def open(open, pos), do: open + (1 <<< pos)
  def isOpen(open, pos), do: (open &&& (1 <<< pos)) == (1 <<< pos)

  def openBroken(map) do
    map
    |> Enum.with_index
    |> Enum.filter(fn {{r,_}, _} -> r == 0 end)
    |> Enum.reduce(0, fn {_, v}, a -> (1 <<< v) + a end)
  end

  def main do
    {start, map} = input()
    IO.inspect(elem(solve(start, map, openBroken(map), 30, 0, Map.new(), Enum.count(map)), 0))
  end
end

# 2080
# 
