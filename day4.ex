defmodule Day4 do
  def input do
    for line <- String.split(File.read!("input4.txt"), "\n"), do: parseLine(line)
  end
  def parseLine(line) do
    r = for range <- String.split(line, ","), do: parseRange(range)
    {Enum.at(r, 0), Enum.at(r, 1)}
  end
  def parseRange(range) do
    ns = for n <- String.split(range, "-"), do: String.to_integer(n)
    {Enum.at(ns, 0), Enum.at(ns, 1)}
  end

  def contained({{a,b}, {c,d}}) do
    cond do
      a >= c && b <= d -> true
      true -> false
    end
  end

  def overlap({{a,b}, {c,d}}) do
    cond do
      a >= c && a <= d -> true
      b >= c && b <= d -> true
      true -> false
    end
  end

  def solve(inp, fun) do
     Enum.count(for {a,b} <- inp, fun.({a,b}) || fun.({b,a}), do: 1)
  end

  def main do
    IO.inspect(solve(input(), &contained/1))
    IO.inspect(solve(input(), &overlap/1))
  end
end