# For mix tests
{:ok, _} = LiveViewNativeTest.Endpoint.start_link()

Mix.shell(Mix.Shell.Process)

ExUnit.start()
