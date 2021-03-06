defmodule DexyLib.Mixfile do
  use Mix.Project

  def project do
    [app: :dexy_lib,
     version: "0.2.1",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description(),
     package: package(),
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [
      :logger, :timex, :poison
    ]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:ex_doc, "~> 0.14", only: :dev},
      {:timex, "~> 3.0"},

      # adapters
      {:poison, "~> 3.0"},
    ]
  end

  defp description do
    """
    Core library that is used in Dex platform.
    """
  end

  defp package do
    [
      name: :dexy_lib,
      licenses: ["Apache 2.0"],
      maintainers: ["Kook Maeng"],
      links: %{
        "GitHub" => "https://github.com/dexyio/dexy_lib"
      }
    ]
  end

end
