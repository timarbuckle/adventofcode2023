defmodule AdventofCode2023.Day4 do
  def winning_cards(rows) do
    rows
    |> Enum.map(fn line -> String.split(line, ":") end)
    |> Enum.map(fn [_card , data] -> String.split(data, "|") end)
    |> Enum.map(fn [x, y] -> {String.split(x, " ", trim: true), String.split(y, " ", trim: true)} end)
    |> Enum.map(fn {x, y} -> {MapSet.new(x), MapSet.new(y)} end)
    |> Enum.map(fn {x, y} -> MapSet.intersection(x, y) end)
    |> Enum.map(fn x ->
      case MapSet.size(x) do
        0 -> 0
        n -> Integer.pow(2, n - 1)
      end
    end)
    |> Enum.sum()
  end
end
