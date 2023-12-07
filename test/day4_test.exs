defmodule Day4Test do
  use ExUnit.Case
  import AdventofCode2023.Day4

  test "Day 4 Winning Cards Part1.1" do
    data = Util.read_file("test/day4_test1.txt")
    assert winning_cards(data) == 13
  end

  test "Day 4 Winning Cards Part1.2" do
    data = Util.read_file("test/day4_test2.txt")
    assert winning_cards(data) == 26914
  end

  test "Day 4 Winning Cards Part2.1" do
    data = Util.read_file("test/day4_test1.txt")
    assert winning_cards2(data) == 30
  end

  test "Day 4 Winning Cards Part2.2" do
    data = Util.read_file("test/day4_test2.txt")
    assert winning_cards2(data) == 13080971
  end
end
