defmodule ParserTest do
  use ExUnit.Case

  alias TokenType
  alias Parser
  alias ASTNode

  test "should parse a valid json string" do
    input = ~s({"sample": "json"})

    {ast, _} =
      input
      |> Tokenizer.tokenize()
      |> Parser.parse()

    expected = %ASTNode{
      type: "Object",
      value: %{
        "sample" => %ASTNode{type: "String", value: "json"}
      }
    }

    assert ast == expected
  end

  test "should parse a valid json with number and boolean" do
    input = ~s({"sample": 123, "bool": true})
    {ast, _} = Parser.parse(Tokenizer.tokenize(input))

    expected = %ASTNode{
      type: "Object",
      value: %{
        "sample" => %ASTNode{type: "Number", value: 123},
        "bool" => %ASTNode{type: "Boolean", value: true}
      }
    }

    assert ast == expected
  end

  test "should parse json with null" do
    input = ~s({"sample": null})
    {ast, _} = Parser.parse(Tokenizer.tokenize(input))

    expected = %ASTNode{
      type: "Object",
      value: %{
        "sample" => %ASTNode{type: "Null"}
      }
    }

    assert ast == expected
  end

  test "should parse json with array" do
    input = ~s({"sample": [1, 2, 3], "bools": [true, false]})
    {ast, _} = Parser.parse(Tokenizer.tokenize(input))

    expected = %ASTNode{
      type: "Object",
      value: %{
        "sample" => %ASTNode{
          type: "Array",
          value: [
            %ASTNode{type: "Number", value: 1},
            %ASTNode{type: "Number", value: 2},
            %ASTNode{type: "Number", value: 3}
          ]
        },
        "bools" => %ASTNode{
          type: "Array",
          value: [
            %ASTNode{type: "Boolean", value: true},
            %ASTNode{type: "Boolean", value: false}
          ]
        }
      }
    }

    assert ast == expected
  end

  test "should fail to parse incomplete json" do
    input = ~s({"sample": "json")

    assert_raise RuntimeError, fn ->
      Parser.parse(Tokenizer.tokenize(input))
    end
  end

  test "should throw RuntimeError on duplicate keys" do
    input = ~s({"sample": "json", "sample": "json"})

    assert_raise RuntimeError, fn ->
      Parser.parse(Tokenizer.tokenize(input))
    end
  end

  test "should throw RuntimeError on nest level duplicate keys" do
    input = ~s({"depth0": {"sample": "json", "sample": "json"}})

    assert_raise RuntimeError, fn ->
      Parser.parse(Tokenizer.tokenize(input))
    end
  end
end
