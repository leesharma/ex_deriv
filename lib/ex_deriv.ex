defmodule ExDeriv do
  @moduledoc """
  Symbolic differentiation in Elixir.

  At the moment, this library only supports four arithmetic functions: +-*/.
  Any polynomial terms must be defined in terms of these functions.
  """

  import SymbolicArithmetic

  @doc """
  Derives an expression in terms of the given variable.

  This operation currently supports four arithmetic functions: +, -, *, /
  """
  def derive(expression, variable \\ :x)

  # primitives
  def derive(x, x) when is_atom(x),                 do: 1
  def derive(y, _) when is_atom(y) or is_number(y), do: 0

  # sum rule: (u+v)' = u' + v'
  def derive({:+, u, v}, x), do: add(derive(u,x), derive(v,x))

  # difference rule: (u-v)' = u' - v'
  def derive({:-, u, v}, x), do: subtract(derive(u,x), derive(v,x))

  # product rule: (uv)' = u'v + uv'
  def derive({:*, u, v}, x) do
    left  = multiply(v, derive(u,x))
    right = multiply(u, derive(v,x))

    add(left, right)
  end

  # quotient rule: (u/v)' = (u'v - uv') / v^2
  def derive({:/, u, v}, x) do
    left  = multiply(v, derive(u,x))
    right = multiply(u, derive(v,x))
    numer = subtract(left, right)
    denom = multiply(v, v)

    divide(numer, denom)
  end

  # errors
  def derive({:error,_} = err, _), do: err
end
