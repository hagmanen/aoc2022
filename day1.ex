defmodule Day1 do
  def input do
    groups = File.read!("input1.txt")
    |> String.split("\n\n")
    for elf <- groups, do: parseElf(elf)
  end

  def parseElf(elf) do
    for cal <- String.split(elf, "\n"), do: String.to_integer(cal)
  end

  def solve1(elfs), do: Enum.max(for sum <- elfs, do: Enum.sum(sum))
  def solve2(elfs) do
    elfs
    |> Enum.map(&Enum.sum/1)
    |> Enum.sort(fn a, b -> a > b end)
    |> Enum.take(3)
    |> Enum.sum
  end

  def main do
    IO.inspect(solve1(input()))
    IO.inspect(solve2(input()))
  end
end

# 69206
# 197400