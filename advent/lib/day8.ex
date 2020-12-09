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
        input |> part1 |> (fn {_, state} -> IO.puts(state) end).()
        input |> part2 |> IO.puts
    end

    def part1(instructions) do
        process_rules(0, 0, [], instructions)
    end

    def process_rules(state, next, executed, instructions) do
        if Enum.member?(executed, next) do
            {:crash, state}
        else 
            case instructions[next] do
                nil -> {:exit, state}
                {op, num} -> 
                    case op do
                        "nop" -> process_rules(state, next+1, [next | executed], instructions)
                        "jmp" -> process_rules(state, next + num, [next | executed], instructions)
                        "acc" -> process_rules(state + num,next + 1, [next | executed], instructions)
            end
            end 
        end
        
    end

    def fix(modified, address, original) do
        case process_rules(0,0,[],modified) do
            {:crash, _} ->
                case original[address] do
                    {"acc", _} ->
                        fix(original, address + 1, original)
                    instruction ->
                        fix(Map.put(original, address, swap(instruction)), address + 1, original)
                end
            {:exit, state} -> state
        end
    end

    def swap({"jmp", value}), do: {"nop", value}
    def swap({"nop", value}), do: {"jmp", value}

    def part2(instructions) do
        fix(instructions, 0, instructions)
    end

end