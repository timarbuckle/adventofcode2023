defmodule Day4Test do
  use ExUnit.Case
  import AdventofCode2023.Day4

  test "Day 4 Winning Cards 1" do
    data = File.read!("test/day4_test1.txt") |> String.split("\n", trim: true)
    assert winning_cards(data) == 13
  end

  test "Day 4 Winning Cards 2" do
    data = File.read!("test/day4_test2.txt") |> String.split("\n", trim: true)
    assert winning_cards(data) == 26914
  end
end
