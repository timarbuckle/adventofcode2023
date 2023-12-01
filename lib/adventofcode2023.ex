defmodule Adventofcode2023 do
  @moduledoc """
  Documentation for `Adventofcode2023`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Adventofcode2023.hello()
      :world

  """
  def hello do
    :world
  end

  def calibrate_trebuchet(cali_info) do
    cali_info
    |> String.split("\n")
    |> Enum.map(fn x -> retrieve_cali_value(x) end)
    |> Enum.sum()
  end

  defp retrieve_cali_value(row) do
    #IO.puts("-----")
    #IO.puts("row #{row}")
    allints = String.replace(row, ~r/[^\d+]/, "")
    #IO.puts("allints #{allints}")
    case String.length(allints) do
      0 -> 0
      _ ->
        x = String.to_integer(String.at(allints, 0))
        y = String.to_integer(String.at(allints, -1))
        #IO.puts("sum #{10*x + y}")
        10 * x + y
    end
  end

end
