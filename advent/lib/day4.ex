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
        #IO.puts(input |> part1)
        IO.puts(input |> map_input |> part2)
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

    def validate_passport(_, []) do
        :valid   
    end

    def map_input(input) do
        input
        |> Enum.map(fn x -> String.split(x, " ") end)
        |> Enum.map(fn x -> transform_to_map(x) end)
    end

    def transform_to_map(pass) do
        Enum.map(pass, fn x -> 
            [ k | [ v | _ ]] = String.split(x, ":") 
            {k, v}
        end)
        |> Map.new
    end

    def part2(passports) do
        Enum.map(passports, fn x -> validate_passport_2(x) end) |> Enum.filter(fn x -> x === true end) |> length

    end

    def validate_passport_2(pass) do
        field_strings = ["ecl", "pid", "eyr", "hcl", "byr", "iyr", "hgt"]
        case is_valid(pass, field_strings) do
            
            :valid -> 
                Map.get(pass, "byr") |> String.to_integer |> time_range(1920, 2002)
                && Map.get(pass, "iyr") |> String.to_integer |> time_range(2010, 2020)
                && Map.get(pass, "eyr") |> String.to_integer |> time_range(2020, 2030)
                && Map.get(pass, "hgt") |> validate_height
                && Map.get(pass, "hcl") |> String.match?(~r/^#[a-fA-F0-9]{6}$/)
                && Map.get(pass, "ecl") |> validate_eyecolor
                && Map.get(pass, "pid") |> String.match?(~r/^[0-9]{9}$/)
            :invalid ->
                false
        end
    end

    def is_valid(pass, [ head | tail]) do
        case Map.get(pass,head) do
            nil -> :invalid
            _ -> is_valid(pass, tail)
        end
    end

    def is_valid(_, []) do
        :valid   
    end

    def time_range(x, lower, upper) do
        x >= lower and x <= upper
    end

    def validate_height(height) do
        case String.match?(height, ~r/cm/) do
            true ->
                [num | _] = String.split(height, "c")
                time_range(String.to_integer(num), 150, 193)
            false ->
                case String.match?(height, ~r/in/) do
                    true ->
                        [num | _] = String.split(height, "i")
                        time_range(String.to_integer(num), 59, 76)
                    false -> false
                end

                
        end
    end

    def validate_eyecolor(clr) do
        colors = [~r/^amb/, ~r/^blu/, ~r/^brn/, ~r/^gry/, ~r/^grn/, ~r/^hzl/, ~r/^oth/]
        l = Enum.filter(colors, fn x -> String.match?(clr, x) end)
        
        length(l) === 1
    end
end
