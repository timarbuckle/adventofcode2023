defmodule Adventofcode2023Test do
  use ExUnit.Case

  doctest Adventofcode2023

  test "greets the world" do
    assert Adventofcode2023.hello() == :world
  end

  test "Day 1  Trebuchet?!" do
    calibration_info = "1abc2\npqr3stu8vwx\na1b2c3d4e5f\ntreb7uchet"
    assert Adventofcode2023.calibrate_trebuchet(calibration_info) == 142
  end

  test "Day 1 Puzzle" do
    {:ok, calibration_info} = File.read("test/day1_test.txt")
    assert Adventofcode2023.calibrate_trebuchet(calibration_info) == 54081
  end
end
