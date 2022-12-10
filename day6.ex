defmodule Day6 do
  def input do
    to_charlist(File.read!("input6.txt"))
  end

  def isUnique(cs, n, s) do
    s == Enum.slice(cs, n..n+s-1)
    |> Enum.uniq
    |> Enum.count
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

# 1965
# 2773