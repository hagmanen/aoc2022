defmodule Day25 do
  def input do
    File.read!("input25.txt")
    |> String.split("\n")
    |> Enum.map(&parseNr/1)
    |> Enum.sum
  end

  def parseNr(text) do
    text
    |> to_charlist
    |> Enum.reduce(0, fn c, s -> snafu(c, s) end)
  end
  def snafu(?2, s), do: (s*5) + 2
  def snafu(?1, s), do: (s*5) + 1
  def snafu(?0, s), do: (s*5)
  def snafu(?-, s), do: (s*5) - 1
  def snafu(?=, s), do: (s*5) - 2

  def encode(0), do: ""
  def encode(nr) do
    case rem(nr,5) do
      0 -> encode(div(nr,5)) <> "0"
      1 -> encode(div(nr,5)) <> "1"
      2 -> encode(div(nr,5)) <> "2"
      3 -> encode(div(nr,5)+1) <> "="
      4 -> encode(div(nr,5)+1) <> "-"
    end
  end

  def main do
    encode(input())
  end
end

# 2-1=10=1=1==2-1=-221
