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
