defmodule SymbolicArithmetic do
  @type op :: :+ | :- | :* | :/
  @type error :: {:error, String.t}
  @type mathterm :: {op, mathterm, mathterm} | number | atom | error

  # symbolic arithmetic

  @spec add(mathterm, mathterm) :: mathterm
  def add({:error,_}=err,_), do: err
  def add(_,{:error,_}=err), do: err
  def add(u, 0), do: u
  def add(0, v), do: v
  def add(u, v) when is_number(u) and is_number(v), do: u + v
  def add(u, u), do: mul_term(2, u)
  def add(u, v), do: add_term(u, v)

  @spec subtract(mathterm, mathterm) :: mathterm
  def subtract({:error,_}=err,_), do: err
  def subtract(_,{:error,_}=err), do: err
  def subtract(u, u), do: 0
  def subtract(u, v) when is_number(u) and is_number(v), do: u - v
  def subtract(u, 0), do: u
  def subtract(0, v), do: mul_term(-1, v)
  def subtract(u, v), do: sub_term(u, v)

  @spec multiply(mathterm, mathterm) :: mathterm
  def multiply({:error,_}=err,_), do: err
  def multiply(_,{:error,_}=err), do: err
  def multiply(_, 0), do: 0
  def multiply(0, _), do: 0
  def multiply(u, 1), do: u
  def multiply(1, v), do: v
  def multiply(u, v) when is_number(u) and is_number(v), do: u * v
  def multiply(u, v), do: mul_term(u, v)

  @spec divide(mathterm, mathterm) :: mathterm
  def divide({:error,_}=err,_), do: err
  def divide(_,{:error,_}=err), do: err
  def divide(_, 0), do: {:error, "cannot divide by zero"}
  def divide(0, _), do: 0
  def divide(u, 1), do: u
  def divide(u, v) when is_number(u) and is_number(v), do: u / v
  def divide(u, v), do: div_term(u, v)

  # construct the term literals

  @spec add_term(mathterm, mathterm) :: mathterm
  @spec sub_term(mathterm, mathterm) :: mathterm
  @spec mul_term(mathterm, mathterm) :: mathterm
  @spec div_term(mathterm, mathterm) :: mathterm
  defp add_term(u, v), do: {:+, u, v}
  defp sub_term(u, v), do: {:-, u, v}
  defp mul_term(u, v), do: {:*, u, v}
  defp div_term(u, v), do: {:/, u, v}
end
