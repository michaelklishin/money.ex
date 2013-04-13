defmodule Money do
  @type iso_code :: String.t | atom
  @type numeric_code :: String.t | integer

  # TODO: :decimal's types would be nice to add, too.
  @type amount :: integer | float

  @type amount_in_major_units :: integer
  @type amount_in_minor_units :: integer
end