defmodule AdventofCode2023.Day3 do

  def schematic_sum(schematic) do
    schematic
    |> Enum.map(fn x ->
      String.split(x, ~r/[^0-9]/, trim: true)
      |> Enum.map(fn x -> String.to_integer(x) end)
      |> Enum.sum()
    end)
    |> Enum.sum()
  end

  def gear_ratios_sum(schematic) do
    {snums, symbols} = process_schematic(schematic, 0, [], [])
    Enum.filter(symbols, fn {sym, _, _} -> sym == "*" end)
    #|> Enum.map(fn {symbol, rowx, colx} -> {symbol, find_gears_total({symbol, rowx, colx}, snums)} end)
    |> Enum.map(fn {symbol, rowx, colx} -> find_gears_total({symbol, rowx, colx}, snums) end)
    |> Enum.reduce(0, fn {_, x}, acc -> x + acc end)
  end

  def find_gears_total({symbol, rowx, colx}, snums) do
    snums2 = Enum.filter(snums, fn {_, row, col, len} -> overlap({row, col, len}, {rowx, colx}) end)
    #IO.inspect(snums2)
    case length(snums2) do
      0 -> {symbol, 0}
      1 -> {symbol, 0}
      2 -> {symbol,
          Enum.map(snums2, fn {snum, _, _, _} -> String.to_integer(snum) end)
          |> Enum.reduce(1, fn element, acc -> acc * element end)
        }
      x ->
        IO.puts("unexpected gears total: #{x}")
        {symbol, 0}
    end
  end

  @spec process_schematic([binary()]) :: {list(), list()}
  def process_schematic(schematic) do
    {snums, symbols} = process_schematic(schematic, 0, [], [])
    Enum.filter(snums, fn x -> is_overlap(x, symbols) end)
    |> Enum.map(fn {x, _, _, _} -> String.to_integer(x) end)
    |> Enum.sum()
  end

  def process_schematic([], _, snums, symbols) do
    {Enum.reverse(snums), Enum.reverse(symbols)}
  end

  def process_schematic([h|t], rownum, snums, symbols) do
    {snums2, symbols2} = process_schematic_row(h, rownum)
    #|> cleanup_tokens(snums, symbols)
    # h is a line in the schematic
    process_schematic(t, rownum + 1, snums2 ++ snums, symbols2 ++ symbols)
  end

  def process_schematic_row(row, rownum) do
    # find number indexes
    nums = Regex.scan(~r/\d+/, row, return: :index)
    |> Enum.map(fn [{start, len}] -> {String.slice(row, start, len), rownum, start, len} end)
    # [[{3, 3}], [{9, 3}]]
    # find symbol indexes
    symbols = Regex.scan(~r/[^\d\.]/, row, return: :index)
    |> Enum.map(fn [{start, len}] -> {String.slice(row, start, len), rownum, start} end)
    #[[{1, 1}], [{13, 1}]]
    {nums, symbols}
  end

  def cleanup_tokens([], snums, symbols) do
    {snums, symbols}
  end

  def cleanup_tokens([h | t], snums, symbols) do
    {token, row, {col, len}} = h
    case String.match?(token, ~r/[\d+]/) do
      true -> cleanup_tokens(t, [{String.to_integer(token), {row, col, len}, false} | snums], symbols)
      false -> cleanup_tokens(t, snums, [{token, snums, {row, col}} | symbols])
    end
  end

  def is_overlap(_, []) do
    false
  end

  def is_overlap({num, row, col, len}, symbols) do
    [h | t] = symbols
    {_sym, rowx, colx} = h
    #IO.puts("checking symbol #{sym}, #{rowx}, #{colx}")
    case overlap({row, col, len}, {rowx, colx}) do
      true -> true
      false -> is_overlap({num, row, col, len}, t)
    end
  end

  #  detect if a word is adjacent to a symbol
  def overlap({row, col, len}, {rowx, colx}) do
    row1 = max(rowx - 1, 0)
    col1 = max(colx - 1, 0)
    row2 = rowx + 1
    col2 = colx + 1
    overlap({row, col, len}, {row1, col1, row2, col2})
  end

  def overlap({_row, _col, 0}, {_row1, _col1, _row2, _col2}) do
    false
  end

  def overlap({row, col, len}, {row1, col1, row2, col2}) do
    #IO.puts("row: #{row} col: #{col}")
    #IO.puts("row1: #{row1} col1: #{col1} row2: #{row2} col2:#{col2}")
    case row >= row1 and row <= row2 and col >= col1 and col <= col2 do
      true -> true
      false -> overlap({row, col+1, len-1}, {row1, col1, row2, col2})
    end
  end

  """
  get {word/number, row, col, length, has_symbol}
  generate box around word, excluding values outside box,e.g {row, col, row, col}
  for symbol, check if within bouding box for each word, set has_symbol if does
  remove, words where has_symbol = false
  calculate sum
  """
end
