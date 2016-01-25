defmodule CodeSamples.Mixfile do
  use Mix.Project

  def application do
    [applications: [:httpoison]]
  end

  def project do
    [app: :code_samples,
     version: "1.0.0",
     deps: deps]
  end

  defp deps do
     [{:poison, "1.5.2"},
     {:httpoison, "~> 0.8.0"}]
  end
end
