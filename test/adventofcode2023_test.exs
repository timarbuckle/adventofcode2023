defmodule AdventofCode2023Test do
  use ExUnit.Case
  import AdventofCode2023.Day1

  doctest AdventofCode2023

  test "greets the world" do
    assert AdventofCode2023.hello() == :world
  end

  test "Day 1  Trebuchet?!" do
    calibration_info = "1abc2\npqr3stu8vwx\na1b2c3d4e5f\ntreb7uchet"
    assert calibrate_trebuchet(calibration_info) == 142
  end

  test "Day 1 Puzzle" do
    {:ok, calibration_info} = File.read("test/day1_test.txt")
    assert calibrate_trebuchet(calibration_info) == 54642
  end

  test "Day 1 Convert word to numbers" do
    assert convert_words_to_nums("onexxxsevenyyyninezzzoneyuiitwojjjnine") == "1xxxsevenyyyninezzzoneyuiitwojjj9"
    assert convert_words_to_nums("eightwothree") == "8wo3"
    assert convert_words_to_nums("4nineeightseven2") == "49eight72"
    assert convert_words_to_nums("zoneight234") == "z1ight234"
  end

  test "Day 1 Part 2" do
    calibration_info = "two1nine
    eightwothree
    abcone2threexyz
    xtwone3four
    4nineeightseven2
    zoneight234
    7pqrstsixteen"

    assert calibrate_trebuchet(calibration_info) == 281
  end

  test "Day 1a Part 2" do
    {:ok, calibration_file} = File.read("test/day1_test.txt")
    calibration_info = String.split(calibration_file, "\n")
    assert AdventofCode2023.Day1a.part2(calibration_info) == 54649
  end
end
