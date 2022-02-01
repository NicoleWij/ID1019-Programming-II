defmodule Test do
  def test() do
    {code, data} = Program.load(demo())
    out = Out.start()
    reg = Register.new()

    Emulator.run({code, data}, reg, out)
  end

  def demo() do
    {
      {
        {:addi, 1, 1, 5},     # $1 <- 1 + 5 = 5
        {:add, 4, 2, 1},      # $4 <- $2 + $1
        {:addi, 5, 0, 1},     # $5 <- 0 + 1 = 1
        {:label, :loop},
        {:addi, 6, 0, 2},     # $6 <- 0 + 2 = 2
        {:addi, 5, 5, 1},     # $5 <- 1 + 1 = 2
        {:out, 5},
        {:out, 6},
        {:sw, 2, 0, 8},
        {:lw, 2, 0, 8},
        {:beq, 5, 6, :loop},
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
    Tree.tree_read(i, data)
  end

  def write_word(data, i, val) do
    0 = rem(i, 4)
    Tree.tree_insert(i, val, data)
  end
end



defmodule Out do
  def start() do [] end

  def put(out, s) do [s | out] end

  def close(out) do Enum.reverse(out) end
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

  def tree_read(index, {:leaf, i, v}) do v end

  def tree_read(index, {:node, i, v, left, right}) do
    cond do
      index == i -> v
      index > i -> tree_read(index, right)
      index < i -> tree_read(index, left)
    end
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
  def run(prgm, reg, out) do
    {code, data} = Program.load(prgm)
    run(0, code, reg, data, out)
  end
  def run(pc, code, reg, mem, out) do
    next = Program.read_instruction(code, pc)

    case next do
      {:halt} ->
        out = Out.close(out)
        {reg, out}

      {:out, rs} ->
        pc = pc + 4
        s = Register.read(reg, rs)
        out = Out.put(out, s)
        run(pc, code, reg, mem, out)

      {:add, rd, rs, rt} ->
        pc = pc + 4
        s = Register.read(reg, rs)
        t = Register.read(reg, rt)
        reg = Register.write(reg, rd, s + t)
        run(pc, code, reg, mem, out)

      {:sub, rd, rs, rt} ->
        pc = pc + 4
        s = Register.read(reg, rs)
        t = Register.read(reg, rt)
        reg = Register.write(reg, rd, s - t)
        run(pc, code, reg, mem, out)

      {:addi, rd, rt, imm} ->
        pc = pc + 4
        t = Register.read(reg, rt)
        reg = Register.write(reg, rd, t + imm)
        IO.write("code1: #{elem(reg,rd)}\n")
        run(pc, code, reg, mem, out)

      {:lw, rd, rt, offset} ->
        pc = pc + 4
        t = Program.read_word(mem, offset + rt)
        reg = Register.write(reg, rd, t)
        run(pc, code, reg, mem, out)

      {:sw, rs, rt, offset} ->
        pc = pc + 4
        s = Register.read(reg, rs)
        mem = Program.write_word(mem, rt + offset, s)
        run(pc, code, reg, mem, out)

      {:beq, rs, rt, offset} ->
        s = Register.read(reg, rs)
        t = Register.read(reg, rt)

        if s == t do
          pc = offset
          out = Out.put(out, "Branch to = #{pc + offset}\n")
          run(pc, code, reg, mem, out)
        else
          pc = pc + 4
          out = Out.put(out, "\n")
          run(pc, code, reg, mem, out)
        end

      {:label, label} ->
        out = Out.put(out, "#{label}\n")
        pc = pc + 4
        code = replace_labels(code, pc, pc, label)
        run(pc, code, reg, mem, out)

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

  def replace_labels(code, start_pc, pc, label) do
    # IO.write("replace pc = #{start_pc}\n")
    next = Program.read_instruction(code, start_pc)

    case next do
      {:halt} ->
        code

      {:beq, s, t, l} ->
        if l == label do
          code = put_elem(code, div(start_pc, 4), {:beq, s, t, pc + 4})
          replace_labels(code, start_pc + 4, pc, label)
        else
          replace_labels(code, start_pc + 4, pc, label)
        end

      _ ->
        replace_labels(code, start_pc + 4, pc, label)
    end
  end
end
