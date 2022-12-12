defmodule Day12 do
  def input do
    File.read!("input12.txt")
    |> String.split("\n")
    |> to_charlist
    |> initialState
  end

  def initialState(map) do
    w = String.length(Enum.at(map,0))
    s = Enum.join(map)
    {start,_} = :binary.match s, "S"
    {goal,_} = :binary.match s, "E"
    s1 = String.replace(s, "S", "a")
    s2 = String.replace(s1, "E", "z")
    map1 = Enum.chunk_every(to_charlist(s2), w)
    {map1, {div(start, w), rem(start, w)}, {div(goal, w), rem(goal, w)}, Map.new()}
  end

  def hight(map, {y, x}) do
    map
    |> Enum.at(y)
    |> Enum.at(x)
  end

  def nextSteps(map, {y, x}, dist, visited) do
    w = Enum.count(Enum.at(map,0))
    h = Enum.count(map)
    [{y+1, x}, {y-1, x}, {y, x+1}, {y, x-1}]
    |> Enum.filter(fn {a, b} ->
      cond do
        a < 0 -> false
        b < 0 -> false
        a >= h -> false
        b >= w -> false
        ((hight(map, {y, x})+1) < hight(map, {a, b})) -> false
        (Map.get(visited, {a, b}, dist+1) <= dist) -> false
        true -> true
      end
    end)
  end

  def addToMap(map, [], _), do: map
  def addToMap(map, [c|cs], dist), do: addToMap(Map.put(map, c, dist), cs, dist)

  def processCoords(_, [], _, _), do: []
  def processCoords(map, [c|cs], dist, visited) do
    nextSteps(map, c, dist, visited) ++ processCoords(map, cs, dist, visited)
  end

  def step(_, [], _, _, visited), do: visited
  def step(map, coords, goal, dist, visited) do
    vis = addToMap(visited, coords, dist)
    next_coords = Enum.uniq(processCoords(map, coords, dist, vis))
    step(map, next_coords, goal, dist+1, vis)
  end

  def findAs(map) do
    w = Enum.count(Enum.at(map,0))
    map
    |> Enum.join
    |> to_string
    |> :binary.matches("a")
    |> Enum.map(fn {p,_} -> {div(p, w), rem(p, w)} end)
  end

  def part2(map, goal, visited, max_dist) do
    findAs(map)
    |> Enum.map(fn s -> Map.get(step(map, [s], goal, 0, visited), goal, max_dist) end)
    |> Enum.min
  end

  def main do
    {map, start, goal, visited} = input()
    dist = Map.get(step(map, [start], goal, 0, visited), goal)
    IO.inspect(dist)
    IO.inspect(part2(map, goal, visited, dist))
  end
end

# 352
# 345
