defmodule Derivate do

  def multiplication() do
    e = {:add,
          {:mul, {:num, 5},{:var, :x}},
          {:num,4}}
    d = deriv(e, :x)
    c = calc(d, :x, 5)
    IO.write("Expression: #{print(e)}\n")
    IO.write("Derivative: #{print(d)}\n")
    IO.write("Simplified: #{print(simplify(d))}\n")
    IO.write("Calculated: #{print(simplify(c))}\n")
  end

  def exponent() do
    e = {:add,
          {:exp, {:var, :x}, {:num, 3}},
          {:num, 5}}
    d = deriv(e, :x)
    c = calc(d, :x, 4)
    IO.write("Expression: #{print(e)}\n")
    IO.write("Derivative: #{print(d)}\n")
    IO.write("Simplified: #{print(simplify(d))}\n")
    IO.write("Calculated: #{print(simplify(c))}\n")
  end

  def sqrt() do
    e = {:sqrt, {:var, :x}}
    d = deriv(e, :x)
    c = calc(d, :x, 4)
    IO.write("Expression: #{print(e)}\n")
    IO.write("Derivative: #{print(d)}\n")
    IO.write("Simplified: #{print(simplify(d))}\n")
    IO.write("Calculated: #{print(simplify(c))}\n")
  end

  def lnx() do
    e = {:sqrt, {:var, :x}}
    d = deriv(e, :x)
    c = calc(d, :x, 4)
    IO.write("Expression: #{print(e)}\n")
    IO.write("Derivative: #{print(d)}\n")
    IO.write("Simplified: #{print(simplify(d))}\n")
    IO.write("Calculated: #{print(simplify(c))}\n")
  end


  def deriv({:num, _}, _) do {:num, 0} end
  def deriv({:var, v}, v) do {:num, 1} end
  def deriv({:var, _}, _) do {:num, 0} end
  def deriv({:add, e1, e2}, v) do
    {:add, deriv(e1,v), deriv(e2,v)}
  end
  def deriv({:mul,e1,e2}, v) do
    {:add,
      {:mul, deriv(e1,v),e2},
      {:mul, e1, deriv(e2,v)}}
  end
  def deriv({:exp, e, {:num, n}}, v) do
    {:mul,
      {:mul, {:num, n}, {:exp, e, {:num, n-1}}},
      deriv(e,v)}
  end
  def deriv({:sqrt, e}, v) do
    deriv({:exp, e, {:num, 1/2}}, v)
  end

  def calc( {:num, n}, _, _) do {:num, n} end
  def calc( {:var, v}, v, n) do {:num, n} end
  def calc( {:var, v}, _, _) do {:var, v} end
  def calc( {:add, e1, e2}, v, n) do
    {:add, calc(e1, v, n), calc(e2, v, n)}
  end
  def calc( {:mul, e1, e2}, v, n) do
    {:mul, calc(e1, v, n), calc(e2, v, n)}
  end
  def calc( {:exp, e1, e2}, v, n) do
    {:exp, calc(e1, v, n), calc(e2, v, n)}
  end

  def simplify({:add, e1, e2}) do
    simplify_add(simplify(e1), simplify(e2))
  end

  def simplify({:mul, e1, e2}) do
    simplify_mul(simplify(e1), simplify(e2))
  end

  def simplify({:exp, e1, e2}) do
    simplify_exp(simplify(e1), simplify(e2))
  end

  def simplify(e) do e end

  def simplify_add({:num, 0}, e2) do e2 end
  def simplify_add(e1, {:num, 0}) do e1 end
  def simplify_add({:num, n1}, {:num, n2}) do {:num,n1+n2} end
  def simplify_add(e1,e2) do {:add,e1,e2} end

  def simplify_mul({:num, 0}, e2) do {:num,0} end
  def simplify_mul(e1, {:num, 0}) do {:num,0} end
  def simplify_mul({:num, 1}, e2) do e2 end
  def simplify_mul(e1, {:num, 1}) do e1 end
  def simplify_mul({:num, n1}, {:num, n2}) do {:num,n1*n2} end
  def simplify_mul(e1, e2) do {:mul, e1, e2} end

  def simplify_exp(_, {:num, 0}) do 1 end
  def simplify_exp(e1, {:num, 1}) do e1 end
  def simplify_exp({:num, n1}, {:num, n2}) do {:num, :math.pow(n1,n2)} end
  def simplify_exp(e1, e2) do {:exp, e1, e2} end

  def print({:num, n}) do "#{n}" end
  def print({:var, v}) do "#{v}" end
  def print({:add, e1, e2}) do "(#{print(e1)} + #{print(e2)})" end
  def print({:mul, e1, e2}) do "#{print(e1)} * #{print(e2)}" end
  def print({:exp, e1, e2}) do "#{print(e1)}^#{print(e2)}" end
  def print({:sqrt, e}) do "Sqrt(#{print(e)})" end
end
