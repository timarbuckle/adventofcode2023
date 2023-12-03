defmodule Util do

  def string_index(string, substring) do
    string_index(string, substring, :first)
  end

  def string_index(string, substring, :first) do
    case :binary.match string, substring do
      :nomatch -> :nomatch
      {start, length} -> {start, length}
    end
  end

  def string_index(string, substring, :last) do
    case :binary.match String.reverse(string), String.reverse(substring) do
      :nomatch -> :nomatch
      {start, length} -> {String.length(string) - start - length, length}
    end
  end


  def compare_lists([], _l2, _row) do
    IO.puts("done")
  end

  def compare_lists(_l1, [], _row) do
    IO.puts("done")
  end

  def compare_lists(l1, l2, row) do
    [h1 | t1] = l1
    [h2 | t2] = l2
    if h1 != h2 do
        IO.puts("row #{row} #{h1} != #{h2}")
    end
    compare_lists(t1, t2, row + 1)
  end

end
