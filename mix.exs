defmodule FirstLaw.MixProject do
  use Mix.Project

  def project do
    [
      app: :first_law,
      version: "0.1.0",
      elixir: "~> 1.20",
      elixirc_paths: elixirc_paths(Mix.env()),
      erlc_paths: erlc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp erlc_paths(:test), do: ["src", "test/support"]
  defp erlc_paths(_), do: ["src"]

  defp deps do
    [
      {:stream_data, "1.4.0", only: :test}
    ]
  end
end
