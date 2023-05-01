# LiveViewNativeLiveForm

Supporting library for [LiveViewNative SwiftUI](https://github.com/liveviewnative/liveview-client-swiftui) that provides forms that group multiple pieces of data together and allow them to be submitted in a single event.

To use this, add the package to your project and then include the registry in your app's aggregate registry:
```swift
struct AppRegistries: AggregateRegistry {
    typealias Registries = Registry2<
        MyRegistry,
        LiveFormRegistry<Self>
    >
}
```
And then use that registry when creating the `LiveSessionCoordinator`:
```swift
struct ContentView: View {
    @State private var session = LiveSessionCoordinator<AppRegistries>(url: URL(string: "...")!)
    // ...
}
```
