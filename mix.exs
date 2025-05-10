defmodule BamlElixir.MixProject do
  use Mix.Project

  @version "1.0.0-pre.6"

  def project do
    [
      app: :baml_elixir,
      description: "Call BAML functions from Elixir.",
      version: @version,
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package()
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
      {:rustler, "~> 0.36.1", optional: true},
      {:rustler_precompiled, "~> 0.8"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp package do
    {output, 0} = System.cmd("git", ["ls-files", "lib"])

    lib_files =
      output
      |> String.trim()
      |> String.split("\n")

    [
      files:
        lib_files ++
          [
            "checksum-*.exs",
            "mix.exs",
            "LICENSE"
          ],
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/emilsoman/baml_elixir"},
      maintainers: ["Emil Soman"]
    ]
  end
end
