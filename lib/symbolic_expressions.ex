defmodule SymbolicExpressions do
  # Constructs the aritmetic expression literals
  #
  # These are represented by AST-like tuples: {operation, left, right}
  #
  def add_term(u, v), do: {:+, [], [u,v]}
  def sub_term(u, v), do: {:-, [], [u,v]}
  def mul_term(u, v), do: {:*, [], [u,v]}
  def div_term(u, v), do: {:/, [], [u,v]}
  def pow_term(u, v) when is_number(v) do
    quote do: :math.pow(unquote(u),unquote(v))
  end
  def pow_term(_, _), do: err_term("variable exponents not supported")

  def err_term(msg), do: {:error, msg}


  # accessor methods

  def left({_,_,[left,_]}),   do: left
  def right({_,_,[_,right]}), do: right

  # query macros for guard clauses

  defmacro is_addition(term) do
    quote do
      is_tuple(unquote(term)) and
      tuple_size(unquote(term)) == 3 and
      elem(unquote(term),0) == :+
    end
  end

  defmacro is_subtraction(term) do
    quote do
      is_tuple(unquote(term)) and
      tuple_size(unquote(term)) == 3 and
      elem(unquote(term),0) == :-
    end
  end

  defmacro is_multiplication(term) do
    quote do
      is_tuple(unquote(term)) and
      tuple_size(unquote(term)) == 3 and
      elem(unquote(term),0) == :*
    end
  end

  defmacro is_division(term) do
    quote do
      is_tuple(unquote(term)) and
      tuple_size(unquote(term)) == 3 and
      elem(unquote(term),0) == :/
    end
  end

  defmacro is_exponent(term) do
    quote do
      unquote(term) |> is_tuple and
      unquote(term) |> tuple_size == 3 and
      unquote(term) |> elem(0) |> is_tuple and
      unquote(term) |> elem(0) |> tuple_size == 3 and
      unquote(term) |> elem(0) |> elem(2) == [:math, :pow]
    end
  end

  defmacro is_error(term) do
    quote do: is_tuple(unquote(term)) and elem(unquote(term),0) == :error
  end
end
