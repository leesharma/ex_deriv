defmodule ExDeriv do
  @moduledoc """
  Symbolic differentiation in Elixir.

  At the moment, this library only supports four arithmetic functions: +-*/.
  Any polynomial terms must be defined in terms of these functions.
  """

  require SymbolicExpressions
  import SymbolicExpressions, only: [
    # accessor functions
    left: 1, right: 1,
    # query macros for guard clauses
    is_addition: 1, is_subtraction: 1, is_multiplication: 1, is_division: 1,
    is_exponent: 1, is_error: 1,
  ]
  import SymbolicArithmetic

  @doc """
  Derives an expression in terms of the given variable.

  This operation currently supports four arithmetic functions: +, -, *, /
  """
  def derive_quoted(expression, variable \\ :x)

  # primitives
  def derive_quoted(x, x) when is_atom(x),                 do: 1
  def derive_quoted(y, _) when is_atom(y) or is_number(y), do: 0

  # sum rule: (u+v)' = u' + v'
  def derive_quoted(term, x) when is_addition(term) do
    u = left(term)
    v = right(term)
    add(derive_quoted(u,x), derive_quoted(v,x))
  end

  # difference rule: (u-v)' = u' - v'
  def derive_quoted(term, x) when is_subtraction(term) do
    u = left(term)
    v = right(term)
    subtract(derive_quoted(u,x), derive_quoted(v,x))
  end

  # product rule: (uv)' = u'v + uv'
  def derive_quoted(term, x) when is_multiplication(term) do
    u = left(term)
    v = right(term)

    left  = multiply(v, derive_quoted(u,x))
    right = multiply(u, derive_quoted(v,x))

    add(left, right)
  end

  # quotient rule: (u/v)' = (u'v - uv') / v^2
  def derive_quoted(term, x) when is_division(term) do
    u = left(term)
    v = right(term)

    left  = multiply(v, derive_quoted(u,x))
    right = multiply(u, derive_quoted(v,x))
    numer = subtract(left, right)
    denom = multiply(v, v)

    divide(numer, denom)
  end

  # power rule: (x^n)' = n*x^(n-1)
  def derive_quoted(term, x) when is_exponent(term) do
    base = left(term)
    exp = right(term)

    # chain rule: (f(g(x)))' = f'(g(x)) * g'(x)
    dfg = multiply(exp, pow(base, exp-1))
    dg = derive_quoted(base, x)
    multiply(dfg, dg)
  end

  # errors
  def derive_quoted(err, _) when is_error(err), do: err
end
