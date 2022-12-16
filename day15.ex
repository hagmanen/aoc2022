defmodule Day15 do
  def input do
    File.read!("input15.txt")
    |> String.split("\n")
    |> Enum.map(&parseSensor/1)
  end
  def parseSensor(text) do
    words = String.split(text, " ")
    {{parseNumber(Enum.at(words, 2)), parseNumber(Enum.at(words, 3))}, {parseNumber(Enum.at(words, 8)), parseNumber(Enum.at(words, 9))}}
  end
  def parseNumber(text) do
    text
    |> String.split(["=", ",", ":"])
    |> Enum.at(1)
    |> String.to_integer
  end

  def dist({x1,y1}, {x2,y2}), do: abs(x1-x2) + abs(y1-y2)
  def deltaX({x,y}, d, y0) do
    dy = abs(y-y0)
    case dy > d do
      true -> {}
      false -> {x-d+dy,x+d-dy}
    end
  end

  def removeBeacon({}, _, _, _), do: {}
  def removeBeacon(r, _, _, true), do: r
  def removeBeacon({x1, x2}, {bx, by}, y0, _) do
    cond do
      y0 != by -> {x1, x2}
      x1 == x2 == bx -> {}
      x1 == bx -> {x1+1, x2}
      x2 == bx -> {x1, x2-1}
      true -> {x1, x2}
    end
  end

  def noneBeacon({sen, bea}, y0, ib) do
    deltaX(sen, dist(sen,bea), y0)
    |> removeBeacon(bea, y0, ib)
  end

  def overlap({x1, x2}, {x3, x4}), do: !Range.disjoint?(x1..x2, x3..x4)
  def merge({x1, x2}, {x3, x4}), do: {min(x1,x3), max(x2,x4)}

  def addRange(rs,{}), do: rs
  def addRange([], ar), do: [ar]
  def addRange([r|rs], ar) do
    case overlap(r,ar) do
      true -> addRange(rs, merge(r,ar))
      false -> [r|addRange(rs, ar)]
    end
  end

  def solve1([], _, _), do: []
  def solve1([s|ss], y0, ib), do: addRange(solve1(ss, y0, ib), noneBeacon(s, y0, ib))

  def findX([{_, x2}, {x3, x4}]) do
    case x2 < x3 do
      true -> x2 + 1
      false -> x4 + 1
    end
  end

  def solve2(sensors, [y|ys], max) do
    rs = solve1(sensors, y, true)
    case Enum.count(rs) do
      1 -> solve2(sensors, ys, max)
      2 -> (findX(rs)*4000000)+y
    end
  end

  def count([]), do: 0
  def count([{x1,x2}|rs]) do
    1 + x2 - x1 + count(rs)
  end

  def main do
    IO.inspect(count(solve1(input(),2000000, false)))
    IO.inspect(solve2(input(),Enum.to_list(0..4000000), 4000000))
  end
end

# 6078701
# 12567351400528
