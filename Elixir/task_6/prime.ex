defmodule Prime do

  def bench() do
    ls = [16,32,64,128,256,512,1024,2*1024,4*1024,8*1024, 16*1024]

    time = fn (i, f) ->
      elem(:timer.tc(fn () -> f.(i) end),0)
    end

    bench = fn (i) ->
      solutionOne = fn(numbs) ->
       list1(numbs)
      end

      solutionTwo = fn(numbs) ->
        list2(numbs)
      end

      solutionThree = fn(numbs) ->
        list3(numbs)
      end

      timeOne = time.(i, solutionOne)
      timeTwo = time.(i, solutionTwo)
      timeThree = time.(i, solutionThree)

      IO.write("  #{timeOne}\t\t\t#{timeTwo}\t\t\t#{timeThree}\n")
    end

    IO.write("# benchmark of lists and tree \n")
    Enum.map(ls, bench)
    :ok
  end

  def list1(num) do
    list = Enum.to_list(2..num)
    solution_one(list)
  end

  def list2(num) do
    list = Enum.to_list(2..num)
    found = []
    solution_two(list, found)
  end

  def list3(num) do
    list = Enum.to_list(2..num)
    found = []
    Enum.reverse(solution_three(list, found))
  end

  def solution_one(list) do
    [head | tail] = list
    case tail do
      [] ->
        list
      _ ->
        tail = Enum.filter(tail, fn(x) ->
          rem(x, head) != 0
        end)

        [head | solution_one(tail)]
    end
  end

  def solution_two([], found) do found end

  def solution_two([head | tail], found) do
    if Enum.any?(found, fn(x) -> rem(head, x) == 0 end) do
      solution_two(tail, found)
    else
      solution_two(tail, found ++ [head])
    end
  end

  def solution_three([], found) do found end

  def solution_three([head | tail], found) do
    if Enum.any?(found, fn(x) -> rem(head, x) == 0 end) do
      solution_three(tail, found)
    else
      solution_three(tail, [head | found])
    end
  end
end
