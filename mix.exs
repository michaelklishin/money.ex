defmodule MoneyEx.Mixfile do
  use Mix.Project

  def project do
    [ app: :money_ex,
      version: "1.0.0-beta1",
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    []
  end

  # Type `mix help deps` for more examples and options
  defp deps do
    [{:decimal, github: "tim/erlang-decimal", ref: "v0.2.0"}]
  end
end
