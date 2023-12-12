defmodule Day7Test do
  use ExUnit.Case
  import AdventofCode2023.Day7

  test "Day 7 Camel Cards Part1.1" do
    data = Util.read_file("test/day7_test1.txt")
    assert camel_cards_1(data) == 6440
  end

  test "Day 7 Camel Cards Part1.2" do
    data = Util.read_file("test/day7_test2.txt")
    assert camel_cards_1(data) == 250120186
  end
end
