defmodule Money.Currencies do
  @moduledoc """
  Currencies and their attributes
  """

  defrecord Currency, [:code, :numeric, :decimal_places, :country_codes] do
    @moduledoc """
    Represents a currency with ISO-4217 code (e.g. USD), numeric code (e.g. 756 for CHF),
    number of decimal places (e.g. 2 for USD and 0 for JPY) and one or more country codes
    """
  end


  rows = Enum.drop(File.iterator!(Path.expand("../currencies.csv", __FILE__)), 1)

  Enum.each rows, fn(line) ->
     [iso_code, numeric_code, decimal_places, country_code_line] = String.split(line, ",")
     country_codes = Enum.map (lc <<x :: [2,binary]>> inbits country_code_line, do: x), fn x -> String.strip(x) end

     lc name inlist [iso_code, 
                     String.downcase(iso_code), 
                     binary_to_atom(iso_code), binary_to_atom(String.downcase(iso_code))] do
       def by_name(unquote(name)) do
         Currency.new(code: unquote(iso_code), numeric: unquote(numeric_code), decimal_places: unquote(binary_to_integer(decimal_places)), country_codes: unquote(country_codes))
       end
     end
  end


  Enum.each rows, fn(line) ->
     [iso_code, numeric_code, decimal_places, country_code_line] = String.split(line, ",")
     country_codes = lc <<x :: [2,binary]>> inbits country_code_line, do: x

     lc code inlist [numeric_code, binary_to_integer(numeric_code)] do
       def by_code(unquote(code)) do
         Currency.new(code: unquote(iso_code), numeric: unquote(numeric_code), decimal_places: unquote(binary_to_integer(decimal_places)), country_codes: unquote(country_codes))
       end
     end
  end
end
