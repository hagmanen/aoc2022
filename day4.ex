defmodule Day4 do
  def input do
    File.read!("input4.txt")
    |> String.split("\n")
    |> Enum.map(&parseLine/1)
  end
  def parseLine(line) do
    r = line
    |> String.split(",")
    |> Enum.map(&parseRange/1)
    {Enum.at(r, 0), Enum.at(r, 1)}
  end
  def parseRange(range) do
    ns = range
    |> String.split("-")
    |> Enum.map(&String.to_integer/1)
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

# 534
# 841