defmodule Day22 do
  def input do
    [maze, path] = File.read!("input22.txt")
    |> String.split("\n\n")
    {parseMaze(maze), parsePath(path)}
  end

  def choose(true, a, _), do: a
  def choose(_, _, a), do: a
  def maxLength(text) do
    text
    |> String.split("\n")
    |> Enum.reduce(0, fn l, m -> choose(String.length(l) > m, String.length(l), m) end)
  end
  def parseMaze(text) do
    max = maxLength(text)
    text
    |> String.split("\n")
    |> Enum.map(fn x -> toSpace(x, max) end)
  end
  def toSpace(?\s), do: :void
  def toSpace(?.), do: :open
  def toSpace(?#), do: :wall
  def toSpace(text, max) do
    text
    |> String.pad_trailing(max, " ")
    |> to_charlist
    |> Enum.map(&toSpace/1)
  end
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
  def score({{r, c}, d}), do: ((r+1) * 1000) + ((c+1)*4) + score(d)
  def solve1({m, i}), do: solve(i, {{0, firstOpen(Enum.at(m,0), 0)}, :right}, m, {Enum.count(m), Enum.count(Enum.at(m,0))})
  def solve([], p, _, _), do: score(p)
  def solve([i|is], {{r,c}, d}, maze, max) do
#    IO.inspect({i, {{r,c}, d}})
    cond do
      i == :right || i == :left -> solve(is, {{r,c}, rotate(d, i)}, maze, max)
      i == 0 -> solve(is, {{r,c}, d}, maze, max)
      true -> solve([i-1|is], {step({r,c}, d, maze, max), d}, maze, max)
    end
  end

  def firstOpen([:open|_], i), do: i
  def firstOpen([_|ss], i), do: firstOpen(ss, i+1)
  def space(m, r, c), do: Enum.at(Enum.at(m,r),c)
  def isVoid(m, r, c), do: Enum.at(Enum.at(m,r),c) == :void
  def isWall(m, r, c), do: Enum.at(Enum.at(m,r),c) == :wall
  def step({r,c}, d, maze, max) do
#    IO.inspect({{r,c}, d})
    {nr, nc, w} = doStep(d, {r,c}, maze, max)
    choose(w == :wall, {r,c}, {nr, nc})
  end
  def doStep(d, {r,c}, maze, max) do
#    IO.inspect({d, {r,c}})
    {nr, nc} = doStep1(d, {r,c}, max)
    ns = space(maze, nr, nc)
#    IO.inspect({d, {r,c}, ns, {nr, nc}})
    case ns == :void do
      true -> doStep(d, {nr,nc}, maze, max)
      false -> {nr, nc, ns}
    end
  end
  def doStep1(:right, {r,c}, max), do: rotate({r, c+1}, max)
  def doStep1(:left, {r,c}, max), do: rotate({r, c-1}, max)
  def doStep1(:down, {r,c}, max), do: rotate({r+1, c}, max)
  def doStep1(:up, {r,c}, max), do: rotate({r-1, c}, max)
  def rotate({r,c}, {mr, mc}) do
    cond do
      r == -1 -> {mr+r,c}
      r == mr -> {0,c}
      c == -1 -> {r,mc+c}
      c == mc -> {r,0}
      true -> {r,c}
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
  def main do
    solve1(input())
  end
end

# 165094
# 