defmodule SymbolicArithmetic do
  @moduledoc """
  Symbolic arithmetic library for Elixir.
  """

  require SymbolicExpressions
  import SymbolicExpressions, only: [
    # construct new terms
    add_term: 2, sub_term: 2, mul_term: 2, div_term: 2, err_term: 1,
    # query macro for guard clauses
    is_error: 1
  ]

  @doc """
  Adds two symbolic terms together, simplifying if possible.
  """
  def add(left, right)
  def add(err,_) when is_error(err), do: err
  def add(_,err) when is_error(err), do: err
  def add(u, 0), do: u
  def add(0, v), do: v
  def add(u, v) when is_number(u) and is_number(v), do: u + v
  def add(u, n) when is_number(n) and n < 0, do: sub_term(u, -n)
  def add(u, u), do: mul_term(2, u)
  def add(u, v), do: add_term(u, v)


  @doc """
  Subtracts one symbolic term from another, simplifying if possible.
  """
  def subtract(minuend, subtrahend)
  def subtract(err,_) when is_error(err), do: err
  def subtract(_,err) when is_error(err), do: err
  def subtract(u, u), do: 0
  def subtract(u, v) when is_number(u) and is_number(v), do: u - v
  def subtract(u, 0), do: u
  def subtract(0, v), do: mul_term(-1, v)
  def subtract(u, v), do: sub_term(u, v)


  @doc """
  Multiplies two symbolic terms, simplifying if possible.
  """
  def multiply(left, right)
  def multiply(err,_) when is_error(err), do: err
  def multiply(_,err) when is_error(err), do: err
  def multiply(_, 0), do: 0
  def multiply(0, _), do: 0
  def multiply(u, 1), do: u
  def multiply(1, v), do: v
  def multiply(u, v) when is_number(u) and is_number(v), do: u * v
  def multiply(u, v), do: mul_term(u, v)


  @doc """
  Divides two symbolic terms, simplifying if possible.

  Dividing by zero is not permitted and will return an error.
  """
  def divide(dividend, divisor)
  def divide(err,_) when is_error(err), do: err
  def divide(_,err) when is_error(err), do: err
  def divide(_, 0), do: err_term("cannot divide by zero")
  def divide(0, _), do: 0
  def divide(u, 1), do: u
  def divide(u, v) when is_number(u) and is_number(v), do: u / v
  def divide(u, v), do: div_term(u, v)
end
