defmodule Emulator do

  def run(prgm) do
    {code, data} = Program.load(prgm)
    reg = Registers.new()
    run(0, code, reg, data)
  end

  def run(pc, code, reg, mem) do
    next = Program.read_instruction(code, pc)
    case next do
      :halt ->
        :ok
      {:add, rd, rs, rt} ->
        pc = pc + 4
        s = Register.read(reg, rs)
        t = Register.read(reg, rt)
        reg = Register.write(reg, rd, s + t) # well, almost
        run(pc, code, reg, mem)
        
      {:sub, rd, rs, rt} ->
        pc = pc + 4
        s = Register.read(reg, rs)
        t = Register.read(reg, rt)
        reg = Register.write(reg, rd, s - t) # well, almost
        run(pc, code, reg, mem)

      {:addi, rd, rt,imm} ->
        pc = pc + 4
        t = Register.read(reg, rt)
        reg = Register.write(reg, rd, imm + t) # well, almost
        run(pc, code, reg, mem)

      {:lw, rd, rt,offset} ->
        pc = pc + 4
        t = Register.read(reg, offset+rt)
        reg = Register.write(reg, rd, t) # well, almost
        run(pc, code, reg, mem)

      {:sw,rs ,rt,offset} ->
        pc = pc + 4
        s = Register.read(reg, rs)
        reg = Register.write(reg, rt+offset, s) # well, almost
        run(pc, code, reg, mem)

      {:beq,rs ,rt,offset} ->
        s = Register.read(reg, rs)
        t = Register.read(reg, rt)
        if(s==t){
          pc = pc + offset
        }
        else{
          pc = pc + 4
        }
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