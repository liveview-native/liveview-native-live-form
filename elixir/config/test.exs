import Config

config :mime, :types, %{
  "text/gameboy" => ["gameboy"]
}

config :live_view_native, plugins: [
  LiveViewNativeTest.GameBoy
]

config :phoenix_template, format_encoders: [
  gameboy: Phoenix.HTML.Engine
]

config :phoenix, template_engines: [
  neex: LiveViewNative.Engine
]

config :live_view_native_test_endpoint,
  formats: [:gameboy],
  otp_app: :live_view_native,
  routes: [
    # %{path: "/inline", module: LiveViewNativeTest.InlineLive},
  ]

config :phoenix, :plug_init_mode, :runtime
