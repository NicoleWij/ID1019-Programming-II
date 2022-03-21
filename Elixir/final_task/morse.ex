defmodule Morse do
  def test() do
    sample = sample()
    morse = morse()

    encodeTable = encode_table(morse, [])
    encodedMessage = encode(sample, encodeTable, [])
    encodedMessage = List.to_string(encodedMessage)
    encodedMessage = String.split(encodedMessage)
    
    decodedMessage = decode(encodedMessage, morse, [])

    #message = String.split(message())
    #decode(message, morse)
  end

  def sample() do
    'nicole wijkman'
  end

  def message() do
      ".- .-.. .-.. ..-- -.-- --- ..- .-. ..-- -... .- ... . ..-- .- .-. . ..-- -... . .-.. --- -. --. ..-- - --- ..-- ..- ... .... - - .--. ... ---... .----- .----- .-- .-- .-- .-.-.- -.-- --- ..- - ..- -... . .-.-.- -.-. --- -- .----- .-- .- - -.-. .... ..--.. ...- .----. -.. .--.-- ..... .---- .-- ....- .-- ----. .--.-- ..... --... --. .--.-- ..... ---.. -.-. .--.-- ..... .----"
  end

  def morse() do
    {:node, :na,
     {:node, 116,
      {:node, 109,
       {:node, 111, {:node, :na, {:node, 48, nil, nil}, {:node, 57, nil, nil}},
        {:node, :na, nil, {:node, 56, nil, {:node, 58, nil, nil}}}},
       {:node, 103, {:node, 113, nil, nil},
        {:node, 122, {:node, :na, {:node, 44, nil, nil}, nil}, {:node, 55, nil, nil}}}},
      {:node, 110, {:node, 107, {:node, 121, nil, nil}, {:node, 99, nil, nil}},
       {:node, 100, {:node, 120, nil, nil},
        {:node, 98, nil, {:node, 54, {:node, 45, nil, nil}, nil}}}}},
     {:node, 101,
      {:node, 97,
       {:node, 119, {:node, 106, {:node, 49, {:node, 47, nil, nil}, {:node, 61, nil, nil}}, nil},
        {:node, 112, {:node, :na, {:node, 37, nil, nil}, {:node, 64, nil, nil}}, nil}},
       {:node, 114, {:node, :na, nil, {:node, :na, {:node, 46, nil, nil}, nil}},
        {:node, 108, nil, nil}}},
      {:node, 105,
       {:node, 117, {:node, 32, {:node, 50, nil, nil}, {:node, :na, nil, {:node, 63, nil, nil}}},
        {:node, 102, nil, nil}},
       {:node, 115, {:node, 118, {:node, 51, nil, nil}, nil},
        {:node, 104, {:node, 52, nil, nil}, {:node, 53, nil, nil}}}}}}
  end

  def encode([], _, code) do
    code
  end

  def encode([char | rest], map, code) do
    encode(rest, map, code ++ ' ' ++ Map.get(map, char))
  end

  def encode_table(nil, _) do
    %{}
  end

  def encode_table({:node, key, left, right}, list) do
    case key do
      :na ->
        Map.merge(encode_table(left, list ++ '-'), encode_table(right, list ++ '.'))

      _ ->
        Map.put(
          Map.merge(encode_table(left, list ++ '-'), encode_table(right, list ++ '.')),
          key,
          list
        )
    end
  end

  def decode([], _, list) do list end

  def decode([head | tail], tree, list) do
    decode(tail, tree, list ++ [decode_char(String.to_charlist(head), tree)])
  end

  def decode_char([], {_, char, _, _}) do char end

  def decode_char([head | tail], {:node, char, left, right}) do
      case [head] do
            '-' ->
                decode_char(tail, left)
            '.' ->
                decode_char(tail, right)
      end
  end
end
