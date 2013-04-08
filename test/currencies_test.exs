Code.require_file "../test_helper.exs", __FILE__

defmodule CurrenciessTest do
  use ExUnit.Case

  alias Money.Currencies, as: C

  test "by_name" do
    usd1 = C.by_name("USD")
    usd2 = C.by_name("usd")
    usd3 = C.by_name(:USD)
    usd4 = C.by_name(:usd)

    assert usd1.code == "USD"
    assert usd1 == usd2
    assert usd2 == usd3
    assert usd3 == usd4
  end
end
