defmodule Day3 do
  def input do
    for line <- String.split(File.read!("input3.txt"), "\n"), do: mkpair(line)
  end
  def mkpair(s) do
    len = String.length(s)
    half = div(len, 2)
    {to_charlist(String.slice(s, 0..half-1)), String.slice(s, half..len)}
  end
  def score({[], _}), do: 0
  def score({[x|xs], y}) do
#    IO.inspect(x)
    if (y =~ to_string([x])) do scoreC(x)
    else score({xs, y})
    end
  end
  def scoreC(c) do
    if (c >= 97 && c <= 122) do c - 96
    else c - 38 
    end
  end

  def solve(d) do
    Enum.sum(for s <- d, do: score(s))
  end

  def groupScore([a, b, c]) do
    i1 = MapSet.intersection(MapSet.new(a), MapSet.new(b))
    i2 = MapSet.intersection(i1, MapSet.new(c))
    scoreC(List.first(MapSet.to_list(i2)))
  end
  def solve2([]), do: 0
  def solve2(l) do
    group = Enum.slice(l, 0, 3)
    if (Enum.count(l) == 3) do groupScore(group)
    else groupScore(group) + solve2(Enum.slice(l, 3, Enum.count(l)))
    end
  end

  def main do
    IO.inspect(solve(input()))
    IO.inspect(solve2(for line <- String.split(File.read!("input3.txt"), "\n"), do: to_charlist(line)))
  end
end