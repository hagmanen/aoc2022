defmodule Day7 do
  def input do
    String.split(File.read!("input7.txt"), "\n")
  end

  def sumSize([], s), do: {[], s}
  def sumSize([l|ls], [s|ss]) do
    ws = String.split(l, " ")
    cond do
      l == "$ cd .." -> {ls, [s|ss]}
      String.match?(l, ~r/^[[:digit:]]+/) -> sumSize(ls, [s+String.to_integer(Enum.at(ws, 0))|ss])
      String.match?(l, ~r/^\$ cd [[:alnum:]]+/) -> {rs, [s2|ss2]} = sumSize(ls, [0 | ss]); sumSize(rs, [s+s2|[s2|ss2]])
      true -> sumSize(ls, [s|ss])
    end
  end

  def solve([]), do: 0
  def solve([r|rs]) do
    if (r <= 100000) do
      r + solve(rs)
    else
      solve(rs)
    end
  end

  def main do
    {_, rs} = sumSize(input(), [0])
    IO.inspect(solve(rs))
    needed = Enum.max(rs) - 40000000
    IO.inspect(Enum.min(for rr <- rs, rr >= needed, do: rr))
  end
end

# 1844187
# 4978279