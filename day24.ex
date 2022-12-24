#.#####
#.....#
#>....#
#.....#
#...v.#
#.....#
#####.#

defmodule Day24 do
  def input do
    rows = File.read!("input24.txt")
    |> String.split("\n")
    {mr, mc} = {Enum.count(rows)-1, String.length(Enum.at(rows, 0))-1}
    maze = rows
    |> Enum.with_index
    |> Enum.map(fn {l, r} -> parseRow(l, r, mr) end)
    |> List.flatten
    {Map.new(maze), {mr, mc}}
  end
  def parseRow(text, row, mr) do
    text
    |> to_charlist
    |> Enum.with_index
    |> Enum.map(fn {c, col} -> parseSpace(c, row, col, mr == row) end)
    |> Enum.filter(fn {_, i} -> i != [] end)
  end
  def parseSpace(?., row, col, true), do: {{row,col}, :goal}
  def parseSpace(?., 0, col, _), do: {{0,col}, [:santa]}
  def parseSpace(?., row, col, _), do: {{row,col}, []}
  def parseSpace(?#, row, col, _), do: {{row,col}, :wall}
  def parseSpace(?<, row, col, _), do: {{row,col}, [:left]}
  def parseSpace(?>, row, col, _), do: {{row,col}, [:right]}
  def parseSpace(?^, row, col, _), do: {{row,col}, [:up]}
  def parseSpace(?v, row, col, _), do: {{row,col}, [:down]}

  def blow(maze, {mr,mc}) do
    maze
    |> Enum.reduce(Map.new(), fn cell, acc -> blowCell(cell, acc, {mr,mc}) end)
  end
  def blowCell({cor, :goal}, maze, _), do: Map.put(maze, cor, :goal)
  def blowCell({cor, :wall}, maze, _), do: Map.put(maze, cor, :wall)
  def blowCell({_, []}, maze, _), do: maze
  def blowCell({cor, [s|ss]}, maze, mm) do
    blowCell({cor, ss}, blowItem(cor, s, maze, mm), mm)
  end
  def choose(true, a, _), do: a
  def choose(_, _, a), do: a

  def blowItem(cor, i, maze, mm) do
    pos = moveItem(cor, i, mm)
    items = Map.get(maze, pos)
    Map.put(maze, pos, addItem(items,i))
end
  def moveItem(cor, :santa, _), do: cor
  def moveItem({1,col}, :up, {mr,_}), do: {mr-1,col}
  def moveItem({row,col}, :up, _), do: {row-1,col}
  def moveItem({row,1}, :left, {_,mc}), do: {row,mc-1}
  def moveItem({row,col}, :left, _), do: {row,col-1}
  def moveItem({row,col}, :down, {mr,_}), do: {choose(row == mr-1, 1, row+1),col}
  def moveItem({row,col}, :right, {_,mc}), do: {row, choose(col == mc-1, 1, col+1)}

  def addItem(nil, item), do: [item] 
  def addItem(items, item), do: [item|items] 

  def findCycle(maze, mm, mazeSet, mazeList) do
    case MapSet.member?(mazeSet, maze) do
      true -> Enum.reverse(mazeList)
      false -> findCycle(blow(maze, mm), mm, MapSet.put(mazeSet, maze), [maze|mazeList])
    end
  end
  def main do
    {maze, mm} = input()
    cycle = findCycle(maze, mm, MapSet.new, [])
    IO.inspect(Enum.count(cycle))
  end
end

#
#