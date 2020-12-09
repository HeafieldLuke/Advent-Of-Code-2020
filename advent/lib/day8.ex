defmodule Day8 do
    
    def read_file() do
        case File.read("../input/day8.txt") do
            {:ok, body} -> 
                body
                |> String.split("\n")
                |> Enum.with_index
                |> Enum.map(fn {x, i} -> String.split(x, " ") |> (fn [op | [num | []]] -> {i, {op, String.to_integer(num)}} end).() end)
                |> Map.new
            {:error, msg} -> IO.puts(msg)
        end
    end

    def start() do
        input = read_file()
        input |> part1 |> IO.puts
        input |> part2 |> IO.puts
    end

    def part1(instructions) do
        process_rules(0, 0, [], instructions)
    end

    def process_rules(state, next, executed, instructions) do
        if Enum.member?(executed, next) do
            state
        else 
            {op, num} = instructions[next]
            case op do
                "nop" -> process_rules(state, next+1, [next | executed], instructions)
                "jmp" -> process_rules(state, next + num, [next | executed], instructions)
                "acc" -> process_rules(state + num,next + 1, [next | executed], instructions)
            end
        end
        
    end


    def part2(instructions) do
        IO.puts("hi")
    end

end