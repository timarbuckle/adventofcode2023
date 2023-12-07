defmodule AdventofCode2023.Day4 do
  def winning_cards(rows) do
    rows
    |> winning_cards_helper()
    |> Enum.map(fn {_, x} ->
      case MapSet.size(x) do
        0 -> 0
        n -> Integer.pow(2, n - 1)
      end
    end)
    |> Enum.sum()
  end

  def winning_cards2(rows) do
    rows
    |> winning_cards_helper()
    |> Enum.map(fn {card, intersection} -> {card, intersection, 1} end)
    |> find_total_scratchcards()
  end

  def winning_cards_helper(rows) do
    rows
    |> Enum.map(fn line -> String.split(line, ":") end)
    |> Enum.map(fn [card , data] -> {card, String.split(data, "|")} end)
    |> Enum.map(fn {card, [x, y]} -> {card, {String.split(x, " ", trim: true), String.split(y, " ", trim: true)}} end)
    |> Enum.map(fn {card, {x, y}} -> {card, {MapSet.new(x), MapSet.new(y)}} end)
    |> Enum.map(fn {card, {x, y}} -> {card, MapSet.intersection(x, y)} end)
  end


  def find_total_scratchcards(scratchcards, accum \\ [])

  def find_total_scratchcards([], accum) do
    Enum.reverse(accum)
    |> Enum.reduce(0, fn {_, _, x}, acc -> x + acc end)
  end

  def find_total_scratchcards(scratchcards, accum) do
   [h | t] = scratchcards
   {_card_id, intersects, count} = h
   i = MapSet.size(intersects)
   t2 = update_counts(t, i, count)
   find_total_scratchcards(t2, [h | accum])
  end


  def update_counts(cards, i, count, accum \\ [])

  def update_counts(cards, 0, _count, accum) do
    Enum.reverse(accum) ++ cards
  end

  def update_counts([], 0, _count, accum) do
    Enum.reverse(accum)
  end

  def update_counts(cards, i, count, accum) do
   [h | t] = cards
   {card_id, intersects, current_count} = h
    update_counts(t, i - 1, count, [{card_id, intersects, current_count + count} | accum])
  end
end
