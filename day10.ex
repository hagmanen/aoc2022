defmodule Day10 do
  def input do
    program = String.split(File.read!("input10.txt"), "\n")
    for instruction <- program, do: parseInstruction(instruction)
  end

  def parseInstruction(instruction) do
    cond do
      instruction == "noop" -> {:noop, 0}
      true -> {:addx, String.to_integer(Enum.at(String.split(instruction), 1))}
    end
  end

  def exec(r, {:noop,_}), do: r
  def exec(r, {:addx,v}), do: r+v

  def queue({:noop,_}), do: [{:noop, 0}]
  def queue(i), do: [{:noop, 0}, i]

  def run([],[],_), do: []
  def run([],[i|is], r), do: [r | run([], is, exec(r, i))]
  def run([c|cs],[i|is], r), do: [r | run(cs, is ++ queue(c), exec(r, i))]

  def result(_, []), do: 0
  def result(res, [i|is]), do: Enum.at(res, i)*i + result(res, is)

  def touch(s, p), do: abs(s+1-p) <= 1

  def draw(res, p) do
    if (touch(Enum.at(res, p), rem(p, 40))) do
      "#"
    else
      "."
    end
  end

  def main do
    [_|res] = run(input(), List.duplicate({:noop,0}, 2), 1)
    IO.inspect(result(res, [20, 60, 100, 140, 180, 220]))
    IO.inspect(Enum.join(for p <- 1..40, do: draw(res, p)))
    IO.inspect(Enum.join(for p <- 41..80, do: draw(res, p)))
    IO.inspect(Enum.join(for p <- 81..120, do: draw(res, p)))
    IO.inspect(Enum.join(for p <- 121..160, do: draw(res, p)))
    IO.inspect(Enum.join(for p <- 161..200, do: draw(res, p)))
    IO.inspect(Enum.join(for p <- 201..240, do: draw(res, p)))
  end
end
#17180
###..####.#..#.###..###..#....#..#.###.."
#..#.#....#..#.#..#.#..#.#....#..#.#..#."
#..#.###..####.#..#.#..#.#....#..#.###.."
###..#....#..#.###..###..#....#..#.#..##"
#.#..#....#..#.#....#.#..#....#..#.#..##"
#..#.####.#..#.#....#..#.####..##..###.."
# REHPRLUB