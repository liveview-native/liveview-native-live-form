defmodule LiveViewNative.LiveForm.MixProject do
  use Mix.Project

  @version "0.3.1"
  @source_url "https://github.com/liveview-native/liveview-native-live-form"

  def project do
    [
      app: :live_view_native_live_form,
      version: @version,
      elixir: "~> 1.15",
      description: description(),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      build_path: "elixir/_build",
      config_path: "elixir/config/config.exs",
      deps_path: "elixir/deps",
      package: package(),
      elixirc_paths: elixirc_paths(Mix.env()),
      docs: docs(),
      test_paths: ["elixir/test"]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(:test), do: ["elixir/lib", "elixir/test/support"]
  defp elixirc_paths(_), do: ["elixir/lib"]

  defp deps do
    [
      {:ex_doc, "~> 0.24", only: :dev, runtime: false},
      {:makeup_eex, ">= 0.1.1", only: :dev, runtime: false},
      {:floki, ">= 0.30.0", only: :test},
      {:live_view_native, github: "liveview-native/live_view_native"},
      {:live_view_native_test_endpoint, github: "liveview-native/live_view_native_test_endpoint", brach: "main", only: :test}
    ]
  end

  defp docs do
    [
      extras: ["README.md"],
      main: "readme",
      source_url: @source_url,
      source_ref: "v#{@version}"
    ]
  end

  defp description, do: "LiveView Native LiveForm"

  defp package do
    %{
      maintainers: ["Brian Cardarella"],
      licenses: ["MIT"],
      files: ~w(elixir/lib  mix.exs README* LICENSE* CHANGELOG*),
      links: %{
        "GitHub" => @source_url,
        "Built by DockYard, Expert Elixir & Phoenix Consultants" => "https://dockyard.com/phoenix-consulting"
      }
    }
  end
end
