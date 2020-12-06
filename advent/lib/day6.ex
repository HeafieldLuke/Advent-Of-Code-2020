defmodule Day6 do
    
    def read_file() do
        case File.read("../input/day6.txt") do
            {:ok, body} -> parse_input(body)
            {:error, msg} -> IO.puts(msg)
        end
    end

    def parse_input(input) do
        input
        |> String.split("\n\n")
        |> Enum.map(fn x -> String.split(x,"\n") end)
        |> Enum.map(fn x -> {length(x), Enum.join(x, "")} end)
    end

    def start() do
       input = read_file()
       IO.puts(input |> part1)
       IO.puts(input |> part2) 
    end

    def part1(input) do
        input
        |> Enum.map(fn x -> parse_answers(elem(x,1) |> String.graphemes, %{}) end)
        |> Enum.map(fn x -> Map.values(x) |> length end)
        |> Enum.reduce(fn x, acc -> x + acc end)
    end

    def parse_answers([head | tail], answers) do
        case answers[head] do
            nil -> parse_answers(tail, Map.put(answers, head, 1))
            _ -> parse_answers(tail, Map.update(answers, head, 1, fn x -> x + 1 end))
        end
    end

    def parse_answers([], answers), do: answers

    def part2(input) do
        input
        |> Enum.map(fn x -> parse_answers(elem(x,1) |> String.graphemes, %{}) |> (fn(s) -> {elem(x,0), s} end).() end)
        |> Enum.map(fn {count, answers} -> Map.values(answers) |> (fn(x) -> Enum.filter(x, fn y -> y === count end) end).() |> length end)
        |> Enum.reduce(fn x,acc -> x + acc end)

    end
end