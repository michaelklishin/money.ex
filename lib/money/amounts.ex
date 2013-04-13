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

  @spec amount_of(Money.iso_code, Money.amount) :: Money.t
  def amount_of(currency_unit, amount) do
    Money.new(currency_unit: C.by_name(currency_unit), amount: :decimal_conv.number(amount))
  end

  @spec of_major(Money.iso_code, Money.amount_in_major_units) :: Money.t
  def of_major(currency_unit, amount_in_major_units) do
    Money.new(currency_unit: C.by_name(currency_unit), amount: :decimal_conv.number(amount_in_major_units))
  end

  @spec of_minor(Money.iso_code, Money.amount_in_minor_units) :: Money.t
  def of_minor(currency_unit, amount_in_minor_units) do
    c   = C.by_name(currency_unit)
    s   = amount_in_minor_units_to_decimal(amount_in_minor_units, c.decimal_places)

    Money.new(currency_unit: c, amount: s)
  end

  @spec zero(Money.iso_code) :: Money.t
  def zero(currency_unit) do
    Money.new(currency_unit: C.by_name(currency_unit), amount: :decimal_conv.number(0))
  end

  @spec zero?(Money.t) :: boolean
  def zero?(money) do
    :decimal.is_zero(money.amount)
  end

  @spec positive?(Money.t) :: boolean
  def positive?(money) do
    :erlang.element(1, money.amount) == 0 && :erlang.element(2, money.amount) > 0
  end

  @spec negative?(Money.t) :: boolean
  def negative?(money) do
    :erlang.element(1, money.amount) == 1
  end

  @spec positive_or_zero?(Money.t) :: boolean
  def positive_or_zero?(money) do
    positive?(money) || zero?(money)
  end

  @spec negative_or_zero?(Money.t) :: boolean
  def negative_or_zero?(money) do
    negative?(money) || zero?(money)
  end

  def compare(Money[currency_unit: C.Currency[code: code]] = a, Money[currency_unit: C.Currency[code: code]] = b) do

    :decimal.compare(a.amount, b.amount)
  end

  def compare(a, b) do
    fail_because_currencies_are_not_the_same(a, b)
  end

  @spec equals?(Money.t, Money.t) :: boolean
  def equals?(a, b) do
    compare(a, b) == 0
  end

  @spec greater_than?(Money.t, Money.t) :: boolean
  def greater_than?(Money[currency_unit: C.Currency[code: code]] = a, Money[currency_unit: C.Currency[code: code]] = b) do

    :decimal.compare(a.amount, b.amount) == 1
  end

  def greater_than?(a, b) do
    fail_because_currencies_are_not_the_same(a, b)
  end

  @spec less_than?(Money.t, Money.t) :: boolean
  def less_than?(Money[currency_unit: C.Currency[code: code]] = a, Money[currency_unit: C.Currency[code: code]] = b) do

    :decimal.compare(a.amount, b.amount) == -1
  end

  def less_than?(a, b) do
    fail_because_currencies_are_not_the_same(a, b)
  end

  @spec greater_than_or_equals?(Money.t, Money.t) :: boolean
  def greater_than_or_equals?(Money[currency_unit: C.Currency[code: code]] = a, Money[currency_unit: C.Currency[code: code]] = b) do

    c = :decimal.compare(a.amount, b.amount)
    c == 1 || c == 0
  end

  def greater_than_or_equals?(a, b) do
    fail_because_currencies_are_not_the_same(a, b)
  end


  @spec less_than_or_equals?(Money.t, Money.t) :: boolean
  def less_than_or_equals?(Money[currency_unit: C.Currency[code: code]] = a, Money[currency_unit: C.Currency[code: code]] = b) do

    c = :decimal.compare(a.amount, b.amount)
    c == -1 || c == 0
  end

  def less_than_or_equals?(a, b) do
    fail_because_currencies_are_not_the_same(a, b)
  end


  @spec add(Money.t, Money.t) :: Money.t
  def add(Money[currency_unit: C.Currency[code: code]] = a, Money[currency_unit: C.Currency[code: code]] = b) do

    x = :decimal.add(a.amount, b.amount)
    Money.new(currency_unit: a.currency_unit, amount: x)
  end

  def add(a, b) do
    fail_because_currencies_are_not_the_same(a, b)
  end

  def add(Money[currency_unit: C.Currency[code: code]] = a, Money[currency_unit: C.Currency[code: code]] = b, context) do

    x = :decimal.add(a.amount, b.amount, context)
    Money.new(currency_unit: a.currency_unit, amount: x)
  end

  def add(a, b, _) do
    fail_because_currencies_are_not_the_same(a, b)
  end



  # TODO: plus-major
  # TODO: plus-minor

  @spec subtract(Money.t, Money.t) :: Money.t
  def subtract(Money[currency_unit: C.Currency[code: code]] = a, Money[currency_unit: C.Currency[code: code]] = b) do

    x = :decimal.subtract(a.amount, b.amount)
    Money.new(currency_unit: a.currency_unit, amount: x)
  end

  def subtract(a, b) do
    fail_because_currencies_are_not_the_same(a, b)
  end

  def subtract(Money[currency_unit: C.Currency[code: code]] = a, Money[currency_unit: C.Currency[code: code]] = b, context) do

    x = :decimal.subtract(a.amount, b.amount, context)
    Money.new(currency_unit: a.currency_unit, amount: x)
  end

  def subtract(a, b, _) do
    fail_because_currencies_are_not_the_same(a, b)
  end


  # TODO: total

  @spec multiply(Money.t, amount) :: Money.t
  def multiply(a, b) do
    x = :decimal.multiply(a.amount, b)
    Money.new(currency_unit: a.currency_unit, amount: x)
  end

  def multiply(a, b, context) do
    x = :decimal.multiply(a.amount, b, context)
    Money.new(currency_unit: a.currency_unit, amount: x)
  end

  @spec divide(Money.t, amount) :: Money.t
  def divide(a, b) do
    x = :decimal.divide(a.amount, b)
    Money.new(currency_unit: a.currency_unit, amount: x)
  end

  def divide(a, b, context) do
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

  defp fail_because_currencies_are_not_the_same(a, b) do
    s = :io_lib.format("currencies are not the same: ~w, ~w", [a.currency_unit.code, b.currency_unit.code]) |> iolist_to_binary

    raise ArgumentError.new(message: s)
  end
end
