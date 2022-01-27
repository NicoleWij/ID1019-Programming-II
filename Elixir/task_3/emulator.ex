defmodule Test do
  def test() do
    {code, data} = Program.load(demo())

    # out = Out.start()

    reg = Register.new()

    Emulator.run({code, data}, reg)
  end

   def demo() do
    {
      {
        {:addi, 1, 0, 10},
        {:addi, 2, 1, 3},
        {:sw, 2, 0, 4},
        {:addi, 5, 2, 1},
        {:halt}
      },
      Tree.tree_new()
    }
  end
end

defmodule Program do

  def load(prgm) do
    {code, data} = prgm
  end

  def read_instruction(code, pc) do
    0 = rem(pc, 4)
    elem(code, div(pc, 4))
  end

  def read_word(data, i) do
    0 = rem(i, 4)
    Map.get(data, i)
  end

  def write_word(data, i, val) do
    0 = rem(i, 4)
    Tree.tree_insert(i, val, data)
  end
end

defmodule Register do
  def new() do
    reg =
      {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
       0, 0}
  end

  def read(_, 0) do
    0
  end

  def read(reg, i) do
    IO.write("read from index: #{i}\n")
    elem(reg, i)
  end

  def write(reg, 0, _) do
    reg
  end

  def write(reg, i, val) do
    put_elem(reg, i, val)
  end
end

defmodule Tree do
  def tree_new() do  
    {:node, nil, nil}
  end
  
  def tree_insert(index, insert_val, nil) do
    {:leaf, index, insert_val}
  end

  def tree_insert(index, insert_val, {:leaf, i, val}) do
    cond do
      i == index -> {:leaf, index, insert_val}
      i > index -> {:node, i, val, nil, {:leaf, insert_val}}
      i < index -> {:node, i, val, {:leaf, insert_val}, nil}
    end
  end

  def tree_insert(index, insert_val, {:node, nil, nil}) do
    {:node, index, insert_val, nil, nil}
  end

  def tree_insert(index, insert_val, {:node, i, val, left, right}) do
    cond do
      index == i -> {:node, i, insert_val, left, right}
      index > i -> {:node, i, val, left, tree_insert(index, insert_val, right)}
      index < i -> {:node, i, val, tree_insert(index, insert_val, left), right}
    end
  end
end

defmodule Emulator do
  def run(prgm, reg) do
    {code, data} = Program.load(prgm)
    run(0, code, reg, data)
  end
  def run(pc, code, reg, mem) do
    next = Program.read_instruction(code, pc)

    case next do
      {:halt} ->
        :ok

      {:add, rd, rs, rt} ->
        pc = pc + 4
        s = Register.read(reg, rs)
        t = Register.read(reg, rt)
        reg = Register.write(reg, rd, s + t)
        run(pc, code, reg, mem)

      {:sub, rd, rs, rt} ->
        pc = pc + 4
        s = Register.read(reg, rs)
        t = Register.read(reg, rt)
        reg = Register.write(reg, rd, s - t)
        run(pc, code, reg, mem)

      {:addi, rd, rt, imm} ->
        pc = pc + 4
        t = Register.read(reg, rt)
        reg = Register.write(reg, rd, t + imm)
        IO.write("code1: #{elem(reg,rd)}\n")
        run(pc, code, reg, mem)

      {:lw, rd, rt, offset} ->
        pc = pc + 4
        t = Program.read_word(mem, offset + rt)
        reg = Register.write(reg, rd, t)
        run(pc, code, reg, mem)

      {:sw, rs, rt, offset} ->
        pc = pc + 4
        IO.write("#{rs}\n")
        s = Register.read(reg, rs)
        mem = Program.write_word(mem, rt + offset, s)
        run(pc, code, reg, mem)

      {:beq, rs, rt, offset} ->
        s = Register.read(reg, rs)
        t = Register.read(reg, rt)

        if s == t do
          pc = offset + 4
        else
          pc = pc + 4
        end

        run(pc, code, reg, mem)
    end
  end

  def run(pc, code, reg, mem, out) do
    next = Program.read_instruction(code, pc)

    case next do
      :halt ->
        Out.close(out)

      {:out, rs} ->
        pc = pc + 4
        s = Register.read(reg, rs)
        out = Out.put(out, s)
        run(pc, code, reg, mem, out)
    end
  end
end