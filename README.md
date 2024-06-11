# LiveForm for LiveView Native

`liveview-native-live-form` is an add-on library for [LiveView Native](https://github.com/liveview-native/live_view_native). It adds support for HTML-style forms on native platforms.

## Installation

1. In Xcode, select *File → Add Packages...*
2. Enter the package URL `https://github.com/liveview-native/liveview-native-live-form`
3. Select *Add Package*

## Usage

Import `LiveViewNativeLiveForm` and add `.liveForm` to the list of addons on your `LiveView`:

```swift
import SwiftUI
import LiveViewNative
import LiveViewNativeLiveForm

struct ContentView: View {
    var body: some View {
        #LiveView(
            .localhost,
            addons: [.liveForm]
        )
    }
}
```

Now you can use the `LiveForm` and `LiveSubmitButton` elements in your template.

```heex
<LiveForm
  id="my-form"
  phx-change="form-changed"
  phx-submit="submit"
>
  <TextField name="username">Username</TextField>
  <SecureField name="password">Password</SecureField>
  <LiveSubmitButton>Submit</LiveSubmitButton>
</LiveForm>
```
