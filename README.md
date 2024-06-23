# Writing a JSON parser in elixir

I have been dabbling in elixir for a while now, and thought of starting a small but meaty project to get a hang of idiomatic elixir.

Pattern matching is goated

I actually wrote a typescript version of this before I started the elixir version, just to have a reference working implementation. The major difference is probably the pattern matching in elixir.

> (tbh calling it working is a stretch, probably only works in English UTF-8 lol)

## Elixir

> Pattern matching is goated ~me, 3 lines above

It's kinda funny how much conditional code pattern matching just removes. I probably got a bit better at recursion as well.

There's also tests!

- [parser tests](./test/parser_test.exs)
- [tokenizer tests](./test/tokenizer_test.exs)

## The process

The essence of any parser lies in two major steps - tokenization and parsing.

Tokenization is the conversion of a string into a list of tokens according to the grammar of the language (JSON). It generally doesn't throw any errors as long as the input is valid, regardless of whether the input is syntactically correct or not.

Parsing is taking the list of tokens, and constructing what is called an Abstract Syntax Tree (AST). This is where the syntax of the language are checked. If the input is syntactically incorrect, the parser throws an error.

Like,

if a JSON string `{"test": "long string"` is passed, the tokens will be `[brace_open, string, colon, string]`, but when you try to parse it, it will throw an error because the brace is not closed, hence it is not valid JSON.

## Toy-ness

> [!CAUTION]
> This was made solely to learn about the overall structure of a JSON parser and learn a bit of elixir. It does not follow any spec, nor does it make any guarantees about correctness, security, or stability.
> I am basically saying this is worthless and you should not use it (except to learn about how it works).
