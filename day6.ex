defmodule Day6 do
  def input do
    to_charlist(File.read!("input6.txt"))
  end

  def isUnique(cs, n, s) do
    list = Enum.slice(cs, n..n+s-1)
    Enum.count(Enum.uniq(list)) == s
  end

  def solve(cs, n, s) do
    if (isUnique(cs, n, s)) do n + s
    else solve(cs, n+1, s)
    end
  end

  def main do
    IO.inspect(solve(input(), 0, 4))
    IO.inspect(solve(input(), 0, 14))
  end
end