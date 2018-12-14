# ExDeriv

**A basic symbolic differentiation library**

## Usage

The library takes a polynomial expression in AST form. Currently, only four
operations are supported: +, -, /, *.

```elixir
> import ExDeriv
> derive({:\*, :x, 5}, :x)  # d(5x)/dx = 5
5
> derive({:+, {:-, {:\*, {:/, :x, :y}, 5}, :a}, :b}, :y) # d(5x/y - a + b)/dy
{:\*, 5, {:/, {:\*, -1, :x}, {:\*, :y, :y}}}             #     = -5x/y^2
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ex_deriv` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_deriv, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/ex_deriv](https://hexdocs.pm/ex_deriv).

