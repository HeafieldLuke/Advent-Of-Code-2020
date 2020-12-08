defmodule Day7 do
    
    def read_file() do
        case File.read("../input/day7.txt") do
            {:ok, body} -> parse_input(body)
            {:error, msg} -> IO.puts(msg)
        end
    end

    def parse_input(input) do
        input 
        |> String.split("\n")
        |> Enum.map(fn x -> String.split(x, " contain ")  end)
        |> Enum.map(fn [f | [ s | _]] ->  {String.replace(f, ~r/ bags*/, "") , String.split(s, ~r/ bags*(, |.)/) |> Enum.reverse |> tl |> Enum.reverse} end)
        |> Enum.map(fn {key, bags} -> {key, Enum.map(bags, fn x -> String.split(x, " ") |> (fn [head | tail] -> {head, Enum.join(tail, " ")} end).() end)} end)
        |> List.foldl(%{}, fn {key, bags}, acc -> Map.put(acc, key, bags) end)
        
    end

    def start() do
        input = read_file()
        IO.puts(input |> IO.inspect |> part1)
        IO.puts(input |> part2)
    end

    def part1(input) do
        input
        |> Enum.reduce(0, fn {color, list}, acc ->
                cond do
                    color == "shiny gold" ->
                        acc
                    true ->
                        case find(input, list, "shiny gold") do
                            true -> acc + 1
                            false -> acc
                        end
                end
            end)


    end

    def find(rules, [], _), do: false
    def find(rules,[{_,color} | rest], color), do: true

    def find(rules, [{_, child_color} | rest], color),
        do: find(rules, rest, color) || find(rules, Map.get(rules, child_color, []), color)

    def part2(input) do
        IO.puts("Not yet implemented")
    end
end