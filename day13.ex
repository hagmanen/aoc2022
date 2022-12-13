defmodule Day13 do
  def input do
    File.read!("input13.txt")
    |> String.split("\n\n")
    |> Enum.map(&parsePair/1)
  end

  def parsePair(text) do
    text
    |> String.split("\n")
    |> Enum.map(&Code.eval_string/1)
    |> Enum.map(fn x -> elem(x, 0) end)
  end

  def comp(l, r) do
    cond do
      l < r -> 1
      l > r -> -1
      true -> 0
    end
  end

  def isRight({l,_}), do: isRight(l) != -1
  def isRight([[],[]]), do: 0
  def isRight([[],_]), do: 1
  def isRight([_, []]), do: -1
  def isRight([[ll|lls], [lr|lrs]]) do
    c = isRight([ll, lr])
    if (c == 0) do
      isRight([lls, lrs])
    else
      c
    end
  end
  def isRight([ll, lr]) do
    cond do
      is_integer(ll) && is_integer(lr) -> comp(ll, lr)
      is_integer(ll) -> isRight([[ll], lr])
      is_integer(lr) -> isRight([ll, [lr]])
    end
  end

  def solve1(l) do
    l
    |> Enum.with_index
    |> Enum.filter(&isRight/1)
    |> Enum.map(fn x -> 1 + elem(x, 1) end)
    |> Enum.sum
  end

  def product([]), do: 1
  def product([x|xs]), do: x * product(xs)

  def isDivider({[[2]],_}), do: true
  def isDivider({[[6]],_}), do: true
  def isDivider(_), do: false

  def solve2(l) do
    l
    |> Enum.reduce(fn [x,y], acc -> [x|[y|acc]] end)
    |> Enum.sort(fn x, y -> isRight({[x,y], 0}) end)
    |> Enum.with_index
    |> Enum.filter(&isDivider/1)
    |> Enum.map(fn x -> 1 + elem(x, 1) end)
    |> product
  end

  def main do
    IO.inspect(solve1(input()))
    IO.inspect(solve2([[[[2]],[[6]]]|input()]))
  end
end

# 6086
# 27930
