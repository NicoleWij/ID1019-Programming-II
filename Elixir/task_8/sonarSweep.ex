defmodule SonarSweep do
    def data() do
        file = File.read!("data.txt")
        String.split(file, "\r\n")
        |> Enum.map(&String.to_integer/1)
    end

    def example() do
    [199,200,208,210,200,207,240,269,260,263]
    end

    def runOne() do 
        [head | tail] = data()
        counter([head | tail], head, 0)
    end

    def runTwo() do
        everyList = Enum.chunk_every(data(), 3, 1, :discard)
        IO.inspect(everyList)
        everyList = add(everyList)
        IO.inspect(everyList)
        [head | tail] = everyList
        counter(everyList, head, 0)
    end

    def counter([], prev, count) do
        count
    end

    def counter([head | tail], prev, count) do
        cond do
            head > prev ->
                count = count + 1
                prev = head
                counter(tail, prev, count)
            true ->
                prev = head
                counter(tail, prev, count)
        end
    end

    def add([head | tail]) do
        head = Enum.sum(head)
        
        case tail do
            [] ->
                [head]
            _ ->
                [head | add(tail)]
        end
    end
end