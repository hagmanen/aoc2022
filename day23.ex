defmodule Day23 do
  def input do
    File.read!("input23.txt")
    |> String.split("\n")
    |> Enum.with_index
    |> Enum.reduce(MapSet.new, fn {l,i}, a -> parseLine(l, i, a) end)
  end
  def parseLine(text, row, elfs) do
    text
    |> to_charlist
    |> Enum.with_index
    |> Enum.filter(fn {c,_} -> c == ?# end)
    |> Enum.reduce(elfs, fn {_,col}, acc -> MapSet.put(acc, {row, col}) end)
  end

  def solve(elfs, _, 0), do: score(elfs)
  def solve(elfs, [dir|dirs], c) do
    news = doRound(elfs, [dir|dirs])
    case news == elfs do
      true -> -c
      false -> solve(news, dirs ++ [dir], c - 1)
    end
  end
  def minmax({r,c}, {minR, maxR, minC, maxC}) do
    {min(minR, r), max(maxR, r), min(minC, c), max(maxC, c)}
  end
  def minmax(elfs) do
    elfs
    |> Enum.reduce({1000,-1000,1000,-1000}, fn elf, mm -> minmax(elf, mm) end)
  end
  def score(elfs) do
    {minR, maxR, minC, maxC} = minmax(elfs)
    ((maxR-minR+1) * (maxC-minC+1)) - Enum.count(elfs)
  end

  def suggestedMoves(elfs, dirs) do
    elfs
    |> Enum.reduce(Map.new, fn elf, sugs -> suggestedMove(elf, elfs, dirs, sugs) end)
  end
  def suggestedMove(elf, elfs, [d1,d2,d3,d4], sugs) do
    neigbours = getNeigbours(elf, elfs)
    cond do
      neigbours == [] -> Map.put(sugs, elf, [elf|Map.get(sugs,elf,[])])
      canMove(d1, neigbours) -> Map.put(sugs, move(d1, elf), [elf|Map.get(sugs,move(d1, elf),[])])
      canMove(d2, neigbours) -> Map.put(sugs, move(d2, elf), [elf|Map.get(sugs,move(d2, elf),[])])
      canMove(d3, neigbours) -> Map.put(sugs, move(d3, elf), [elf|Map.get(sugs,move(d3, elf),[])])
      canMove(d4, neigbours) -> Map.put(sugs, move(d4, elf), [elf|Map.get(sugs,move(d4, elf),[])])
      true -> Map.put(sugs, elf, [elf|Map.get(sugs,elf,[])])
    end
  end
  def canMove(_, []), do: true
  def canMove(:north, [:north|_]), do: false
  def canMove(:north, [_|negs]), do: canMove(:north, negs)
  def canMove(:south, [:south|_]), do: false
  def canMove(:south, [_|negs]), do: canMove(:south, negs)
  def canMove(:west, [:west|_]), do: false
  def canMove(:west, [_|negs]), do: canMove(:west, negs)
  def canMove(:east, [:east|_]), do: false
  def canMove(:east, [_|negs]), do: canMove(:east, negs)

  def getNeigbours({r,c}, elfs) do
    [{{r-1,c-1},[:north,:west]},
     {{r-1,c}, [:north]},
     {{r-1,c+1}, [:north, :east]},
     {{r,c-1},[:west]},
     {{r,c+1},[:east]},
     {{r+1,c-1}, [:south, :west]},
     {{r+1,c},[:south]},
     {{r+1,c+1}, [:south, :east]}]
    |> Enum.filter(fn {c, _} -> MapSet.member?(elfs, c) end)
    |> Enum.map(fn x -> elem(x,1) end)
    |> List.flatten
    |> Enum.uniq
  end
  def move(:north, {row, col}), do: {row-1, col}
  def move(:south, {row, col}), do: {row+1, col}
  def move(:west, {row, col}), do: {row, col-1}
  def move(:east, {row, col}), do: {row, col+1}
  def doRound(elfs, dirs) do
    suggestedMoves(elfs, dirs)
    |> Enum.reduce(MapSet.new, fn sm, acc -> newPos(sm, acc) end)
  end
  def newPos({pos, [_]}, elfs), do: MapSet.put(elfs, pos)
  def newPos({_, failed}, elfs), do: MapSet.union(MapSet.new(failed), elfs)

  def main do
    IO.inspect(solve(input(), [:north, :south, :west, :east], 10))
    IO.inspect(solve(input(), [:north, :south, :west, :east], -1))
  end
end

# 3864
# 946