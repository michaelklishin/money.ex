defmodule Money.Amounts do
  @moduledoc """
  Operations on monetary amounts, including conversion, parsing, and predicates.
  """

  alias Money.Currencies, as: C


  #
  # API
  #

  defrecord Money, [:currency_unit, :amount] do
    @moduledoc """
    A monetary amount
    """
  end


  def amount_of(currency_unit, amount) do
    Money.new(currency_unit: C.by_name(currency_unit), amount: :decimal_conv.number(amount))
  end

  def of_major(currency_unit, amount_in_major_units) do
    Money.new(currency_unit: C.by_name(currency_unit), amount: :decimal_conv.number(amount_in_major_units))
  end

  def of_minor(currency_unit, amount_in_minor_units) do
    c   = C.by_name(currency_unit)
    s   = amount_in_minor_units_to_decimal(amount_in_minor_units, c.decimal_places)

    Money.new(currency_unit: c, amount: s)
  end

  def zero(currency_unit) do
    Money.new(currency_unit: C.by_name(currency_unit), amount: :decimal_conv.number(0))
  end

  def zero?(money) do
    :decimal.is_zero(money.amount)
  end

  def positive?(money) do
    :erlang.element(1, money.amount) == 0 && :erlang.element(2, money.amount) > 0
  end

  def negative?(money) do
    :erlang.element(1, money.amount) == 1
  end

  def positive_or_zero?(money) do
    positive?(money) || zero?(money)
  end

  def negative_or_zero?(money) do
    negative?(money) || zero?(money)
  end

  def compare(a, b) do
    check_that_currencies_are_identical(a, b)

    :decimal.compare(a.amount, b.amount)
  end

  def equals?(a, b) do
    compare(a, b) == 0
  end

  def greater_than?(a, b) do
    check_that_currencies_are_identical(a, b)

    :decimal.compare(a.amount, b.amount) == 1
  end

  def less_than?(a, b) do
    check_that_currencies_are_identical(a, b)

    :decimal.compare(a.amount, b.amount) == -1
  end

  def greater_than_or_equals?(a, b) do
    check_that_currencies_are_identical(a, b)

    c = :decimal.compare(a.amount, b.amount)
    c == 1 || c == 0
  end

  def less_than_or_equals?(a, b) do
    check_that_currencies_are_identical(a, b)

    c = :decimal.compare(a.amount, b.amount)
    c == -1 || c == 0
  end

  def add(a, b) do
    check_that_currencies_are_identical(a, b)

    x = :decimal.add(a.amount, b.amount)
    Money.new(currency_unit: a.currency_unit, amount: x)
  end

  def add(a, b, context) do
    check_that_currencies_are_identical(a, b)

    x = :decimal.add(a.amount, b.amount, context)
    Money.new(currency_unit: a.currency_unit, amount: x)
  end

  # TODO: plus-major
  # TODO: plus-minor

  def subtract(a, b) do
    check_that_currencies_are_identical(a, b)

    x = :decimal.subtract(a.amount, b.amount)
    Money.new(currency_unit: a.currency_unit, amount: x)
  end

  def subtract(a, b, context) do
    check_that_currencies_are_identical(a, b)

    x = :decimal.subtract(a.amount, b.amount, context)
    Money.new(currency_unit: a.currency_unit, amount: x)
  end

  # TODO: total

  def multiply(a, b) do
    check_that_currencies_are_identical(a, b)

    x = :decimal.multiply(a.amount, b)
    Money.new(currency_unit: a.currency_unit, amount: x)
  end

  def multiply(a, b, context) do
    check_that_currencies_are_identical(a, b)

    x = :decimal.multiply(a.amount, b, context)
    Money.new(currency_unit: a.currency_unit, amount: x)
  end

  def divide(a, b) do
    check_that_currencies_are_identical(a, b)

    x = :decimal.divide(a.amount, b)
    Money.new(currency_unit: a.currency_unit, amount: x)
  end

  def divide(a, b, context) do
    check_that_currencies_are_identical(a, b)

    x = :decimal.divide(a.amount, b, context)
    Money.new(currency_unit: a.currency_unit, amount: x)
  end



  #
  # Implementation
  #

  defp amount_in_minor_units_to_decimal(amount, decimal_places) do
    s = :io_lib.format("~wE-~w", [amount, decimal_places]) |> iolist_to_binary
    :decimal_conv.number(s)
  end

  defp check_that_currencies_are_identical(a, b) do
    if !(a.currency_unit.code == b.currency_unit.code) do
      s = :io_lib.format("currencies are not the same: ~w, ~w", [a.currency_unit.code, b.currency_unit.code]) |> iolist_to_binary

      raise ArgumentError.new(message: s)
      else
        true
    end 
  end
end
