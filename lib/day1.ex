defmodule AdventofCode2023.Day1 do

  @nums [
    {"one", "1"},
    {"two", "2"},
    {"three","3"},
    {"four", "4"},
    {"five", "5"},
    {"six", "6"},
    {"seven", "7"},
    {"eight", "8"},
    {"nine", "9"}
  ]

  def calibrate_trebuchet(cali_info) do
    cali_info
    |> String.split("\n")
    |> Enum.map(fn x -> process_cali_info(x) end)
    |> Enum.sum()
  end

  def process_cali_info(info) do
    convert_words_to_nums(info)
    |> retrieve_cali_value()
  end

  def retrieve_cali_value(row) do
    allints = String.replace(row, ~r/[^\d+]/, "")
    case String.length(allints) do
      0 -> 0
      _ ->
        x = String.to_integer(String.at(allints, 0))
        y = String.to_integer(String.at(allints, -1))
        10 * x + y
    end
  end

  def convert_words_to_nums(s) do
    # no need to convert if ends with number
    t = case String.match?(s, ~r/\d$/) do
      true -> s
      false -> convert_words_to_nums(s, :last)
    end
    # no need to convert if begins with number
    case String.match?(t, ~r/^\d/) do
      true -> t
      false -> convert_words_to_nums(t, :first)
    end
  end

  def convert_words_to_nums(s, direction) do
    case convert_words_to_nums(s, @nums, :nochange, direction) do
      {:ok, result} ->
        result
      {:more, result} ->
        result
    end
  end

  def convert_words_to_nums(s, [], accum, direction) do
    case accum do
      :nochange -> {:ok, s}
      {start, snum, num} ->
        lensnum = String.length(snum)
        # is there already a digit before or after planned replacement?
        case digit_exists?(s, start, lensnum, direction) do
          true -> {:ok, s}
          false ->
            {
              :more,
              String.slice(s, 0, start) <> num <> String.slice(s, start + lensnum, String.length(s) - start - lensnum)
            }
        end
      #String.replace(s, snum, num, global: false)}
    end
  end

  def convert_words_to_nums(s, nums, accum, direction) do
    [h | t] = nums
    {snum, num} = h
    case Util.string_index(s, snum, direction) do
      :nomatch->
        convert_words_to_nums(s, t, accum, direction)
      {start, _length} ->
        case accum do
          :nochange-> convert_words_to_nums(s, t, {start, snum, num}, direction)
          {xstart, _, _}  ->
            compare = case direction do
              :first -> &less_than/2
              :last -> &greater_than/2
            end
            case compare.(start, xstart) do
              true -> convert_words_to_nums(s, t, {start, snum, num}, direction)
              false -> convert_words_to_nums(s, t, accum, direction)
            end
          _ -> convert_words_to_nums(s, t, accum, direction)
        end
    end
  end

  def digit_exists?(s, start, lensnum, direction) do
    case direction do
      :first -> String.match?(String.slice(s, 0, start), ~r/\d/)
      :last -> String.match?(String.slice(s, start + lensnum, String.length(s) - start - lensnum), ~r/\d/)
    end
  end

  def less_than(x, y) do
    x < y
  end

  def greater_than(x, y) do
    x > y
  end

end

# stolen from https://gist.github.com/samueltardieu/aeb98eaaaf0fe8b73127bb29c7463b75
# very different (much better then mine) approach, was helpful to diagnose bugs
defmodule AdventofCode2023.Day1a do

  @digits 1..9 |> Enum.map(&{"#{&1}", &1}) |> Map.new()

  def first(line, table) do
    {s, l} = :binary.match(line, table |> Map.keys())
    table |> Map.fetch!(String.slice(line, s, l))
  end

  def solve(input, table) do
    rtable = table |> Enum.map(fn {s, n} -> {s |> String.reverse(), n} end) |> Map.new()

    input
    |> Enum.map(&(first(&1, table) * 10 + first(&1 |> String.reverse(), rtable)))
    |> Enum.sum()
  end

  def part1(input) do
    input |> solve(@digits)
  end

  def part2(input) do
    numbers =
      ~w(one two three four five six seven eight nine)s
      |> Enum.zip(1..9)
      |> Map.new()
      |> Map.merge(@digits)

    input |> solve(numbers)
  end

end
