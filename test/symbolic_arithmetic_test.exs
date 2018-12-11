defmodule SymbolicArithmeticTest do
  use ExUnit.Case
  doctest SymbolicArithmetic
  require SymbolicArithmetic, as: Sym

  ## ADDITION #################################################################

  test "addition with zero on the left" do
    assert :x == Sym.add(:x, 0)
  end

  test "addition with zero on the right" do
    assert :x == Sym.add(0, :x)
  end

  test "addition with two constants" do
    assert 111 == Sym.add(10, 101)
  end

  test "addition with a constant and a variable" do
    assert {:+, 10, :x} == Sym.add(10, :x)
  end

  test "addition with a variable and a constant" do
    assert {:+, :x, 10} == Sym.add(:x, 10)
  end

  test "addition with two different variables" do
    assert {:+, :x, :y} == Sym.add(:x, :y)
  end

  test "addition with two of the same variable" do
    assert {:*, 2, :x} == Sym.add(:x, :x)
  end

  ## SUBTRACTION ##############################################################

  test "subtraction with zero on the left" do
    assert :x == Sym.subtract(:x, 0)
  end

  test "subtraction with zero on the right" do
    assert {:*, -1, :x} == Sym.subtract(0, :x)
  end

  test "subtraction with two constants" do
    assert 10 == Sym.subtract(111, 101)
  end

  test "subtraction with another constant and zero" do
    assert 101 == Sym.subtract(101, 0)
  end

  test "subtraction with zero and another constant" do
    assert -101 == Sym.subtract(0, 101)
  end

  test "subtraction with a constant and a variable" do
    assert {:-, 10, :x} == Sym.subtract(10, :x)
  end

  test "subtraction with a variable and a constant" do
    assert {:-, :x, 10} == Sym.subtract(:x, 10)
  end

  test "subtracting two different variables" do
    assert {:-, :x, :y} == Sym.subtract(:x, :y)
  end

  test "subtracting two of the same variable" do
    assert 0 == Sym.subtract(:x, :x)
  end

  ## MULTIPLICATION ###########################################################

  test "multiplication with zero on the left" do
    assert 0 == Sym.multiply(:x, 0)
  end

  test "multiplication with zero on the right" do
    assert 0 == Sym.multiply(0, :x)
  end

  test "multiplication with one on the left" do
    assert :x == Sym.multiply(:x, 1)
  end

  test "multiplication with one on the right" do
    assert :x == Sym.multiply(1, :x)
  end

  test "multiplication with two constants" do
    assert 1010 == Sym.multiply(10, 101)
  end

  test "multiplication with a constant and a variable" do
    assert {:*, 10, :x} == Sym.multiply(10, :x)
  end

  test "multiplication with a variable and a constant" do
    assert {:*, :x, 10} == Sym.multiply(:x, 10)
  end

  test "multiplying two different variables" do
    assert {:*, :x, :y} == Sym.multiply(:x, :y)
  end

  ## DIVISION #################################################################

  test "division with zero on the left" do
    assert {:error, _} = Sym.divide(:x, 0)
  end

  test "division with zero on the right" do
    assert 0 == Sym.divide(0, :x)
  end

  test "division with one on the left" do
    assert :x == Sym.divide(:x, 1)
  end

  test "division with one on the right" do
    assert {:/, 1, :x} == Sym.divide(1, :x)
  end

  test "division with two constants" do
    assert 10.0 == Sym.divide(1010, 101)
  end

  test "division with a constant and a variable" do
    assert {:/, 10, :x} == Sym.divide(10, :x)
  end

  test "division with a variable and a constant" do
    assert {:/, :x, 10} == Sym.divide(:x, 10)
  end

  test "dividing two different variables" do
    assert {:/, :x, :y} == Sym.divide(:x, :y)
  end

  test "divide by zero error propagates to the left" do
    actual = Sym.divide(1, 0)
    |> Sym.divide(:w)
    |> Sym.multiply(:x)
    |> Sym.add(:y)
    |> Sym.subtract(:z)

    assert {:error, _msg} = actual
  end

  test "divide by zero error propagates to the right" do
    actual = Sym.subtract(:z,
                          Sym.add(:y,
                                  Sym.multiply(:x,
                                               Sym.divide(:w,
                                                          Sym.divide(1, 0)))))

    assert {:error, _msg} = actual
  end
end
