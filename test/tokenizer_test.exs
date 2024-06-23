defmodule TokenizerTest do
  use ExUnit.Case

  alias Tokenizer
  alias Token

  test "should tokenize a valid json string" do
    input = ~s({"sample": "json"})
    tokens = Tokenizer.tokenize(input)

    assert tokens == [
             %Token{type: :brace_open, value: "{"},
             %Token{type: :string, value: "sample"},
             %Token{type: :colon, value: ":"},
             %Token{type: :string, value: "json"},
             %Token{type: :brace_close, value: "}"}
           ]
  end

  test "should tokenize a valid json with number and boolean" do
    input = ~s({"sample": 123, "bool": true})
    tokens = Tokenizer.tokenize(input)

    assert tokens == [
             %Token{type: :brace_open, value: "{"},
             %Token{type: :string, value: "sample"},
             %Token{type: :colon, value: ":"},
             %Token{type: :number, value: "123"},
             %Token{type: :comma, value: ","},
             %Token{type: :string, value: "bool"},
             %Token{type: :colon, value: ":"},
             %Token{type: :bool_true, value: "true"},
             %Token{type: :brace_close, value: "}"}
           ]
  end

  test "should tokenize json with null" do
    input = ~s({"sample": null})
    tokens = Tokenizer.tokenize(input)

    assert tokens == [
             %Token{type: :brace_open, value: "{"},
             %Token{type: :string, value: "sample"},
             %Token{type: :colon, value: ":"},
             %Token{type: :null, value: "null"},
             %Token{type: :brace_close, value: "}"}
           ]
  end

  test "should not fail to tokenize incomplete json" do
    input = ~s({"sample": "json")
    tokens = Tokenizer.tokenize(input)

    assert tokens == [
             %Token{type: :brace_open, value: "{"},
             %Token{type: :string, value: "sample"},
             %Token{type: :colon, value: ":"},
             %Token{type: :string, value: "json"}
           ]
  end

  test "should tokenize json with array" do
    input = ~s({"sample": [1, 2, 3], "bools": [true, false]})
    tokens = Tokenizer.tokenize(input)

    assert tokens == [
             %Token{type: :brace_open, value: "{"},
             %Token{type: :string, value: "sample"},
             %Token{type: :colon, value: ":"},
             %Token{type: :bracket_open, value: "["},
             %Token{type: :number, value: "1"},
             %Token{type: :comma, value: ","},
             %Token{type: :number, value: "2"},
             %Token{type: :comma, value: ","},
             %Token{type: :number, value: "3"},
             %Token{type: :bracket_close, value: "]"},
             %Token{type: :comma, value: ","},
             %Token{type: :string, value: "bools"},
             %Token{type: :colon, value: ":"},
             %Token{type: :bracket_open, value: "["},
             %Token{type: :bool_true, value: "true"},
             %Token{type: :comma, value: ","},
             %Token{type: :bool_false, value: "false"},
             %Token{type: :bracket_close, value: "]"},
             %Token{type: :brace_close, value: "}"}
           ]
  end

  test "should parse this multiline json string" do
    input = """
    {
      "id": "647ceaf3657eade56f8224eb",
      "index": 0,
      "person": {
        "name": "Oz",
        "address": "Somewhere magical"
      },
      "boolean": true,
      "nullValue": null
    }
    """

    tokens = Tokenizer.tokenize(input)

    assert tokens == [
             %Token{type: :brace_open, value: "{"},
             %Token{type: :string, value: "id"},
             %Token{type: :colon, value: ":"},
             %Token{type: :string, value: "647ceaf3657eade56f8224eb"},
             %Token{type: :comma, value: ","},
             %Token{type: :string, value: "index"},
             %Token{type: :colon, value: ":"},
             %Token{type: :number, value: "0"},
             %Token{type: :comma, value: ","},
             %Token{type: :string, value: "person"},
             %Token{type: :colon, value: ":"},
             %Token{type: :brace_open, value: "{"},
             %Token{type: :string, value: "name"},
             %Token{type: :colon, value: ":"},
             %Token{type: :string, value: "Oz"},
             %Token{type: :comma, value: ","},
             %Token{type: :string, value: "address"},
             %Token{type: :colon, value: ":"},
             %Token{type: :string, value: "Somewhere magical"},
             %Token{type: :brace_close, value: "}"},
             %Token{type: :comma, value: ","},
             %Token{type: :string, value: "boolean"},
             %Token{type: :colon, value: ":"},
             %Token{type: :bool_true, value: "true"},
             %Token{type: :comma, value: ","},
             %Token{type: :string, value: "nullValue"},
             %Token{type: :colon, value: ":"},
             %Token{type: :null, value: "null"},
             %Token{type: :brace_close, value: "}"}
           ]
  end
end
