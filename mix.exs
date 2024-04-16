defmodule LiveViewNative.LiveForm.MixProject do
  use Mix.Project

  @version "0.3.0-beta.1"
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
      deps_path: "elixir/deps",
      package: package(),
      elixirc_paths: elixirc_paths(Mix.env()),
      docs: docs()
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
      {:phoenix_live_view, "~> 0.20.4", override: true},
      {:live_view_native, github: "liveview-native/live_view_native", branch: "main"},
      {:live_view_native_test, github: "liveview-native/live_view_native_test", tag: "v0.3.0", only: :test}
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
      links: %{
        "GitHub" => @source_url,
        "Built by DockYard, Expert Elixir & Phoenix Consultants" => "https://dockyard.com/phoenix-consulting"
      }
    }
  end
end
