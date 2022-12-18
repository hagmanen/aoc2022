defmodule Day18 do
  def input do
    File.read!("input18.txt")
    |> String.split("\n")
    |> Enum.map(&parseDrop/1)
    |> MapSet.new
  end
  def parseDrop(text) do
    [x,y,z] = Enum.map(String.split(text, ","), &String.to_integer/1)
    {x,y,z}
  end

  def notIn(p, map) do
    not MapSet.member?(map, p)
  end
  def sides({x,y,z}, map) do
    [{x+1,y,z},{x-1,y,z},{x,y+1,z},{x,y-1,z},{x,y,z+1},{x,y,z-1}]
    |> Enum.filter(fn x -> notIn(x, map) end)
    |> Enum.count
  end

  def solve(map) do
    map
    |> Enum.reduce(0, fn x, a -> a + sides(x, map) end)
  end

  def minmax({x,y,z}, {{hx,hy,hz},{lx,ly,lz}}) do
    {{max(x,hx),max(y,hy),max(z,hz)}, {min(x,lx),min(y,ly),min(z,lz)}}
  end
  def minmax(map) do
    Enum.reduce(map, {{0,0,0},{100,100,100}}, fn p, a -> minmax(p, a) end)
  end

  def air({x,y,z}, map) do
    [{x+1,y,z},{x-1,y,z},{x,y+1,z},{x,y-1,z},{x,y,z+1},{x,y,z-1}]
    |> Enum.filter(fn x -> notIn(x, map) end)
  end
  def internalAir(map) do
    map
    |> Enum.map(fn p -> air(p, map) end)
    |> List.flatten
    |> Enum.uniq
    |> Enum.filter(fn p -> isInside({[p], MapSet.new()}, map, minmax(map)) end)
  end
  def isInside({[], _}, _,_), do: true
  def isInside({[{x,y,z}|as], visited}, map, {{hx,hy,hz},{lx,ly,lz}}) do
    cond do
      x > hx -> false
      x < lx -> false
      y > hy -> false
      y < ly -> false
      z > hz -> false
      z < lz -> false
      MapSet.member?(visited, {x,y,z}) -> isInside({as, visited}, map, {{hx,hy,hz},{lx,ly,lz}})
      true -> isInside(attachAir(as, {x,y,z}, map, visited), map, {{hx,hy,hz},{lx,ly,lz}})
    end
  end
  def attachAir(as, {x,y,z}, map, visited) do
    new_air = [{x+1,y,z},{x-1,y,z},{x,y+1,z},{x,y-1,z},{x,y,z+1},{x,y,z-1}]
    |> Enum.filter(fn p -> notIn(p, map) end)
    |> Enum.filter(fn p -> notIn(p, visited) end)
    {as ++ new_air, MapSet.put(visited, {x,y,z})}
  end
  def solve2(map) do
    new_map = internalSpace(map, internalAir(map))
    Enum.reduce(new_map, 0, fn x, a -> a + sides(x, new_map) end)
  end
  def internalSpace(map, []), do: map
  def internalSpace(map, air) do
    new_map = MapSet.union(map, MapSet.new(air))
    internalSpace(new_map, internalAir(new_map))
  end

  def main do
    IO.inspect(solve(input()))
    IO.inspect(solve2(input()))
  end
end

# 4390
# 2534