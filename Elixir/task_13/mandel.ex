defmodule Mandel do
  def mandelbrot(width, height, x, y, k, max) do
    trans = fn w, h ->
      Cmplx.new(x + k * (w - 1), y - k * (h - 1))
    end

    all_rows(width, height, trans, max, [])
  end

  def all_rows(width, 0, trans, max, list) do
    list
  end

  def all_rows(width, height, trans, max, list) do
    all_rows(width, height - 1, trans, max, [rows(width, height, trans, max, []) | list])
  end

  def rows(0, _, _, _, list) do
    list
  end

  def rows(width, height, trans, max, list) do
    depth = Brot.mandelbrot(trans.(width, height), max)
    color = Colors.convert(depth, max)
    
    rows(width - 1, height, trans, max, [color | list])
  end
end
