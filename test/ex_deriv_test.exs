defmodule ExDerivTest do
  use ExUnit.Case
  doctest ExDeriv
  import ExDeriv, only: [derive: 2]

  # for constructing targets and expected results
  import SymbolicExpressions, only: [
    add_term: 2, sub_term: 2, mul_term: 2, div_term: 2, pow_term: 2,
    is_error: 1
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
    assert div_term(:b, pow_term(:b,2)) == derive(div_term(:a,:b), :a)
    # d(a/0)/da = ERROR
    assert is_error(
      derive(div_term(:a,0), :a)
    )
  end

  # power rule: (x^n)' = n*x^(n-1)    note: x is a symbol!
  test "power rule (simple base)" do
    # d(x^2)/dx = 2x
    assert mul_term(2,:x) == derive(pow_term(:x,2), :x)
    # d(x^4)/dx = 4x^3
    assert mul_term(4, pow_term(:x,3)) == derive(pow_term(:x,4), :x)
    # d(x^-4)/dx = -4 / x^5
    assert mul_term(-4, div_term(1, pow_term(:x,5))) == derive(pow_term(:x,-4), :x)
    # d(x^2)/dy = 0
    assert 0 == derive(pow_term(:x,2), :y)
  end

  # chain rule: f(g(x)) = f'(g(x)) * g'(x)
  test "power rule (chain rule)" do
    # d((x+1)^2)/dx = 2*(x+1)
    assert mul_term(2, add_term(:x,1)) ==
      derive(pow_term(add_term(:x,1),2), :x)

    # d((2x+1)^2)/dx = 4*(2x+1)
    assert mul_term(4, add_term(mul_term(2,:x),1)) ==
      derive(pow_term(add_term(mul_term(2,:x),1),2), :x)

    # d((x/y)^3)/dy = 3(x/y)^2 * -x/y^2 = -3x^3 / y^4
    target = mul_term(mul_term(3, pow_term(div_term(:x,:y), 2)),
                      div_term(mul_term(-1,:x), pow_term(:y,2)))
    assert target ==
      derive(pow_term(div_term(:x,:y),3), :y)
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
