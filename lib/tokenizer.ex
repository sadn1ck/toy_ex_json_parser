defmodule Tokenizer do
  alias Token

  def tokenize(input) do
    do_tokenize(String.graphemes(input), [], :normal, [])
  end

  # input, curr, :normal/:in_string/:in_number, completed
  defp do_tokenize([], _curr, :normal, tokens) do
    Enum.reverse(tokens)
  end

  # consume whitespace
  defp do_tokenize([char | rest], curr, :normal, tokens)
       when char in [" ", "\t", "\n", "\r", "\r\n"] do
    do_tokenize(rest, curr, :normal, tokens)
  end

  # encountering a number when not in string
  defp do_tokenize([char | rest], curr, :normal, tokens)
       when char in ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "-"] do
    do_tokenize(rest, curr ++ [char], :in_number, tokens)
  end

  # consume numbers and dots while in a number
  defp do_tokenize([char | rest], curr, :in_number, tokens)
       when char in ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "."] do
    do_tokenize(rest, curr ++ [char], :in_number, tokens)
  end

  # encountering a non-number while in a number
  defp do_tokenize([char | rest], curr, :in_number, tokens) do
    # do not consume current char as that is breaking point of number
    do_tokenize([char | rest], char, :normal, [Token.new(:number, Enum.join(curr, "")) | tokens])
  end

  # encountering a quote while not in a string
  defp do_tokenize(["\"" | rest], _curr, :normal, tokens) do
    do_tokenize(rest, [], :in_string, tokens)
  end

  # encountering a quote while in a string
  defp do_tokenize(["\"" | rest], curr, :in_string, tokens) do
    do_tokenize(rest, [], :normal, [Token.new(:string, Enum.join(curr, "")) | tokens])
  end

  # consume characters while in a string
  defp do_tokenize([char | rest], curr, :in_string, tokens) do
    do_tokenize(rest, curr ++ [char], :in_string, tokens)
  end

  # handling true/false

  defp do_tokenize(["t", "r", "u", "e" | rest], _curr, :normal, tokens) do
    do_tokenize(rest, [], :normal, [Token.new(:bool_true, "true") | tokens])
  end

  defp do_tokenize(["f", "a", "l", "s", "e" | rest], _curr, :normal, tokens) do
    do_tokenize(rest, [], :normal, [Token.new(:bool_false, "false") | tokens])
  end

  # handling null
  defp do_tokenize(["n", "u", "l", "l" | rest], _curr, :normal, tokens) do
    do_tokenize(rest, [], :normal, [Token.new(:null, "null") | tokens])
  end

  # brackets, braces, commas and colons
  defp do_tokenize(["[" | rest], _curr, :normal, tokens) do
    do_tokenize(rest, [], :normal, [Token.new(:bracket_open, "[") | tokens])
  end

  defp do_tokenize(["{" | rest], _curr, :normal, tokens) do
    do_tokenize(rest, [], :normal, [Token.new(:brace_open, "{") | tokens])
  end

  defp do_tokenize(["}" | rest], _curr, :normal, tokens) do
    do_tokenize(rest, [], :normal, [Token.new(:brace_close, "}") | tokens])
  end

  defp do_tokenize(["]" | rest], _curr, :normal, tokens) do
    do_tokenize(rest, [], :normal, [Token.new(:bracket_close, "]") | tokens])
  end

  defp do_tokenize(["," | rest], _curr, :normal, tokens) do
    do_tokenize(rest, [], :normal, [Token.new(:comma, ",") | tokens])
  end

  defp do_tokenize([":" | rest], _curr, :normal, tokens) do
    do_tokenize(rest, [], :normal, [Token.new(:colon, ":") | tokens])
  end
end
