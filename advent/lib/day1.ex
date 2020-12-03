defmodule Day1 do
    def read_file() do
    	case File.read("../input/day1.txt") do
				{:ok, body} -> 
					String.split(body, "\n")
					|> Enum.map(fn x -> String.to_integer(x) end)
				{:error, reason} -> IO.puts(reason)
			end
    end

	def start() do
		input = read_file()
		IO.puts(part1(input))
		IO.puts(part2(input))
	end

	def two_sums_to_2020(num, []), do: {:empty, nil}

	def two_sums_to_2020(num, [head | tail]) do
		cond do
			num + head == 2020 ->
				{:ok, head}
			tail == [] ->
				{:empty, nil}
			true ->
				two_sums_to_2020(num, tail)
		end
	end

	def part1([head | tail]) do
		case two_sums_to_2020(head, tail) do
			{:ok, result} -> head * result
			{:empty, _} -> part1(tail)
		end
	end

	def three_sums_to_2020(num, []), do: {:empty, nil}

	def three_sums_to_2020(num, [head | tail]) do
		cond do
			num + head < 2020 -> 
				case two_sums_to_2020(num + head, tail) do
					{:ok, result} -> {:ok, num * head * result }
					{:empty, _} -> three_sums_to_2020(num,tail)
				end
			tail == [] ->
				{:error, nil}
			true -> three_sums_to_2020(num, tail)
		end
	end

	def part2([head | tail]) do
		case three_sums_to_2020(head, tail) do
			{:ok, result} -> result
			{error, _} -> part2(tail)
		end
	end
end
