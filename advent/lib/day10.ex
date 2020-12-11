defmodule Day10 do
    
    def read_file() do
        case File.read("../input/day10.txt") do
            {:ok, body} ->
                String.split(body, "\n")
                |> Enum.map(fn x -> String.to_integer(x) end)
            {:error, msg} -> IO.puts(msg)
        end
    end

    def start() do
        input = read_file()
        input |> part1 |> IO.puts
        input |> part2 |> IO.puts
    end

    def part1(input) do
        l = input
        |> Enum.sort
        |> find_differences(0, {0,0,1})

        {one, _, three} = l
        one * three
    end

    def find_differences([adapter | rest], curr, acc) do
        case adapter - curr do
            1 -> find_differences(rest, adapter, {elem(acc,0) + 1, elem(acc,1), elem(acc,2)})
            2 -> find_differences(rest, adapter, {elem(acc,0), elem(acc,1) + 1, elem(acc,2)})
            3 -> find_differences(rest, adapter, {elem(acc,0), elem(acc,1), elem(acc,2) + 1})
        end
    end

    def find_differences([], curr, acc), do: acc

    def part2(input) do
        Agent.start_link(&Map.new/0, name: __MODULE__)

        res = input |> find_combinations(0)
        Agent.stop(__MODULE__)

        res
    end

    def find_combinations(adapters, adapter) do
        case Agent.get(__MODULE__, &Map.get(&1, adapter)) do
            nil ->
                val = reachable_adapters(adapters, adapter)
                Agent.update(__MODULE__, &Map.put(&1, adapter, val))
                val
            x ->
                x
        end
    end

    def reachable_adapters(adapters, adapter) do
        adapters
        |> Enum.filter(fn a -> a in (adapter + 1)..(adapter + 3) end)
        |> case do
            [] -> 1
            [a] -> find_combinations(adapters, a)
            a -> a |> Enum.map(&find_combinations(adapters, &1)) |> Enum.sum()
        end
    end
end