defmodule Day5 do

    def read_file() do
        case File.read("../input/day5.txt") do
            {:ok, body} -> String.split(body, "\n")
            {:error, msg} -> IO.puts(msg)
        end
    end

    def start() do
        input = read_file()
        IO.puts(input |> part1)
        IO.puts(input |> part2)
    end

    def part1(input) do
        input
        |> Enum.map(fn x -> locate_seat(x) end)
        |> find_highest_seat
    end

    def locate_seat(seat) do
            a = String.slice(seat, 0..6) |> String.graphemes |> setup_search(127, {"F", "B"})
            b = String.slice(seat, 7..String.length(seat)) |> String.graphemes |> setup_search(7, {"L", "R"})
            {a,b}
    end

    def find_highest_seat(seats) do
        seats
        |> Enum.map(fn x -> seat_id(x) end)
        |> Enum.max
    end

    def setup_search(l, high, range) do
        search(l, {0, high}, range)
    end

    def search([head | tail], {low, high}, range) do
        {a, b} = range
        cond do
            tail === [] ->
                cond do
                    head === a -> low
                    head === b -> high
                end
            true ->
                cond do
                    head === a ->
                        search(tail, {low   , div(high,2) + div(low,2)}, range)
                    head === b ->
                        search(tail, {div(low,2) + div(high,2) + 1, high}, range)     
                end
        end
        
    end

    def seat_id({ row, column }), do: row * 8 + column

    def part2(input) do
        seats = input
                |> Enum.map(fn x -> locate_seat(x) end)
                |> Enum.map(fn x -> seat_id(x) end)

        Enum.to_list(Enum.min(seats)..Enum.max(seats))
        |> Enum.find(fn x -> not Enum.member?(seats, x) end)
    end

end