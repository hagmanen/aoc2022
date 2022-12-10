defmodule Day2 do
  def input do
    File.read!("input2.txt")
    |> String.split("\n")
    |> Enum.map(fn s -> String.split(s, " ") end)
  end

  def bonus("X"), do: 1
  def bonus("Y"), do: 2
  def bonus("Z"), do: 3

  def score(["A", "X"]), do: 3
  def score(["A", "Y"]), do: 6
  def score(["A", "Z"]), do: 0
  def score(["B", "Y"]), do: 3
  def score(["B", "Z"]), do: 6
  def score(["B", "X"]), do: 0
  def score(["C", "Z"]), do: 3
  def score(["C", "X"]), do: 6
  def score(["C", "Y"]), do: 0

  # X lose, Y draw, Z win
  def choose(["A", "X"]), do: "Z"
  def choose(["A", "Y"]), do: "X"
  def choose(["A", "Z"]), do: "Y"
  def choose(["B", "X"]), do: "X"
  def choose(["B", "Y"]), do: "Y"
  def choose(["B", "Z"]), do: "Z"
  def choose(["C", "X"]), do: "Y"
  def choose(["C", "Y"]), do: "Z"
  def choose(["C", "Z"]), do: "X"

  def solve([]), do: 0
  def solve([x|xs]), do: score(x) + bonus(Enum.at(x, 1)) + solve(xs)

  def mut1([x, y]), do: [x, choose([x, y])]
  def mut(inp), do: for move <- inp, do: mut1(move)

  def main do
    IO.inspect(solve(input()))
    IO.inspect(solve(mut(input())))
  end
end

# 14375
# 10274