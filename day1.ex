defmodule Day1 do
  def input do
    file = File.read!("input1.txt")
    groups = String.split(file, "\n\n")
    for elf <- groups, do: parseElf(elf)
  end

  def parseElf(elf) do
    for cal <- String.split(elf, "\n"), do: String.to_integer(cal)
  end

  def solve1(elfs), do: Enum.max(for sum <- elfs, do: Enum.sum(sum))
  def solve2(elfs) do
    sumlist = for sum <- elfs, do: Enum.sum(sum)
    toplist = Enum.sort(sumlist, fn a, b -> a > b end)
    top3 = Enum.take(toplist, 3)
    Enum.sum(top3)
  end

  def main do
    IO.inspect(solve1(input()))
    IO.inspect(solve2(input()))
  end
end
