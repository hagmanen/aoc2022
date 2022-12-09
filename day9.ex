defmodule Day9 do
  def input do
    for line <- String.split(File.read!("input9.txt"), "\n") do
      [d, c] = String.split(line, " ")
      {d, String.to_integer(to_string(c))}
    end
  end

  def sign(x) do
    cond do
      x < 0 -> -1
      x > 0 -> 1
      true -> 0
    end
  end

  def follow(_,[]), do: []
  def follow(h, [t|ts]) do
    tp = follow(h,t)
    [tp|follow(tp,ts)]
  end
  def follow({hx, hy},{tx, ty}) do
    dx = hx - tx
    dy = hy - ty
    if (abs(dx) == 2 || abs(dy) == 2) do
      {tx+sign(dx), ty+sign(dy)}
    else
      {tx, ty}
    end
  end

  def move("U", {x,y}), do: {x+1, y}
  def move("D", {x,y}), do: {x-1, y}
  def move("R", {x,y}), do: {x, y+1}
  def move("L", {x,y}), do: {x, y-1}
  def move(_, 0, r, s), do: {r, s}
  def move(d, c, r, s) do
    [h|t] = r
    hp = move(d, h)
    tp = follow(hp, t)
    move(d, c-1, [hp|tp], MapSet.put(s, List.last(tp)))
  end

  def solve([], _, s), do: MapSet.size(s)
  def solve([{d,c}|ms], r, s) do
    {rp, sp} = move(d, c, r, s)
    solve(ms, rp, sp)
  end

  def main do
    IO.inspect(solve(input(), List.duplicate({0,0}, 2), MapSet.new()))
    IO.inspect(solve(input(), List.duplicate({0,0}, 10), MapSet.new()))
  end
  # p1: 6337
  # p2: 2455
end