defmodule Day3 do
  def input do
    File.read!("input3.txt")
    |> String.split("\n")
  end
  def mkpair(s) do
    len = String.length(s)
    half = div(len, 2)
    {to_charlist(String.slice(s, 0..half-1)), String.slice(s, half..len)}
  end
  def score({[], _}), do: 0
  def score({[x|xs], y}) do
    if (y =~ to_string([x])) do scoreC(x)
    else score({xs, y})
    end
  end
  def scoreC(c) do
    if (c >= ?a && c <= ?z) do c + 1 - ?a
    else c + 27 - ?A
    end
  end

  def solve(d) do
    Enum.sum(for s <- d, do: score(s))
  end

  def groupScore([a, b, c]) do
    MapSet.intersection(MapSet.new(a), MapSet.new(b))
    |> MapSet.intersection(MapSet.new(c))
    |> MapSet.to_list
    |> List.first
    |> scoreC
  end
  def solve2([]), do: 0
  def solve2(l) do
    group = Enum.slice(l, 0, 3)
    if (Enum.count(l) == 3) do groupScore(group)
    else groupScore(group) + solve2(Enum.slice(l, 3, Enum.count(l)))
    end
  end

  def main do
    IO.inspect(solve(Enum.map(input(), &mkpair/1)))
    IO.inspect(solve2(Enum.map(input(), &to_charlist/1)))
  end
end

# 7553
# 2758