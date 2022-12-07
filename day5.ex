defmodule Day5 do
  def input do
    [stack, move] = String.split(File.read!("input5.txt"), "\n\n")
    {parseStack(String.split(stack, "\n")), parseMove(String.split(move, "\n"))}
  end
  def parseStack(stack) do
    f = for frame <- stack, do: parseFrame(to_charlist(frame))
    trim(transpose(f))
  end
  def parseFrame(frame) do
    len = Enum.count(frame)
    if len == 3 do
      [Enum.at(frame,1)]
    else
      [Enum.at(frame,1) | parseFrame(Enum.slice(frame, 4, len))]
    end
  end
  def transpose(rows) do
    rows
    |> List.zip
    |> Enum.map(&Tuple.to_list/1)
  end
  def trim(cs) do
    for c <- cs do
      for x <- c, x >= ?A && x <= ?Z, do: x
    end
  end
  def parseMove(move) do
    for line <- move do
      crap = String.split(line, " ")
      [String.to_integer(Enum.at(crap, 1)), String.to_integer(Enum.at(crap, 3)), String.to_integer(Enum.at(crap, 5))]
    end
  end

  def move(piles, []), do: for pile <- piles, do: List.first(pile)
  def move(piles, [m | ms]) do
    piles2 = doMove(piles, m)
    move(piles2, ms)
  end
  def doMove(piles, [0 | _]), do: piles
  def doMove(piles, [n, f, t]) do
    {ch, piles2} = rmFrom(piles, f-1)
    piles3 = addTo(piles2, t-1, ch)
    doMove(piles3, [n-1, f, t])
  end
  def rmFrom([[c|cs]|xs], 0), do: {c, [cs|xs]}
  def rmFrom([x|xs], n) do
    {c, ts} = rmFrom(xs, n-1)
    {c, [x | ts]}
  end
  def addTo([x|xs], 0, c), do: [[c|x] | xs]
  def addTo([x|xs], n, c) do
    ts = addTo(xs, n-1, c)
    [x|ts]
  end

  def move2(piles, []), do: for pile <- piles, do: List.first(pile)
  def move2(piles, [m | ms]) do
    piles2 = doMove2(piles, m)
    move2(piles2, ms)
  end
  def doMove2(piles, [n, f, t]) do
    {ch, piles2} = rmFrom2(piles, f-1, n)
    addTo2(piles2, t-1, ch)
  end
  def poppy(cs, 0), do: {[], cs}
  def poppy([c|cs], n) do
    {h, t} = poppy(cs, n-1)
    {[c|h], t}
  end
  def rmFrom2([cs|xs], 0, b) do
    {c, rs} = poppy(cs, b)
    {c, [rs|xs]}
  end
  def rmFrom2([x|xs], n, b) do
    {c, ts} = rmFrom2(xs, n-1, b)
    {c, [x | ts]}
  end
  def addTo2([x|xs], 0, c), do: [c ++ x | xs]
  def addTo2([x|xs], n, c) do
    ts = addTo2(xs, n-1, c)
    [x|ts]
  end

  def main do
    {piles, moves} = input()
    IO.inspect(move(piles, moves))
    IO.inspect(move2(piles, moves))
  end
end