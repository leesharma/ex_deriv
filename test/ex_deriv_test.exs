defmodule ExDerivTest do
  use ExUnit.Case
  doctest ExDeriv
  import ExDeriv, only: [derive: 2]

  # for constructing targets and expected results
  import SymbolicExpressions, only: [
    add_term: 2, sub_term: 2, mul_term: 2, div_term: 2, is_error: 1
  ]

  # sum rule: (u+v)' = u' + v'
  test "sum rule" do
    # d(x+x)/dx = 2
    assert 2 == derive(add_term(:x,:x), :x)
    # d(x+x+x)/dx = 3
    assert 3 == derive(add_term(:x, add_term(:x,:x)), :x)
    # d(x+x)/dx = 0
    assert 0 == derive(add_term(:x,:x), :y)
  end

  # difference rule: (u-v)' = u' - v'
  test "difference rule" do
    # d(x-x)/dx = 0
    assert 0 == derive(sub_term(:x,:x), :x)
    # d(x-(x-x))/dx = 1
    assert 1 == derive(sub_term(:x, sub_term(:x,:x)), :x)
    # d(x-x)/dy = 0
    assert 0 == derive(sub_term(:x,:x), :y)
  end

  # product rule: (uv)' = u'v + uv'
  test "product rule" do
    # d(a*b)/da = b
    assert :b == derive(mul_term(:a,:b), :a)
  end

  # quotient rule: (u/v)' = (u'v - uv') / v^2
  test "quotient rule" do
    # d(a/b)/da = b/(b*b) = 1/b
    assert div_term(:b, mul_term(:b,:b)) == derive(div_term(:a,:b), :a)
    # d(a/0)/da = ERROR
    assert is_error(
      derive(div_term(:a,0), :a)
    )
  end

  test "error propagation" do
    # d(x*(5+x/0))/dx = ERROR
    assert is_error(
      derive(mul_term(:x,
                      add_term(5,
                               div_term(:x,0))), :x)
    )
  end
end
