defmodule Test do
  # Compute the double of a number.
  def double(n) do
    n * 2;
  end

  # Converts from Fahrenheit to Celcius.
  def celcius(n) do
    (n - 32)/1.8
  end

  # Defines a multiplication of m and n using only addition
  def product_case(m, n) do
    case m do
    0 ->
      m
    _ ->
      n + product_case(m-1, n)
    end
  end

  # Computes the exponentiation x^n with the help of the function product_case
  def exp(x, n) do
    case n do
      0 ->
        1
      _ ->
        product_case(x, exp(x, n-1))
    end
  end

  # Returns the n'th element of the list "list"
  def nth(n, list) do
    [head | tail] = list
    case n do
      0 ->
        head
      _ ->
        nth(n - 1, tail)
    end
  end

  # Return the number of elements in the list "list"
  def len(list) do
    [_head | tail] = list
    case tail do
      [] ->
        1
      _ ->
        len(tail) + 1
    end
  end

  # Add the element x to the list "list" if it is not in the list
  def add(x, list) do
    [head | tail] = list
    cond do
      tail == [] ->
        [head, x]
      x == head ->
        list
      x != head ->
        [head | add(x, tail)]
    end
  end

  # Sorts a list of elements through insertion sort
  def isort(list) do
    isort(list, []])
  end

  def isort(list, sorted) do
    [head | tail] = list
    case  do
    [] ->
    ...
    [head | tail] ->
    ...
    end
  end
end
