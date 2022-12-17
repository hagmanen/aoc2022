defmodule Day17 do
  def input do
    File.read!("input17.txt")
    |> to_charlist
    |> Enum.map(&parseWind/1)
  end

  def parseWind(?<), do: :left
  def parseWind(?>), do: :right

  def occupy(:rock1, {x,y}), do: [{x,y},{x+1,y},{x+2,y},{x+3,y}]
  def occupy(:rock2, {x,y}), do: [{x+1,y},{x+1,y+1},{x+1,y+2},{x,y+1},{x+2,y+1}]
  def occupy(:rock3, {x,y}), do: [{x,y},{x+1,y},{x+2,y},{x+2,y+1},{x+2,y+2}]
  def occupy(:rock4, {x,y}), do: [{x,y},{x,y+1},{x,y+2},{x,y+3}]
  def occupy(:rock5, {x,y}), do: [{x,y},{x+1,y},{x,y+1},{x+1,y+1}]

  def hight(:rock1), do: 1
  def hight(:rock2), do: 3
  def hight(:rock3), do: 3
  def hight(:rock4), do: 4
  def hight(:rock5), do: 2

  def collide({x,y}, room) do
    cond do
      x == -1 -> true
      x == 7 -> true
      true -> MapSet.member?(room, {x,y})
    end
  end
  def noCollide(rock, room, pos) do
    occupy(rock, pos)
    |> Enum.filter(fn c -> collide(c, room) end)
    |> Enum.empty?()
  end
  def rotate(l,i), do: rem(i+1, Enum.count(l))
  def getRocks, do: [:rock1, :rock2, :rock3, :rock4, :rock5]

  def blow({x,y}, :left), do: {x-1,y}
  def blow({x,y}, :right), do: {x+1,y}
  def blow(rock, pos, room, dir) do
    pos2 = blow(pos, dir)
    case noCollide(rock, room, pos2) do
      true -> pos2
      _ -> pos
    end
  end

  def fall(rock, pos, room, wind, windi) do
    windi2 = rotate(wind, windi)
    {x,y} = blow(rock, pos, room, Enum.at(wind, windi))
    case noCollide(rock, room, {x, y-1}) do
      true -> fall(rock, {x, y-1}, room, wind, windi2)
      _ -> {{x,y}, windi2}
    end
  end

  def drop(hight, _, _, _, _, _, 0), do: hight
  def drop(hight, rocks, room, wind, index, is, count) do
    case Map.fetch(is, index) do
      :error -> normalDrop(hight, rocks, room, wind, index, Map.put(is, index, {hight, count, false}), count)
      {:ok, {_,_,false}} -> normalDrop(hight, rocks, room, wind, index, Map.put(is, index, {hight, count, true}), count)
      {:ok, {h,c,_}} -> shortcut(hight, rocks, room, wind, index, Map.new, count, h, c)
    end
  end
  def shortcut(h, rocks, room, wind, index, is, c, oh, oc) do
    restCount = rem(c, oc-c)
    factor = div(c, oc-c)
    deltaHight = h-oh
    restHight = normalDrop(h, rocks, room, wind, index, is, restCount)
    restHight  + (deltaHight * factor)
  end
  def normalDrop(hight, rocks, room, wind, index, is, count) do
    rocki = rotate(rocks, elem(index, 0))
    rock = Enum.at(rocks, elem(index, 0))
    {{x,y}, windi} = fall(rock, {2, hight+3}, room, wind, elem(index, 1))
    hight2 = max(hight, y + hight(rock))
    room2 = MapSet.union(room, MapSet.new(occupy(rock, {x,y})))
    drop(hight2, rocks, room2, wind, {rocki, windi}, is, count-1)
  end

  def main do
    wind = input()
    rocks = getRocks()
    floor = MapSet.new([{0,-1}, {1,-1}, {2,-1}, {3,-1}, {4,-1}, {5,-1}, {6,-1}])
    IO.inspect(drop(0, rocks, floor, wind, {0,0}, Map.new(), 2022))
    IO.inspect(drop(0, rocks, floor, wind, {0,0}, Map.new(), 1000000000000))
  end
end

# 3239
# 1594842406882