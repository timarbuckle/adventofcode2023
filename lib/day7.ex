defmodule AdventofCode2023.Day7 do

  @handstrength %{
    highhand: "1",
    pair: "2",
    twopair: "3",
    set: "4",
    fullhouse: "5",
    fourkind: "6",
    fivekind: "7"
  }

  @cardvalue %{
    "2" => "2",
    "3" => "3",
    "4" => "4",
    "5" => "5",
    "6" => "6",
    "7" => "7",
    "8" => "8",
    "9" => "9",
    "T" => "A",
    "J" => "B",
    "Q" => "C",
    "K" => "D",
    "A" => "E"
  }

@cardvalue2 %{
  "2" => "2",
  "3" => "3",
  "4" => "4",
  "5" => "5",
  "6" => "6",
  "7" => "7",
  "8" => "8",
  "9" => "9",
  "T" => "A",
  "J" => "1",
  "Q" => "C",
  "K" => "D",
  "A" => "E"
}

  def camel_cards_1(data) do
    data
    # splits "T55J5 123" into ["T55J5", "123"], aka hand, bid
    |> Enum.map(fn x -> String.split(x, " ") end)
    # ["T55J5", "123"] becomes {"T55J5", {:set, ["5", "5", "5", "J", "T"]}, 123}
    |> Enum.map(fn [hand, bid] -> {hand, id_hand(hand), String.to_integer(bid)} end)
    |> rank_hands()
    |> total_winnings()
    #|> Enum.map(fn x -> IO.inspect(x) end)
  end

  def camel_cards_2(data) do
    data
    # splits "T55J5 123" into ["T55J5", "123"], aka hand, bid
    |> Enum.map(fn x -> String.split(x, " ") end)
    # ["T55J5", "123"] becomes {"T55J5", {:set, ["5", "5", "5", "J", "T"]}, 123}
    |> Enum.map(fn [hand, bid] -> {hand, id_hand2(hand), String.to_integer(bid)} end)
    |> rank_hands2()
    |> total_winnings()
    #|> Enum.map(fn x -> IO.inspect(x) end)
  end

  def total_winnings(cardinfo) do
    [h | t] = cardinfo
    {_hand, _x, bid} = h
    #IO.puts("1: #{inspect(h)}) -> #{bid}")
    total_winnings(t, 2, bid)
  end

  def total_winnings([], _index, accum) do
    accum
  end

  def total_winnings(cardinfo, index, accum) do
    [h | t] = cardinfo
    {_hand, _x, bid} = h
    #IO.puts("#{index}: #{inspect(h)}) -> #{index * bid} -> #{accum + (index * bid)}")
    total_winnings(t, index + 1, accum + (index * bid))
  end

  def id_hand(h) do
    #IO.puts("id_hand received #{h}")
    h2 =
    #String.graphemes(h)
    String.split(h, "", trim: true)
    |> Enum.sort()
    |> find_and_count_repeated_items()
    case h2 do
      [{_x, 1}, _, _, _, _] -> {:highhand, normalize_highhand(h2)}
      [{_x, 2}, _w, _y, _z] -> {:pair, normalize_pair_or_set(h2)}
      [w, {x, 2}, y, z] -> {:pair, normalize_pair_or_set([{x, 2}, w, y, z])}
      [w, y, {x, 2}, z] -> {:pair, normalize_pair_or_set([{x, 2}, w, y, z])}
      [w, y, z, {x, 2}] -> {:pair, normalize_pair_or_set([{x, 2}, w, y, z])}
      [{_x, 2}, {_y, 2}, _] -> {:twopair, normalize_two_pair(h2)}
      [{x, 2}, z, {y, 2}] -> {:twopair, normalize_two_pair([{x, 2}, {y, 2}, z])}
      [z, {x, 2}, {y, 2}] -> {:twopair, normalize_two_pair([{x, 2}, {y, 2}, z])}
      [{_x, 3}, _, _] -> {:set, normalize_pair_or_set(h2)}
      [{y, 1}, {x, 3}, {z, 1}] -> {:set, normalize_pair_or_set([{x, 3}, {y, 1}, {z, 1}])}
      [{y, 1}, {z, 1}, {x, 3}] -> {:set, normalize_pair_or_set([{x, 3}, {y, 1}, {z, 1}])}
      [{_x, 3}, {_y, 2}] -> {:fullhouse, h2}
      [{y, 2}, {x, 3}] -> {:fullhouse, [{x, 3}, {y, 2}]}
      [{_x, 4}, _] -> {:fourkind, h2}
      [{y, 1}, {x, 4}] -> {:fourkind, [{x, 4}, {y, 1}]}
      [{_x, 5}] -> {:fivekind, h2}
    end
  end

  def id_hand2(h) do
    {type, hand} = id_hand(h)
    case Enum.filter(hand, fn {x, _} -> x == "J" end) do
      [] -> {type, hand}
      [{"J", count}] ->
        case {type, count} do
          {:highhand, 1} -> {:pair, hand}
          {:pair, _} -> {:set, hand}
          {:twopair, 2} -> {:fourkind, hand}
          {:twopair, 1} -> {:fullhouse, hand}
          {:set, _} -> {:fourkind, hand}
          {:fullhouse, _} -> {:fivekind, hand}
          {:fourkind, _} -> {:fivekind, hand}
          {:fivekind, _} -> {:fivekind, hand}
        end
    end
  end

  def normalize_pair_or_set(cards) do
    [h | t] = cards
    [h | normalize_highhand(t)]
  end

  def normalize_two_pair([{x, 2}, {y, 2}, z]) do
    x1 = Map.fetch!(@cardvalue, x)
    y1 = Map.fetch!(@cardvalue, y)

    case x1 > y1 do
      true -> [{x, 2}, {y, 2}, z]
      false -> [{y, 2}, {x, 2}, z]
    end
  end

  def normalize_highhand(hand) do
    Enum.sort_by(hand, fn {x, _} -> Map.fetch!(@cardvalue, x) end, :desc)
  end

  def find_and_count_repeated_items(list) do
    list
    |> Enum.reduce(%{}, fn item, counts ->
      Map.update(counts, item, 1, &(&1 + 1))
    end)
    #|> Map.filter(fn {_, count} -> count > 1 end)
    |> Map.to_list()
    |> Enum.sort(&(&1 >= &2))
  end

  def rank_hands(list) do
    Enum.sort_by(list, fn {hand, {type, _cards}, _bid} -> rank_hand({hand, type}) end)
  end

  def rank_hand({hand, type}) do
    hs = Map.fetch!(@handstrength, type)
    hand_list = String.split(hand, "", trim: true)
    hand_list_revised = Enum.map(hand_list, fn x -> Map.fetch!(@cardvalue, x) end)
    #IO.puts("Type #{type} handstrength #{hs}")
    hs <> List.to_string(hand_list_revised)
    #rankvalues =
    #  case {type, cards2} do
    #    {:highhand, [{a, 1}, {b, 1}, {c, 1}, {d, 1}, {e, 1}]} -> [hs, a, b, c, d, e]
    #    {:pair, [{a, 2}, {b, 1}, {c, 1}, {d, 1}]} -> [hs, a, b, c, d, "0"]
    #    {:twopair, [{a, 2}, {b, 2}, {c, 1}]} -> [hs, a, b, c, "0", "0"]
    #    {:set, [{a, 3}, {b, 1}, {c, 1}]} -> [hs, a, b, c, "0", "0"]
    #    {:fullhouse, [{a, 3}, {b, 2}]} -> [hs, a, b, "0", "0", "0"]
    #    {:fourkind, [{a, 4}, {b, 1}]} -> [hs, a, b, "0", "0", "0"]
    #    {:fourkind, [{b, 1}, {a, 4}]} -> [hs, a, b, "0", "0", "0"]
    #    {:fivekind, [{a, 5}]} -> [hs, a, "0", "0", "0", "0"]
        #_ -> IO.puts("Unexpected case value for cards #{inspect(cards)}")
    #  end
      #IO.puts("rankvalues #{inspect(rankvalues)}")
    #  {totalrank, _} = Integer.parse(List.to_string(rankvalues), 16)
    #  totalrank
  end

  def rank_hands2(list) do
    Enum.sort_by(list, fn {hand, {type, _cards}, _bid} -> rank_hand2({hand, type}) end)
  end

  def rank_hand2({hand, type}) do
    hs = Map.fetch!(@handstrength, type)
    hand_list = String.split(hand, "", trim: true)
    hand_list_revised = Enum.map(hand_list, fn x -> Map.fetch!(@cardvalue2, x) end)
    hs <> List.to_string(hand_list_revised)
  end

  def old_rank_hand({_hand, type, cards}) do
    hs = Map.fetch!(@handstrength, type)
    cards2 = Enum.map(cards, fn {x, val} -> {Map.fetch!(@cardvalue, x), val} end)
    #IO.puts("Type #{type} handstrength #{hs}")
    rankvalues =
      case {type, cards2} do
        {:highhand, [{a, 1}, {b, 1}, {c, 1}, {d, 1}, {e, 1}]} -> [hs, a, b, c, d, e]
        {:pair, [{a, 2}, {b, 1}, {c, 1}, {d, 1}]} -> [hs, a, b, c, d, "0"]
        {:twopair, [{a, 2}, {b, 2}, {c, 1}]} -> [hs, a, b, c, "0", "0"]
        {:set, [{a, 3}, {b, 1}, {c, 1}]} -> [hs, a, b, c, "0", "0"]
        {:fullhouse, [{a, 3}, {b, 2}]} -> [hs, a, b, "0", "0", "0"]
        {:fourkind, [{a, 4}, {b, 1}]} -> [hs, a, b, "0", "0", "0"]
        {:fourkind, [{b, 1}, {a, 4}]} -> [hs, a, b, "0", "0", "0"]
        {:fivekind, [{a, 5}]} -> [hs, a, "0", "0", "0", "0"]
        #_ -> IO.puts("Unexpected case value for cards #{inspect(cards)}")
      end
      #IO.puts("rankvalues #{inspect(rankvalues)}")
      {totalrank, _} = Integer.parse(List.to_string(rankvalues), 16)
      totalrank
  end
end
