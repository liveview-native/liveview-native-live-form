# LiveViewNativeLiveForm

## About

Supporting library for [LiveViewNative SwiftUI](https://github.com/liveviewnative/liveview-client-swiftui) that provides forms that group multiple pieces of data together and allow them to be submitted in a single event.


## Usage

Add this library as a package to your LiveView Native application's Xcode project using its repo URL. Then, create an `AggregateRegistry` to include the provided `LiveFormRegistry` within your native app builds:

```diff
import SwiftUI
import LiveViewNative
+ import LiveViewNativeLiveForm
+
+ struct MyRegistry: CustomRegistry {
+     typealias Root = AppRegistries
+ }
+
+ struct AppRegistries: AggregateRegistry {
+     typealias Registries = Registry2<
+         MyRegistry,
+         LiveFormRegistry<Self>
+     >
+ }

@MainActor
struct ContentView: View {
-     @StateObject private var session = LiveSessionCoordinator(URL(string: "http://localhost:4000/")!)
+     @StateObject private var session = LiveSessionCoordinator<AppRegistries>(URL(string: "http://localhost:4000/")!)

    var body: some View {
        LiveView(session: session)
    }
}
```
