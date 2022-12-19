defmodule Day19 do
  def input do
    File.read!("input19.txt")
    |> String.split("\n")
    |> Enum.map(&parseBlueprint/1)
  end
  def parseBlueprint(text) do
    [nr, robots] = text
    |> String.split([":"], trim: true)
    {parseBlueprintNr(nr), parseRobots(robots)}
  end
  def parseBlueprintNr(text) do
    text
    |> String.split(" ", trim: true)
    |> Enum.at(1)
    |> String.to_integer
  end
  def parseRobots(text) do
    text
    |> String.split(".", trim: true)
    |> Enum.map(&parseRobot/1)
    |> Map.new
  end
  def parseRobot(text) do
    [type, costs] = text
    |> String.split(" robot costs ")
    {parseRobotType(type), parseCosts(costs)}
  end
  def parseRobotType(text) do
    text
    |> String.split(" ", trim: true)
    |> Enum.at(1)
    |> nameToType
  end
  def nameToType("ore"), do: :ore
  def nameToType("clay"), do: :clay
  def nameToType("obsidian"), do: :obsidian
  def nameToType("geode"), do: :geode
  def parseCosts(text) do
    text
    |> String.split(" and ")
    |> Enum.map(&parseCost/1)
    |> Map.new
  end
  def parseCost(text) do
    [nr, type] = text
    |> String.split(" ")
    {nameToType(type), String.to_integer(nr)}
  end

  def strategy([{:ore, a}], _), do: [{:ore, a}]
  def strategy(needs, blueprint) do
    #IO.inspect(needs)
    needs
    |> Enum.map(fn {type, amount} -> need(type, amount, blueprint) end)
    |> Enum.reduce(emptyNeed(), fn ns, acc -> accNeeds(ns, acc) end)
    |> Enum.filter(fn {_,a} -> a != 0 end)
    |> strategy(blueprint)
  end
  def need(type, amount, blueprint) do
    blueprint
    |> Map.fetch!(type)
    |> Enum.map(fn {t, a} -> {t, a*amount} end)
  end
  def accNeeds([], acc), do: acc
  def accNeeds([{t,a}|ns], acc) do
    accNeeds(ns, addNeed(acc, t, a))
  end
  def addNeed(acc, t, a) do
    acc
    |> Enum.map(fn {type, amount} -> {type, condAdd(type == t, amount, a)} end)
  end
  def condAdd(true, a1, a2), do: a1 + a2
  def condAdd(false, a, _), do: a
  def emptyNeed(), do: [{:geode, 0}, {:obsidian, 0}, {:clay, 0}, {:ore, 0}]

  def build(i, :error, _, {is, b}), do: {[i|is], b}
  def build({t,a}, {:ok, ar}, _, {is, b}) do
    {[{t,a-ar}|is], choose(a >= ar, b, :none)}
  end
  def build(blueprint, inventory, type) do
    req = Map.fetch!(blueprint, type)
    inventory
    |> Enum.reduce({[], type}, fn {t, a}, r -> build({t,a}, Map.fetch(req, t), type, r) end)
  end
  def tryBuild(blueprint, inventory, type, built) do
    {inv, bui} = build(blueprint, inventory, type)
    {inv, choose(built == :none, bui, built)}
  end

  def updateWanted([], _, _), do: []
  def updateWanted([{t,a}|ws], w, ct) do
    cond do
#      ct == t -> [{t,a}|updateWanted(ws,w, ct)]
      a < 0 -> [{t,Map.fetch!(w,t) - a}|updateWanted(ws,w, ct)]
      true -> [{t,Map.fetch!(w,t)}| updateWanted(ws,w, ct)]
    end
  end

  def choose(true, a, _), do: a
  def choose(_, _, a), do: a
  def nextType(:geode), do: :obsidian
  def nextType(:obsidian), do: :clay
  def nextType(:clay), do: :ore
  def nextType(:ore), do: :error

  def turn(_, inventory, :error, _, build), do: {inventory, build}
  def turn(blueprint, inventory, type, wanted, built) do
    #IO.inspect({"Start", wanted, type})
    mostWanted = wanted
    |> Enum.max_by(fn {_,a} -> a end)
    |> elem(0)
    {inv, bu} = tryBuild(blueprint, inventory, type, built)
    #IO.inspect({"Build", wanted, bu, built})
    wanted2 = updateWanted(inv, Map.new(wanted), type)
    #IO.inspect({"Want", wanted2, type})
    {inv2, bu2} = choose((mostWanted==type) && (bu != built), {inv, bu}, {inventory, built}) 
    turn(blueprint, inv2, nextType(type), wanted2, bu2)
  end
  def turn(blueprint, inventory, robots, minutes) do
    {inv, built} = turn(blueprint, inventory, :geode, [geode: 1, obsidian: 0, clay: 0, ore: 0], :none)
    IO.inspect({minutes, built})
    {produce(inv, robots), addRobot(robots, built)}
  end

  def produce(inventory, robots) do
    rm = Map.new(robots)
    inventory
    |> Enum.map(fn {t,a} -> {t, a + Map.fetch!(rm, t)} end)
  end
  def addRobot(robots, built) do
    robots
    |> Enum.map(fn {t,a} -> {t, choose(t==built, a+1, a)} end)
  end

  def run(blueprint), do: run(blueprint, [geode: 0, obsidian: 0, clay: 0, ore: 0], [geode: 0, obsidian: 0, clay: 0, ore: 1], 24)
  def run(_, inventory, _, 0), do: Map.fetch!(Map.new(inventory), :geode)
  def run(blueprint, inventory, robots, minutes) do
    {inv, rob} = turn(blueprint, inventory, robots, 25 - minutes)
    #IO.inspect({rob})
    run(blueprint, inv, rob, minutes - 1)
  end

  def main do
    [{_,b}|_] = input()
    #need = [{:geode, 1}]
    #IO.inspect(strategy(need, b))
    #turn(b, [geode: 0, obsidian: 0, clay: 0, ore: 0], [geode: 0, obsidian: 0, clay: 0, ore: 1])
    #tryBuild(b, [geode: 0, obsidian: 4, clay: 0, ore: 2], :geode, false)
    #turn(b, [ore: 1, clay: 30, obsidian: 8, geode: 3], [geode: 1, obsidian: 3, clay: 5, ore: 1])
    run(b)
  end
end

# 
# 