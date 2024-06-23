defmodule TokenType do
  @token_types [
    :brace_open,
    :brace_close,
    :bracket_open,
    :bracket_close,
    :string,
    :number,
    :comma,
    :colon,
    :bool_true,
    :bool_false,
    :null
  ]

  def types() do
    @token_types
  end
end

defmodule Token do
  defstruct [:type, :value]

  def new(type, value \\ "") do
    if type in TokenType.types() do
      %Token{type: type, value: value}
    else
      raise ArgumentError, "Invalid token type: #{inspect(type)}"
    end
  end
end

defmodule ASTNode do
  defstruct [:type, :value]

  def new(type, value) do
    case {type, value} do
      {"Object", val} -> %ASTNode{type: "Object", value: val}
      {"Array", val} -> %ASTNode{type: "Array", value: val}
      {"String", val} -> %ASTNode{type: "String", value: val}
      {"Number", val} -> %ASTNode{type: "Number", value: val}
      {"Boolean", val} -> %ASTNode{type: "Boolean", value: val}
      {"Null", ""} -> %ASTNode{type: "Null"}
      {_, _} -> raise ArgumentError, "Invalid ASTNode type: #{inspect(type)}"
    end
  end
end
