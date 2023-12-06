defmodule Day3Test do
  use ExUnit.Case
  import AdventofCode2023.Day3

  test "schematic total 1" do
    data = File.read!("test/day3_test1.txt") |> String.split("\n")
    assert process_schematic(data) == 4361
  end

  test "schematic total 2" do
    data = File.read!("test/day3_test2.txt") |> String.split("\n")
    assert process_schematic(data) == 509115
  end

  test "schematic gear ratios test 1" do
    data = File.read!("test/day3_test1.txt") |> String.split("\n")
    assert gear_ratios_sum(data) == 467835
  end

  test "schematic gear ratios test 2" do
    data = File.read!("test/day3_test2.txt") |> String.split("\n")
    assert gear_ratios_sum(data) == 75220503
  end
end
