defmodule Shunt do
  def few(_, []) do [] end
  def few(xs, ys) do
    cond do
      xs == ys ->
        []
      true ->
        [y | yt] = ys
        {hs, ts} = split(xs, y)

        moves = [
          {:one, 1 + Enum.count(ts)},
          {:two, Enum.count(hs)},
          {:one, -(1 + Enum.count(ts))},
          {:two, -(Enum.count(hs))}
        ]

        if Enum.count(hs) == 0 do
          [] ++ few(ts, yt)
        else
          moves ++ few(ts ++ hs, yt)
        end
    end
  end

  def rules([]) do [] end
  def rules([a]) do
    {t, n} = a
    cond do
      n == 0 ->
        []
      true ->
        [a]
    end
  end
  def rules([a, b|t]) do
    {at, an} = a
    {bt, bn} = b
    cond do
      at == :one and bt == :one ->
        rules([{:one, an+bn}|t])
      at == :two and bt == :two ->
        rules([{:two, an+bn}|t])
      an == 0 ->
        rules([b|t])
      true ->
        [a] ++ rules([b|t])
    end
  end

  def compress(ms) do
    ns = rules(ms)
    cond do
      ns == ms -> ms
      true -> compress(ns)
    end
  end


  def find(_, []) do [] end
  def find(xs, ys) do
    cond do
      xs == ys ->
        []
      true ->
        [y | yt] = ys
        {hs, ts} = split(xs, y)

        moves = [
          {:one, 1 + Enum.count(ts)},
          {:two, Enum.count(hs)},
          {:one, -(1 + Enum.count(ts))},
          {:two, -(Enum.count(hs))}
        ]

        moves ++ find(ts ++ hs, yt)
    end
  end


  def split(list, x) do
    p = ListMod.position(list, x)
    case p do
      1 ->
        {[], ListMod.drop(list, p)}
      _ ->
        {ListMod.take(list, p-1), ListMod.drop(list, p)}
    end
  end
end
