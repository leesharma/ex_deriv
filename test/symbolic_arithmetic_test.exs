defmodule SymbolicArithmeticTest do
  use ExUnit.Case
  doctest SymbolicArithmetic
  import SymbolicArithmetic, only: [add: 2, subtract: 2, multiply: 2, divide: 2]

  import SymbolicExpressions, only: [
    add_term: 2, sub_term: 2, mul_term: 2, div_term: 2, is_error: 1,
  ]

  ## ADDITION #################################################################

  test "addition with zero reduces to the other term" do
    assert :x == add(:x, 0)
    assert :x == add(0, :x)
  end

  test "addition with two constants reduces to a constant" do
    assert 111 == add(10, 101)
  end

  test "addition with a constant and a variable doesn't reduce" do
    assert add_term(10,:x) == add(10, :x)
    assert add_term(:x,10) == add(:x, 10)
  end

  test "addition with two different variables doesn't reduce" do
    assert add_term(:x, :y) == add(:x, :y)
  end

  test "addition with two of the same variable reduces to *2" do
    assert mul_term(2,:x) == add(:x, :x)
  end

  ## SUBTRACTION ##############################################################

  test "subtraction with zero on the right reduces to the left term" do
    assert :x == subtract(:x, 0)
  end

  test "subtraction with zero on the left reduces to the negative right term" do
    assert mul_term(-1,:x) == subtract(0, :x)
  end

  test "subtraction with two constants reduces to a constant" do
    assert 10 == subtract(111, 101)
  end

  test "subtraction with a constant and a variable doesn't reduce" do
    assert sub_term(10,:x) == subtract(10, :x)
    assert sub_term(:x,10) == subtract(:x, 10)
  end

  test "subtracting two different variables doesn't reduce" do
    assert sub_term(:x,:y) == subtract(:x, :y)
  end

  test "subtracting two of the same variable reduces to 0" do
    assert 0 == subtract(:x, :x)
  end

  ## MULTIPLICATION ###########################################################

  test "multiplication with zero reduces to zero" do
    assert 0 == multiply(:x, 0)
    assert 0 == multiply(0, :x)
  end

  test "multiplication with one reduces to the other term" do
    assert :x == multiply(:x, 1)
    assert :x == multiply(1, :x)
  end

  test "multiplication with two constants reduces to the product" do
    assert 1010 == multiply(10, 101)
  end

  test "multiplication with a constant and a variable doesn't reduce" do
    assert mul_term(10,:x) == multiply(10, :x)
    assert mul_term(:x,10) == multiply(:x, 10)
  end

  test "multiplying two different variables doesn't reduce" do
    assert mul_term(:x, :y) == multiply(:x, :y)
  end

  ## DIVISION #################################################################

  test "cannot divide by zero" do
    assert is_error(divide(:x, 0))
  end

  test "division with zero on the right is zero" do
    assert 0 == divide(0, :x)
  end

  test "division with one on the right reduces to the left term" do
    assert :x == divide(:x, 1)
  end

  test "division with one on the left doesn't reduce" do
    assert div_term(1,:x) == divide(1, :x)
  end

  test "division with two constants reduces to a constant" do
    assert 10.0 == divide(1010, 101)
  end

  test "division with a nonzero constant and a variable doesn't reduce" do
    assert div_term(10,:x) == divide(10, :x)
    assert div_term(:x,10) == divide(:x, 10)
  end

  test "dividing two different variables doesn't reduce" do
    assert div_term(:x,:y) == divide(:x, :y)
  end

  test "divide by zero error propagates to the left" do
    # ((((1/0) / w) * x) + y) - z = ERROR
    result = divide(1, 0)
             |> divide(:w)
             |> multiply(:x)
             |> add(:y)
             |> subtract(:z)

    assert is_error(result)
  end

  test "divide by zero error propagates to the right" do
    # z - (y + (x * (w / (1/0)))) = ERROR
    result = subtract(:z,
                      add(:y,
                          multiply(:x,
                                   divide(:w,
                                          divide(1, 0)))))

    assert is_error(result)
  end
end
