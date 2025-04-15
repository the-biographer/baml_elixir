defmodule BamlElixir.MixProject do
  use Mix.Project

  def project do
    [
      app: :baml_elixir,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:rustler, "~> 0.36.1", runtime: false}
    ]
  end

  defp aliases do
    [
      # Add any custom mix aliases here
      "baml.generate": ["compile", "baml.generate"]
    ]
  end
end
