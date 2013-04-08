Code.require_file "../test_helper.exs", __FILE__

defmodule AmountsTest do
  use ExUnit.Case

  alias Money.Amounts, as: M

  test "amount_of" do
    a = M.amount_of(:usd, 20.0)

    assert a.currency_unit.code == "USD"
    assert a.amount == :decimal_conv.number(20.0)
  end

  test "of_major" do
    a = M.of_major(:usd, 20)

    assert a.currency_unit.code == "USD"
    assert a.amount == :decimal_conv.number(20)
  end


  test "of_minor" do
  end


  test "zero" do
    a = M.zero(:usd)

    assert a.currency_unit.code == "USD"
    assert a.amount == :decimal_conv.number(0)
  end

  test "zero?" do
    x = M.amount_of(:usd, 20.0)
    z = M.zero(:usd)

    assert M.zero?(z)
    assert !M.zero?(x)
  end

  test "positive?" do
    p = M.amount_of(:usd, 20.0)
    n = M.amount_of(:usd, -20.0)

    assert M.positive?(p)
    assert !M.positive?(n)
  end

  test "negative?" do
    p = M.amount_of(:usd, 20.0)
    n = M.amount_of(:usd, -20.0)

    assert !M.negative?(p)
    assert M.negative?(n)
  end


  test "positive_or_zero?" do
    p = M.amount_of(:usd, 20.0)
    n = M.amount_of(:usd, -20.0)
    z = M.zero(:usd)

    assert M.positive_or_zero?(p)
    assert M.positive_or_zero?(z)
    assert !M.positive_or_zero?(n)
  end

  test "negative_or_zero?" do
    p = M.amount_of(:usd, 20.0)
    n = M.amount_of(:usd, -20.0)
    z = M.zero(:usd)

    assert !M.negative_or_zero?(p)
    assert M.negative_or_zero?(z)
    assert M.negative_or_zero?(n)
  end

  test "compare" do
    a = M.amount_of(:usd, 20.0)
    b = M.amount_of(:usd, -20.0)
    c = M.amount_of(:usd, 20)
    d = M.of_minor(:usd, 2000)

    assert M.compare(a, b) == 1
    assert M.compare(b, a) == -1
    assert M.compare(c, a) == 0
    assert M.compare(a, c) == 0
    assert M.compare(a, d) == 0
    assert M.compare(c, d) == 0
  end

  test "equals?" do
    a = M.amount_of(:usd, 20.0)
    b = M.amount_of(:usd, 20)
    c = M.of_minor(:usd, 2000)
    d = M.amount_of(:usd, 10)

    assert M.equals?(a, b)
    assert M.equals?(b, c)
    assert M.equals?(a, c)
    assert !M.equals?(a, d)
    assert !M.equals?(c, d)
  end


  test "greater_than?" do
    a = M.amount_of(:usd, 20.0)
    b = M.amount_of(:usd, 10)
    c = M.of_minor(:usd, 500)
    d = M.amount_of(:usd, -10)

    assert M.greater_than?(a, b)
    assert M.greater_than?(b, c)
    assert M.greater_than?(a, c)
    assert !M.greater_than?(d, a)
    assert !M.greater_than?(c, b)
  end

  test "less_than?" do
    a = M.amount_of(:usd, 20.0)
    b = M.amount_of(:usd, 10)
    c = M.of_minor(:usd, 500)
    d = M.amount_of(:usd, -10)

    assert M.less_than?(b, a)
    assert M.less_than?(c, b)
    assert M.less_than?(c, a)
    assert !M.less_than?(a, d)
    assert !M.less_than?(b, c)
  end

  test "greater_than_or_equals?" do
    a = M.amount_of(:usd, 20.0)
    b = M.of_major(:usd, 20)
    c = M.of_minor(:usd, 500)
    d = M.amount_of(:usd, -10)

    assert M.greater_than_or_equals?(a, b)
    assert M.greater_than_or_equals?(b, c)
    assert M.greater_than_or_equals?(a, c)
    assert !M.greater_than_or_equals?(d, a)
    assert !M.greater_than_or_equals?(c, b)
  end

  test "less_than_or_equals?" do
    a = M.amount_of(:usd, 20.0)
    b = M.of_major(:usd, 20)
    c = M.of_minor(:usd, 500)
    d = M.amount_of(:usd, -10)

    assert M.less_than_or_equals?(b, a)
    assert M.less_than_or_equals?(c, b)
    assert M.less_than_or_equals?(c, a)
    assert !M.less_than_or_equals?(a, d)
    assert !M.less_than_or_equals?(b, c)
  end

  test "add" do
    a = M.amount_of(:usd, 20.0)
    b = M.of_major(:usd, 20)
    c = M.of_minor(:usd, 500)
    d = M.amount_of(:usd, -10)

    assert M.equals?(M.add(a, b), M.amount_of(:usd, 40))
    assert M.equals?(M.add(a, c), M.amount_of(:usd, 25))
    assert M.equals?(M.add(c, d), M.amount_of(:usd, -5))
  end

  test "subtract" do
    a = M.amount_of(:usd, 20.0)
    b = M.of_major(:usd, 20)
    c = M.of_minor(:usd, 500)
    d = M.amount_of(:usd, -10)

    assert M.equals?(M.subtract(a, b), M.amount_of(:usd, 0))
    assert M.equals?(M.subtract(b, c), M.amount_of(:usd, 15))
    assert M.equals?(M.subtract(c, d), M.amount_of(:usd, 15))
  end


  test "multiply" do
    a = M.amount_of(:usd, 20.0)
    b = M.of_major(:usd, 20)
    c = M.amount_of(:usd, -10)

    assert M.equals?(M.multiply(a, 10), M.amount_of(:usd, 200))
    assert M.equals?(M.multiply(b, 5), M.amount_of(:usd, 100))
    assert M.equals?(M.multiply(c, 2), M.amount_of(:usd, -20))
  end

  test "divide" do
    a = M.amount_of(:usd, 20.0)
    b = M.of_major(:usd, 20)
    c = M.amount_of(:usd, -10)

    assert M.equals?(M.divide(a, 4), M.amount_of(:usd, 5))
    assert M.equals?(M.divide(b, 0.5), M.amount_of(:usd, 40))
    assert M.equals?(M.divide(c, 2.0), M.amount_of(:usd, -5))
  end
end
