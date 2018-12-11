defmodule SymbolicArithmetic do
  @moduledoc """
  Symbolic arithmetic library for Elixir.
  """


  @typedoc """
  Basic arithmetic operation.

  This includes all currently supported operations in the `SymbolicArithmetic`
  library.
  """
  @type op :: :+ | :- | :* | :/

  @typedoc "Arithmetic error."
  @type error :: {:error, String.t}

  @typedoc """
  Symbolic math term.

  This can be either a binary operation, a variable, a constant, or an error.
  """
  @type mathterm :: {op, mathterm, mathterm} | number | atom | error


  @doc """
  Adds two symbolic terms together.

  If the terms can be reduced (e.g. `0 + <term>` or `<number> + <number>`), the
  expression will be simplified. Otherwise, the function will return a symbolic
  arithmetic term.

  Errors in either argument will be propagated up.

  ## Examples

      iex> SymbolicArithmetic.add(0, :variable)
      :variable

      iex> SymbolicArithmetic.add(5, 5)
      10

      iex> SymbolicArithmetic.add(:x, :y)
      {:+, :x, :y}

      iex> SymbolicArithmetic.add(:x, {:error, "reason"})
      {:error, "reason"}

  """
  @spec add(mathterm, mathterm) :: mathterm
  def add(left, right)
  def add({:error,_}=err,_), do: err
  def add(_,{:error,_}=err), do: err
  def add(u, 0), do: u
  def add(0, v), do: v
  def add(u, v) when is_number(u) and is_number(v), do: u + v
  def add(u, u), do: mul_term(2, u)
  def add(u, v), do: add_term(u, v)


  @doc """
  Subtracts one symbolic term from another.

  If the terms can be reduced (e.g. `<term> - 0` or `<number> - <number>`), the
  expression will be simplified. Otherwise, the function will return a symbolic
  arithmetic term.

  Errors in either argument will be propagated up.

  ## Examples

      iex> SymbolicArithmetic.subtract(:variable, 0)
      :variable

      iex> SymbolicArithmetic.subtract(5, 5)
      0

      iex> SymbolicArithmetic.subtract(:x, :y)
      {:-, :x, :y}

      iex> SymbolicArithmetic.subtract(:x, {:error, "reason"})
      {:error, "reason"}

  """
  @spec subtract(mathterm, mathterm) :: mathterm
  def subtract(minuend, subtrahend)
  def subtract({:error,_}=err,_), do: err
  def subtract(_,{:error,_}=err), do: err
  def subtract(u, u), do: 0
  def subtract(u, v) when is_number(u) and is_number(v), do: u - v
  def subtract(u, 0), do: u
  def subtract(0, v), do: mul_term(-1, v)
  def subtract(u, v), do: sub_term(u, v)


  @doc """
  Multiplies two symbolic terms

  If the terms can be reduced (e.g. `<term> * 0` or `<term> * 1`), the
  expression will be simplified. Otherwise, the function will return a symbolic
  arithmetic term.

  Errors in either argument will be propagated up.

  ## Examples

      iex> SymbolicArithmetic.multiply(:variable, 0)
      0

      iex> SymbolicArithmetic.multiply(:variable, 1)
      :variable

      iex> SymbolicArithmetic.multiply(2, 3)
      6

      iex> SymbolicArithmetic.multiply(:x, :y)
      {:*, :x, :y}

      iex> SymbolicArithmetic.multiply(:x, {:error, "reason"})
      {:error, "reason"}

  """
  @spec multiply(mathterm, mathterm) :: mathterm
  def multiply(left, right)
  def multiply({:error,_}=err,_), do: err
  def multiply(_,{:error,_}=err), do: err
  def multiply(_, 0), do: 0
  def multiply(0, _), do: 0
  def multiply(u, 1), do: u
  def multiply(1, v), do: v
  def multiply(u, v) when is_number(u) and is_number(v), do: u * v
  def multiply(u, v), do: mul_term(u, v)


  @doc """
  Divides two symbolic terms.

  If the terms can be reduced (e.g. `<term> / 1` or `<number> / <number>`), the
  expression will be simplified. Like with standard Elixir, constant division
  will return a float. Dividing by zero is not permitted and will return an
  error.

  Errors in either argument will be propagated up.

  ## Examples

      iex> SymbolicArithmetic.divide(:variable, 0)
      {:error, "cannot divide by zero"}

      iex> SymbolicArithmetic.divide(5, 5)
      1.0

      iex> SymbolicArithmetic.divide(:x, :y)
      {:/, :x, :y}

      iex> SymbolicArithmetic.divide(:x, {:error, "reason"})
      {:error, "reason"}

  """
  @spec divide(mathterm, mathterm) :: mathterm
  def divide(dividend, divisor)
  def divide({:error,_}=err,_), do: err
  def divide(_,{:error,_}=err), do: err
  def divide(_, 0), do: {:error, "cannot divide by zero"}
  def divide(0, _), do: 0
  def divide(u, 1), do: u
  def divide(u, v) when is_number(u) and is_number(v), do: u / v
  def divide(u, v), do: div_term(u, v)

  # Constructs the aritmetic expression literals
  #
  # These are represented by AST-like tuples: {operation, left, right}
  #
  @spec add_term(mathterm, mathterm) :: mathterm
  @spec sub_term(mathterm, mathterm) :: mathterm
  @spec mul_term(mathterm, mathterm) :: mathterm
  @spec div_term(mathterm, mathterm) :: mathterm
  defp add_term(u, v), do: {:+, u, v}
  defp sub_term(u, v), do: {:-, u, v}
  defp mul_term(u, v), do: {:*, u, v}
  defp div_term(u, v), do: {:/, u, v}
end
