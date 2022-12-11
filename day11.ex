defmodule Day11 do
  @levels 0
  @operation 1
  @test 2
  @true_monkey 3
  @false_monkey 4
  @inspections 5
  @gcd 0
  @divider 1

  def input do
    monkeys = File.read!("input11.txt")
    |> String.split("\n\n")
    for monkey <- monkeys, do: parseMonkey(monkey)
  end
  def parseMonkey(monkey) do
    [_, _, items, _, operation, _, test, _, true_monkey, _, false_monkey] = monkey
    |> String.split(["\n", ":"], trim: true)
    { parseItems(items),
      fn level -> elem(Code.eval_string(operation, [old: level]), 0) end,
      wordToInt(test, 3),
      wordToInt(true_monkey, 4),
      wordToInt(false_monkey, 4),
      0}
  end
  def parseItems(items) do
    String.split(items, [" ", ","], trim: true)
    |> Enum.map(&String.to_integer/1)
  end
  def wordToInt(text, word) do
    String.split(text, " ")
    |> Enum.at(word)
    |> String.to_integer
  end
  def applyOperation(level, operation) do
    elem(Code.eval_string(operation, [old: level]), 0)
  end

  def levelAction(monkey, level, config) do
    new_level = level
    |> rem(elem(config, @gcd))
    |> elem(monkey, @operation).()
    |> div(elem(config, @divider))

    if (rem(new_level, elem(monkey, @test)) == 0) do
      {new_level, elem(monkey, @true_monkey)}
    else
      {new_level, elem(monkey, @false_monkey)}
    end
  end
  def handleLevel(monkeys, monkey, level, config) do
    {new_level, new_monkey} = levelAction(monkey, level, config)
    monkeys
    |> Enum.with_index
    |> Enum.map(fn
      {mm, ^new_monkey} -> addLevel(mm, new_level)
      {m, _} -> m
      end)
  end
  def addLevel({levels, operation, test, true_monkey, false_monkey, count}, level) do
    {levels ++ [level], operation, test, true_monkey, false_monkey, count}
  end
  def addLevel(monkey, level) do
    monkey
    |> Enum.with_index
    |> Enum.map(fn
      {levels, 0} -> levels ++ [level]
      {f, _} -> f
      end)
  end

  def indexList(e) do
    e
    |> Enum.with_index
    |> Enum.map(fn x -> {_, c} = x; c end)
  end

  def clearLevels({levels, operation, test, true_monkey, false_monkey, count}) do
    {[], operation, test, true_monkey, false_monkey, count + Enum.count(levels)}
  end
  def clearLevels(monkeys, monkey) do
    monkeys
    |> Enum.map(fn m ->
      cond do
        m == monkey -> clearLevels(monkey)
        true -> m
      end
    end)
  end

  def monkeyRound(monkeys, monkey, config), do: monkeyRound(monkeys, monkey, elem(monkey, @levels), config)
  def monkeyRound(monkeys, monkey, [], _), do: clearLevels(monkeys, monkey)
  def monkeyRound(monkeys, monkey, [l|ls], config) do
    monkeyRound(handleLevel(monkeys, monkey, l, config), monkey, ls, config)
  end

  def makeRounds(monkeys, 0, _), do: monkeys
  def makeRounds(monkeys, i, config) do
    makeRounds(makeRound(monkeys, indexList(monkeys), config), i-1, config)
  end
  def makeRound(monkeys, [], _), do: monkeys
  def makeRound(monkeys, [i|is], config) do
    makeRound(monkeyRound(monkeys, Enum.at(monkeys, i), config), is, config)
  end

  def product([]), do: 1
  def product([x|xs]), do: x * product(xs)

  def score(monkeys) do
    monkeys
    |> Enum.map(fn m -> elem(m, @inspections) end)
    |> Enum.sort()
    |> Enum.take(-2)
    |> product
  end

  def gcd(monkeys) do
    monkeys
    |> Enum.map(fn m -> elem(m, @test) end)
    |> product
  end

  def main do
    monkeys = input()
    gcd = gcd(monkeys)
    IO.inspect(score(makeRounds(monkeys, 20, {gcd, 3})))
    IO.inspect(score(makeRounds(monkeys, 10000, {gcd, 1})))
  end
end

# 108240
# 25712998901