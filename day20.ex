defmodule Day20 do
  def input do
    File.read!("input20.txt")
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
    |> Enum.with_index
  end

  def result(r) do
    r
    |> Enum.sort(fn {_,a}, {_,b} -> a<b end)
    |> Enum.map(fn {n,_} -> n end)
  end
  def solve(sequense), do: solve(sequense, sequense)
  def solve([], result), do: result(result)
  def solve([{n,i}|s], result) do
#    IO.inspect({n, result(result)})
    {_, ix} = Enum.at(result, i)
    l = Enum.count(result)
#    IO.inspect({moveRange(ix, n, l)})
    ni = choose(l <= ix+n, rem(ix+n+l+1,l), choose(n < 0, rem(ix+n+l-1,l), ix+n))
    mr = MapSet.new(moveRange(ix, n, l))
    solve(s, result
    |> Enum.map(fn {nn,ii} -> move(nn, ii, n, ix, l, ni, mr) end))
  end
  def choose(true, a, _), do: a
  def choose(_, _, a), do: a
  def move(nn, ii, n, i, l, ni, mr) do
#    IO.inspect({nn, ii, n, i, l})
#    ni = choose(l <= i+n, rem(i+n+l+1,l), choose(n < 0, rem(i+n+l-1,l), i+n))
#    mr = MapSet.new(moveRange(i, n, l))
#    IO.inspect({mr, MapSet.member?(mr, ii)})
    cond do
      n == 0 -> {nn, ii}
      ii == i -> {nn, ni}
      ni > i && MapSet.member?(mr, ii) -> {nn, ii - 1}
      ni < i && MapSet.member?(mr, ii) -> {nn, ii + 1}
      true -> {nn, ii}
    end
  end
  def moveRange(i, n, l) do
    cond do
      n < 0 -> Enum.to_list(i..rem(i+n+l-1,l))
      l <= i+n -> Enum.to_list(i..rem(i+n+l+1,l))
      true -> Enum.to_list(i..rem(i+n+l,l))
    end
  end

  def zeroIndex(l) do
    l
    |> Enum.with_index
    |> Enum.filter(fn {n,_} -> n == 0 end)
    |> Enum.at(0)
    |> elem(1)
  end

  def main do
    r = solve(input())
    l = Enum.count(r)
    zi = zeroIndex(r)
    Enum.at(r, rem(1000 + zi, l)) + Enum.at(r, rem(2000 + zi, l)) + Enum.at(r, rem(3000 + zi, l))
#    IO.inspect(solve(input()))
  end
end

# 69206
# 197400