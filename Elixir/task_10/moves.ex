defmodule Moves do
  def state() do
    {[:a,:b],[:c, :d],[:e, :f]}
  end

  def single({track, steps},{main, one, two}) do
    cond do
      steps > 0 ->
        l = length(main)
        new_main = ListMod.take(main, l-steps)
        move_train = ListMod.drop(main, l-steps)
        case track do
          :one -> {new_main,ListMod.append(move_train, one),two}
          :two -> {new_main,one,ListMod.append(move_train, two)}
        end
      steps < 0 ->
        case track do
          :one ->
            l = length(one)
            move_train = ListMod.take(one, -steps)
            new_main = ListMod.append(main, move_train)
            new_one = ListMod.drop(one, -steps)
            {new_main,new_one,two}
          :two ->
            l = length(two)
            move_train = ListMod.take(two, -steps)
            new_main = ListMod.append(main, move_train)
            new_two = ListMod.drop(two, -steps)
            {new_main,one,new_two}
        end
      steps == 0 ->
        {main,one,two}
    end
  end

  def move([], state) do [state] end
  def move([head | tail] , state) do
    [state | move(tail, single(head, state))]
  end
end
