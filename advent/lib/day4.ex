defmodule Day4 do
    
    def read_file() do
        case File.read("../input/day4.txt") do
            {:ok, body} -> parse_input(body)
            {:error, msg} -> IO.puts(msg)
        end
    end

    def parse_input(body) do
        body
        |> String.split("\n\n")
        |> Enum.map(fn x -> String.replace(x,"\n", " ")end)
    end

    def start() do
        input = read_file()
        IO.puts(input |> part1)
        IO.puts(input |> part2)
    end

    def part1(passports) do
        field_patterns = [~r/ecl/, ~r/pid/, ~r/eyr/, ~r/hcl/, ~r/byr/, ~r/iyr/, ~r/hgt/]
        List.foldl(
            passports,
            0,
            fn x, acc -> 
                case validate_passport(x, field_patterns) do
                    :valid -> acc + 1
                    :invalid -> acc
                end
            end
        )
    end

    

    def validate_passport(pass, [ head | tail]) do
        case String.match?(pass,head) do
            true -> validate_passport(pass, tail)
            false -> :invalid
        end
    end

    def validate_passport(pass, []) do
        :valid   
    end

    def part2(passports) do
        IO.puts("Not yet implemented")
    end
end