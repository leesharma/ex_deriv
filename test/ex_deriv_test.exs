defmodule ExDerivTest do
  use ExUnit.Case
  doctest ExDeriv
  import ExDeriv, only: [derive: 2]

  # (u+v)' = u' + v'
  test "sum rule" do
    assert 2 == derive({:+, :x, :x}, :x)
    assert 3 == derive({:+, :x, {:+, :x, :x}}, :x)
    assert 0 == derive({:+, :x, :x}, :y)
  end

  # (u-v)' = u' - v'
  test "difference rule" do
    assert 0 == derive({:-, :x, :x}, :x)
    assert 1 == derive({:-, :x, {:-, :x, :x}}, :x)
    assert 0 == derive({:-, :x, :x}, :y)
  end

  # product rule: (uv)' = u'v + uv'
  test "product rule" do
    assert :b == derive({:*, :a, :b}, :a)
  end

  # quotient rule: (u/v)' = (u'v - uv') / v^2
  test "quotient rule" do
    assert {:/, :b, {:*, :b, :b}} == derive({:/, :a, :b}, :a)
    assert {:error,_} = derive({:/, :a, 0}, :a)
  end

  test "error propagation" do
    assert {:error,_} = derive({:*, :x, {:+, 5, {:/, :x, 0}}}, :x)
  end
end
