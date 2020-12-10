defmodule Day9 do
    
    def read_file() do
        case File.read("../input/day9.txt") do
            {:ok, body} ->
                body
                |> String.split("\n")
                |> Enum.map(fn x -> String.to_integer(x) end)
 
            {:error, msg} -> IO.puts(msg)
        end
    end

    def start() do
        input = read_file()
        input |> Enum.split(25) |> part1 |> IO.puts
        input |> part2 |> IO.puts
    end

    def part1({preamble, nums}) do
        find_first_invalid(preamble, nums)
    end

    def find_first_invalid(preamble, [curr | rest]) do 
        case Enum.member?(generate_sums([], preamble), curr) do
            true -> find_first_invalid(tl(preamble) ++ [curr], rest)
            false -> curr
        end
    end

    def generate_sums(sums, [curr | rest]) do
        generate_sums(sums ++ Enum.reduce(rest, [], fn x, acc -> [ x + curr | acc] end), rest)
    end

    def generate_sums(sums, []), do: sums

    def part2(input) do
        part1(input |> Enum.split(25))
        |> find_contiguous_set(input)
    end

    def find_contiguous_set(target, [head | tail]) do
        case generate_contiguous_set([], target, [head | tail]) do
            {:valid, list} -> Enum.min(list) + Enum.max(list)
            {:invalid, _} -> find_contiguous_set(target, tail)
        end
    end

    def generate_contiguous_set(acc, target, [head | tail]) do
        case Enum.sum([head | acc]) do
            n when n > target ->
                {:invalid, n}
            n when n < target ->
                generate_contiguous_set([head | acc], target, tail)
            n when n == target -> {:valid, [head | acc]}
        end
    end


end