defmodule Day20 do
  def input(f) do
    File.read!("input20.txt")
    |> String.split("\n")
    |> Enum.map(fn x -> String.to_integer(x) * f end)
    |> Enum.with_index
  end

  def move(list, i, ni, a..b, o) do
    list
    |> Enum.map(fn {v, oi} ->
      cond do
        oi == i -> {v,ni}
        oi >= a && oi <= b -> {v, oi + o}
        true -> {v,oi}
      end
    end)
  end

  def adj(v) do
    cond do
      v < 0 -> -1
      true -> 0
    end
  end

  def move(list, n, len) do
    {v,i} = Enum.at(list, n)
    ni = rem(rem(i + v, len-1) + len-1, len-1)
    cond do
      ni > i -> move(list, i, ni, i+1..ni, -1)
      ni < i -> move(list, i, ni, ni..i-1, 1)
      true -> list
    end
  end

  def result(l) do
    l
    |> Enum.sort(fn {_,i1}, {_,i2} -> i1 < i2 end)
    |> Enum.map(fn {x,_} -> x end)
  end

  def scramble(list, len) do
    0..len-1
    |> Enum.reduce(list, fn i, l -> move(l, i, len) end)
  end

  def solve(list, c) do
    len = Enum.count(list)
    nl = 1..c
    |> Enum.reduce(list, fn _, l -> scramble(l, len) end)
    |> Enum.sort(fn {_,i1}, {_,i2} -> i1 < i2 end)
    si =  nl
    |> Map.new
    |> Map.fetch!(0)
    [1000, 2000, 3000]
    |> Enum.reduce(0, fn n, a -> a + elem(Enum.at(nl, rem(si + n, len)),0) end)
  end

  def main do
    IO.inspect(solve(input(1),1))
    IO.inspect(solve(input(811589153),10))
  end
end

# 3473
# 7496649006261