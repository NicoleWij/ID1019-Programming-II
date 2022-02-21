defmodule ListMod do
  def take(_, 0) do [] end
  def take([], _) do [] end
  def take([head | tail],n) do
    [head | take(tail, n-1)]
  end

  def drop(xs, 0) do xs end
  def drop([], n) do [] end
  def drop([head|tail], n) do
    drop(tail, n-1)
  end

  def append(l1,l2) do
    l1 ++ l2
  end

  def member([head | tail], x) do
    cond do
      x == head ->
        true
      tail == [] ->
        false
      true ->
        member(tail,x)
    end
  end

  def position([head|tail], x) do
    cond do
      x == head ->
        1
      true ->
        position(tail, x)+1
    end
  end
end
