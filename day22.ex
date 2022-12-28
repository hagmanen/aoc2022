defmodule Day22 do
  def input do
    [maze, path] = File.read!("input22.txt")
    |> String.split("\n\n")
    {parseMaze(maze), parsePath(path)}
  end

  def parseMaze(text) do
    text
    |> String.split("\n")
    |> Enum.with_index
    |> Enum.reduce(Map.new, fn x, a -> parseRow(x, a) end)
  end
  def parseRow({text, row}, maze) do
    text
    |> to_charlist
    |> Enum.with_index
    |> Enum.reduce(maze, fn x, a -> parseCoord(x, row, a) end)
  end
  def choose(true, a, _), do: a
  def choose(_, _, a), do: a
  def parseCoord({?\s,_}, _, maze), do: maze
  def parseCoord({?.,col}, row, maze), do: Map.put(maze, {row, col}, :open)
  def parseCoord({?#,col}, row, maze), do: Map.put(maze, {row, col}, :wall)
  def parsePath(text) do
    weave(parseNumbers(text), parseRotations(text))
  end
  def parseNumbers(text) do
    text
    |> String.split(["R", "L"])
    |> Enum.map(&String.to_integer/1)
  end
  def parseRotations(text) do
    text
    |> to_charlist
    |> Enum.filter(fn c -> c == ?R || c == ?L end)
    |> Enum.map(fn c -> choose(c==?R, :right, :left) end)
  end
  def weave([n], []), do: [n]
  def weave([n|ns], [r|rs]), do: [n|[r|weave(ns, rs)]]

  def score(:right), do: 0
  def score(:down), do: 1
  def score(:left), do: 2
  def score(:up), do: 3
  def score({r, c}, d), do: ((r+1) * 1000) + ((c+1)*4) + score(d)

  def solve1({maze, path}, wrapper), do: solve(path, {firstOpen(0, maze), :right}, maze, wrapper)
  def solve([], {pos, dir}, _, _), do: score(pos, dir)
  def solve([i|is], {c, d}, maze, wrapper) do
    cond do
      i == :right || i == :left -> solve(is, {c, rotate(d, i)}, maze, wrapper)
      i == 0 -> solve(is, {c, d}, maze, wrapper)
      true -> solve([i-1|is], step({c, d}, maze, wrapper), maze, wrapper)
    end
  end

  def firstOpen(col, maze) do
    case Map.get(maze, {0,col}, :void) == :open do
      true -> {0,col}
      false -> firstOpen(col+1, maze)
    end
  end
  def space(maze, cor), do: Map.get(maze, cor, :void)
  def step(:right, {r,c}), do: {{r, c+1}, :right}
  def step(:left, {r,c}), do: {{r, c-1}, :left}
  def step(:down, {r,c}), do: {{r+1, c}, :down}
  def step(:up, {r,c}), do: {{r-1, c}, :up}
  def step(pos, maze, wrapper) do
    {c, d} = doStep1(pos, maze, wrapper)
    case space(maze, c) do
      :wall -> pos
      _ -> {c, d}
    end
  end
  def doStep1({cor, dir}, maze, wrapper) do
    {c, d} = step(dir, cor)
    case Map.has_key?(maze, c) do
      true -> {c, d}
      false -> wrapper.(cor, dir, maze)
    end
  end

  def secret({_, col}, :up) do
    cond do
      col < 50 -> {{50 + col, 50}, :right}
      col < 100 -> {{100 + col, 0}, :right}
      true -> {{199, col - 100}, :up}
    end
  end
  def secret({row, _}, :right) do
    cond do
      row < 50 -> {{149 - row, 99}, :left}
      row < 100 -> {{49, 50 + row}, :up}
      row < 150 -> {{149 - row, 149}, :left}
      true -> {{149, row - 100}, :up}
    end
  end
  def secret({_, col}, :down) do
    cond do
      col < 50 -> {{0, col + 100}, :down}
      col < 100 -> {{100 + col, 49}, :left}
      true -> {{col - 50, 99}, :left}
    end
  end
  def secret({row, _}, :left) do
    cond do
      row < 50 -> {{149 - row, 0}, :right}
      row < 100 -> {{100, row - 50}, :down}
      row < 150 -> {{149 - row, 50}, :right}
      true -> {{0, row - 100}, :down}
    end
  end

  def goToLast(dir, cor, maze) do
    {c, d} = step(dir, cor)
    case Map.has_key?(maze, c) do
      true -> goToLast(d, c, maze)
      false -> cor
    end
  end

  def rotate(:right, :right), do: :down
  def rotate(:down, :right), do: :left
  def rotate(:left, :right), do: :up
  def rotate(:up, :right), do: :right
  def rotate(:right, :left), do: :up
  def rotate(:down, :left), do: :right
  def rotate(:left, :left), do: :down
  def rotate(:up, :left), do: :left
  def turnAround(:right), do: :left
  def turnAround(:left), do: :right
  def turnAround(:down), do: :up
  def turnAround(:up), do: :down
  
  def part1(cor, dir, maze), do: {goToLast(turnAround(dir), cor, maze), dir}
  def part2(cor, dir, _), do: secret(cor, dir)

  def main do
    IO.inspect(solve1(input(), &part1/3))
    IO.inspect(solve1(input(), &part2/3))
  end
end

# 165094
# 95316