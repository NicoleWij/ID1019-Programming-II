defmodule Brot do
  def mandelbrot(c = {r, i}, m) do
    z0 = Cmplx.new(r, i)
    i = 0
    test(i, z0, c, m)
  end

  def test(i, zn, c, m) do
      cond do
        i == m ->
            0
        Cmplx.abs(zn) > 2 ->
            i
        true ->
            test(i+1, Cmplx.add(Cmplx.sqr(zn), c), c, m)
      end
  end
end
