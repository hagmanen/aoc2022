defmodule Day24 do
  def input do
    rows = File.read!("input24.txt")
    |> String.split("\n")
    {mr, mc} = {Enum.count(rows)-1, String.length(Enum.at(rows, 0))-1}
    maze = rows
    |> Enum.with_index
    |> Enum.map(fn {l, r} -> parseRow(l, r, mr) end)
    |> List.flatten
    |> Enum.concat([{{-1, 1}, :wall}, {{mr+1, mc-1}, :wall}])
    {Map.new(maze), {mr, mc}}
  end
  def parseRow(text, row, mr) do
    text
    |> to_charlist
    |> Enum.with_index
    |> Enum.map(fn {c, col} -> parseSpace(c, row, col, mr == row) end)
    |> Enum.filter(fn {_, i} -> i != [] end)
  end
  def parseSpace(?., row, col, true), do: {{row,col}, []}
  def parseSpace(?., 0, col, _), do: {{0,col}, []}
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

  def solve(mazes, pos, goal, nm, c, visited, best) do
    cond do
      c >= best - dist(pos, goal) -> {visited, best}
      MapSet.member?(visited, key(pos, nm, c)) -> {visited, best}
      pos == goal -> {visited, c}
      true -> visitAll(mazes, pos, goal, nm, c+1, MapSet.put(visited, key(pos, nm, c)), best)
    end
  end

  def dist({a,b}, {c,d}), do: (abs(a-c) + abs(b-d))
  def key(pos, nm, c), do: {pos, rem(c, nm)}

  def visitAll(mazes, pos, goal, nm, c, visited, best) do
    possibleMoves(Enum.at(mazes, rem(c,nm)), pos, goal)
    |> Enum.reduce({visited, best}, fn new_pos, {new_visited, new_best} -> solve(mazes, new_pos, goal, nm, c, new_visited, new_best) end)
  end

  def possibleMoves(maze, {row, col}, goal) do
    [{row-1, col}, {row, col + 1}, {row, col-1}, {row+1, col}, {row, col}]
    |> Enum.filter(fn p -> not Map.has_key?(maze, p) end)
    |> Enum.sort_by(fn p -> dist(p,goal) end)
  end

  def main do
    {maze, {mr,mc}} = input()
    mazes = findCycle(maze, {mr,mc}, MapSet.new, [])
    first = elem(solve(mazes, {0,1}, {mr,mc-1}, Enum.count(mazes), 0, MapSet.new, 50000), 1)
    IO.inspect(first)
    second = elem(solve(mazes, {mr,mc-1}, {0,1}, Enum.count(mazes), first, MapSet.new, 50000), 1)
    third = elem(solve(mazes, {0,1}, {mr,mc-1}, Enum.count(mazes), second, MapSet.new, 50000), 1)
    IO.inspect(third)
  end
end

Day24.main()
# 228
# 723