defmodule Day8 do
  def input do
    for line <- String.split(File.read!("input8.txt"), "\n") do
      for nr <- to_charlist(line), do: String.to_integer(to_string(nr))
    end
  end

  def hor(h,w) do
    for p <- 0..w, do: {h, p}
  end

  def ver(h,w) do
    for p <- 0..h, do: {p, w}
  end

  def high(f, {h, w}) do
    Enum.at(Enum.at(f, h), w)
  end

  def walk([], _), do: MapSet.new()
  def walk([{c,h}|ps], m) do
    if (h > m) do
      MapSet.put(walk(ps, h), c)
    else
      walk(ps, m)
    end
  end

  def union(s, []), do: s
  def union(s, [sn|ss]), do: union(MapSet.union(s,sn), ss)

  def seenFromOutside(f) do
    l = Enum.count(f)
    sets = for x <- Enum.to_list(0..l-1) do
      hors = for corr <- hor(x, l-1), do: {corr, high(f, corr)}
      vers = for corr <- ver(l-1, x), do: {corr, high(f, corr)}
      uppers = walk(vers, 0)
      downers = walk(Enum.reverse(vers), 0)
      lefty = walk(hors, 0)
      righty = walk(Enum.reverse(hors),0)
      union(uppers, [downers, lefty, righty])
    end
    s = union(MapSet.new(), sets)
    MapSet.size(s)
  end

  def score(_,[],_), do: 0
  def score(f, [c|cs], oh) do
    ch = high(f, c)
    if (ch >= oh) do
      1
    else
      1 + score(f, cs, oh)
    end
  end

  def maxView([], _, _, m), do: m
  def maxView([{h,w}|cs], f, l, m) do
    th = high(f, {h,w})
    [_|upwards] = for c <- h..0, do: {c,w}
    [_|downwards] = for c <- h..l, do: {c,w}
    [_|leftwards] = for c <- w..0, do: {h,c}
    [_|rightwards] = for c <- w..l, do: {h,c}
    up = score(f, upwards, th)
    dp = score(f, downwards, th)
    lp = score(f, leftwards, th)
    rp = score(f, rightwards, th)
    s = up * dp * lp * rp
    maxView(cs, f, l, max(m,s))
  end

  def bestView(f) do
    l = Enum.count(f)
    (for x <- Enum.to_list(0..l-1), do: for y <- Enum.to_list(0..l-1), do: {x,y})
    |> List.flatten
    |> maxView(f, l-1, 0)
  end

  def main do
    IO.inspect(seenFromOutside(input()))
    IO.inspect(bestView(input()))
  end
end

# 1543
# 595080