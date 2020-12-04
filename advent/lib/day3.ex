defmodule Day3 do
    
    def read_file() do
        case File.read("../input/day3.txt") do
            {:ok, body} -> parse_input(body)
            {:error, msg} -> IO.puts(msg)    
        end
    end

    def parse_input(input) do
        input 
        |> String.split("\n")
        |> Enum.map(fn x -> tl(String.split(x, "")) end)
        |> Enum.map(fn x -> List.delete_at(x,length(x) - 1) end)
    end

    def start() do
        input = read_file()
        IO.puts(part1(input))
        IO.puts(part2(input))
    end

    def part1(forest) do
        count_trees(forest, 0, {3, 1},3, 1)
    end

    def part2(forest) do
        count_trees(forest, 0, {1,1}, 1, 1) 
        * count_trees(forest, 0, {3,1}, 3, 1) 
        * count_trees(forest, 0, {5,1}, 5, 1) 
        * count_trees(forest, 0, {7,1}, 7, 1) 
        * count_trees(forest, 0, {1,2}, 1, 2) 
    end

    def count_trees(forest, acc, position, right, left) do
        lim = 31 - right
        case find_at(forest, position) do
            :tree -> 
                case elem(position, 0) >= lim do
                    true -> count_trees(forest, acc + 1, {elem(position,0) - lim, elem(position, 1) + left}, right, left)
                    false -> count_trees(forest, acc + 1, {elem(position, 0) + right, elem(position, 1) + left}, right, left)
                end
            :open -> 
                case elem(position, 0) >= lim do
                    true -> count_trees(forest, acc, {elem(position,0) - lim, elem(position, 1) + left}, right, left)
                    false -> count_trees(forest, acc, {elem(position, 0) + right, elem(position, 1) + left}, right, left)
                end
            :end -> acc
        end
    end

    def find_at(forest, position) do
        {right, down} = position
        col = Enum.at(forest, down)
        
        cond do
            col == nil ->
                :end
            true -> 
                case Enum.at(col, right) do
                    "#" -> :tree
                    "." -> :open
                    nil -> :end
                end
        end
    end

    def part2(forest) do
        IO.puts("Not yet implemented")
    end
end