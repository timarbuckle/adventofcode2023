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

  test "Day 7 Camel Cards Part2.1" do
    data = Util.read_file("test/day7_test1.txt")
    assert camel_cards_2(data) == 5905
  end

  test "Day 7 Camel Cards Part2.2" do
    data = Util.read_file("test/day7_test2.txt")
    assert camel_cards_2(data) == 250665248
  end
end
