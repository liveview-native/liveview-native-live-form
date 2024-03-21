//
//  LiveHiddenField.swift
//  LiveViewNativeLiveForm
//
//  Created by Carson.Katri on 3/21/24.
//

import SwiftUI
import LiveViewNative

/// An element that has no visible UI, but provides a value to be sent along with the form.
///
/// This is equivalent to `<input type="hidden" />` in HTML.
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct LiveHiddenField: View {
    public var body: some View {
        // logic is handled within `LiveForm`.
        EmptyView()
    }
}
