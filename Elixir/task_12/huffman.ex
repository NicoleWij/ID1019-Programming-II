defmodule Huffman do
  def sample do
    'the quick brown fox jumps over the lazy dog this is a sample text that we will use when we build up a table we will only handle lower case letters and no punctuation symbols the frequency will of course not represent english but it is probably not that far off'
  end

  def text() do
    'abcdefghijklmnopqrstuvwxyz'
  end

  def abc() do
    'abca'
  end

  def test do
    sample = abc()
    tree = tree(sample)
    IO.write("tree")
    IO.inspect(tree)
    encode = encode_table(tree)
    IO.inspect(encode)
    decode = decode_table(tree)
    text = abc()
    seq = encode(text, encode)
    decode(seq, decode)
  end



  def tree(sample) do
    freq = Map.to_list(freq(sample))
    freq = freq |> Enum.sort_by(&elem(&1, 1))
    huffman(freq)
  end



  def encode_table({tree, freq}) do
    encode_table(tree, %{}, [])
  end

  def encode_table({left, right}, table, path) do
    table = encode_table(left, table, path ++ [0])
    encode_table(right, table, path ++ [1])
  end

  def encode_table(k, table, path) do
    Map.put(table, k, path)
  end



  def encode([], table) do
    []
  end

  def encode(text=[head | tail], table) do
    Map.fetch!(table,[head]) ++ encode(tail, table)
  end



  def decode_table({tree, freq}) do
    decode_table(tree, %{}, [])
  end

  def decode_table({left, right}, table, path) do
    table = decode_table(left, table, path ++ [0])
    decode_table(right, table, path ++ [1])
  end

  def decode_table(k, table, path) do
    Map.put(table, path, k)
  end



  def decode([], _) do
    []
  end

  def decode(seq, table) do
    {char, rest} = decode_char(seq, 1, table)
    [char | decode(rest, table)]
  end

  def decode_char(seq, n, table) do
    {code, rest} = Enum.split(seq, n)

    case Map.get(table, code) do
      nil ->
        decode_char(seq, n+1, table)
      _ ->
        {Map.get(table,code), rest}
    end
  end



  def freq(sample) do
    freq(sample, %{})
  end

  def freq([], freq) do
    freq
  end

  def freq([char | rest], freq) do
    case Map.get(freq, [char]) do
      nil ->
        freq(rest, Map.put(freq, [char], 1))

      value ->
        freq(rest, Map.put(freq, [char], value + 1))
    end
  end



  def huffman(list = [{k1, v1}, {k2, v2}]) do
    # IO.inspect(list)
    {{k1, k2}, v1 + v2}
  end

  def huffman(list = [{k1, v1}, {k2, v2} | rest]) do
    # IO.inspect(list)
    huffman(join({{k1, k2}, v1 + v2}, rest))
  end



  def join({k1, v1}, [{k2, v2}]) do
    cond do
      v1 <= v2 ->
        [{k1, v1}, {k2, v2}]

      true ->
        [{k2, v2}, {k1, v1}]
    end
  end

  def join({k1, v1}, [{k2, v2} | rest]) do
    cond do
      v1 <= v2 ->
        [{k1, v1}, {k2, v2}] ++ rest

      true ->
        [{k2, v2}] ++ join({k1, v1}, rest)
    end
  end

  def read(file) do
    {:ok, file} = File.open(file, [:read, :utf8])
    binary = IO.read(file, :all)
    File.close(file)
    length = byte_size(binary)
    case :unicode.characters_to_list(binary, :utf8) do
    {:incomplete, list, rest} ->
      {list, length - byte_size(rest)}
    list ->
      {list, length}
    end
  end

  def bench() do
    sample = sample()
    {text, length} = read("data.txt")
    {tree, tree_time} = time(fn -> tree(text) end)
    {encode_table, encode_table_time} = time(fn -> encode_table(tree) end)
    {decode_table, decode_table_time} = time(fn -> decode_table(tree) end)
    {encode, encode_time} = time(fn -> encode(text, encode_table) end)
    {_, decoded_time} = time(fn -> decode(encode, decode_table) end)

    e = div(length(encode), 8)
    r = Float.round(e / length, 3)

    IO.puts("Tree Build Time: #{tree_time} us")
    IO.puts("Encode Table Time: #{encode_table_time} us")
    IO.puts("Decode Table Time: #{decode_table_time} us")
    IO.puts("Encode Time: #{encode_time} us")
    IO.puts("Decode Time: #{decoded_time} us")
    IO.puts("Compression Ratio: #{r}")
  end

  def time(func) do
    {func.(), elem(:timer.tc(fn () -> func.() end), 0)}
  end
end
