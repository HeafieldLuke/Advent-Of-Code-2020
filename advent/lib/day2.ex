defmodule Day2 do

    def read_file() do
        case File.read("../input/day2.txt") do
            {:ok, body} -> process_passwords(body)
            {:error, reason} -> IO.puts(reason)
        end
    end

    def process_passwords(body) do
        String.split(body, "\n")
        |> Enum.map(fn x -> parse_password(x) end)
    end

    def parse_password(pass) do
        [range | [ letter | [ pass | _ ]]] = String.split(pass, " ")
        [low | [ high | _ ]] = String.split(range, "-")
        letter = String.at(letter, 0)

        %{
            "range" => {String.to_integer(low), String.to_integer(high)},
            "letter" => letter,
            "password" => pass
        }
    end

    
    def start() do
        input = read_file()
        IO.puts(part1(input))
        IO.puts(part2(input))
    end

    def part1(passwords) do
        List.foldl(passwords,0,&separate_passwords_1/2)
    end

    def part2(passwords) do
        List.foldl(passwords,0,&separate_passwords_2/2)
    end

    def separate_passwords_1(x,acc) do
        case is_valid_password_1(x) do
            :valid -> acc + 1
            :invalid -> acc
        end
    end

    def separate_passwords_2(x,acc) do
        case is_valid_password_2(x) do
            :valid -> acc + 1
            :invalid -> acc  
        end  
    end

    def is_valid_password_1(password_criteria) do
        pass_list = String.split(password_criteria["password"], "")
        {low, high} = password_criteria["range"]
        sum = List.foldl(pass_list, 0, fn x, acc -> if x == password_criteria["letter"], do: acc + 1, else: acc end)
        cond do
            sum < low or sum > high -> :invalid
            true -> :valid
        end
    end

    def is_valid_password_2(password_criteria) do
        pass_list = String.split(password_criteria["password"], "")
        {low, high} = password_criteria["range"]
        letter = password_criteria["letter"]
        IO.puts(Enum.at(pass_list, low))
        cond do
            Enum.at(pass_list, low) !== letter and Enum.at(pass_list, high) === letter -> :valid
            Enum.at(pass_list, low) === letter and Enum.at(pass_list, high) !== letter -> :valid
            true -> :invalid
        end
    end
end