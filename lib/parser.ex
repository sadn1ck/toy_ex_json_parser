defmodule Parser do
  alias ASTNode

  defp consume([]) do
    raise RuntimeError, "Unexpected end of input"
  end

  defp consume([token | rest]), do: {token, rest}

  def parse([%Token{type: :string, value: value} | rest]) do
    {%ASTNode{type: "String", value: value}, rest}
  end

  def parse([%Token{type: :number, value: value} | rest]) do
    {%ASTNode{type: "Number", value: value |> String.to_integer()}, rest}
  end

  def parse([%Token{type: :bool_true} | rest]) do
    {%ASTNode{type: "Boolean", value: true}, rest}
  end

  def parse([%Token{type: :bool_false} | rest]) do
    {%ASTNode{type: "Boolean", value: false}, rest}
  end

  def parse([%Token{type: :null} | rest]) do
    {%ASTNode{type: "Null"}, rest}
  end

  def parse([%Token{type: :brace_close} | rest]) do
    parse(rest)
  end

  def parse([%Token{type: :brace_open} | rest]) do
    # acc is record of key and ASTNode
    parse_object(rest, %ASTNode{type: "Object", value: %{}})
  end

  def parse([%Token{type: :bracket_close} | rest]) do
    parse(rest)
  end

  def parse([%Token{type: :bracket_open} | rest]) do
    # acc is array of ASTNode
    parse_array(rest, %ASTNode{type: "Array", value: []})
  end

  defp parse_object([%Token{type: :brace_close} | rest], acc) do
    {acc, rest}
  end

  defp parse_object(tokens, acc) do
    # TODO: better error handling? should add else
    with {%Token{type: :string, value: strval}, after_string} <- consume(tokens),
         {%Token{type: :colon}, after_colon} <- consume(after_string),
         {value, rest} <- parse(after_colon) do
      case consume(rest) do
        {%Token{type: :comma}, after_comma} ->
          parse_object(after_comma, %{acc | value: Map.put(acc.value, strval, value)})

        {_, _} ->
          parse_object(rest, %{acc | value: Map.put(acc.value, strval, value)})
      end
    end
  end

  defp parse_array([%Token{type: :bracket_close} | rest], acc) do
    {acc, rest}
  end

  defp parse_array(tokens, acc) do
    case consume(tokens) do
      {%Token{type: :comma}, after_comma} ->
        parse_array(after_comma, acc)

      {token, rest} ->
        {value, rest} = parse([token | rest])
        parse_array(rest, %{acc | value: acc.value ++ [value]})
    end
  end
end
