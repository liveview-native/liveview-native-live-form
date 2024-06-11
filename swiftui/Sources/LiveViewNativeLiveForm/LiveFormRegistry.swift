//
//  LiveFormRegistry.swift
//  LiveViewNativeLiveForm
//
//  Created by Shadowfacts on 2/27/23.
//

import LiveViewNative
import LiveViewNativeStylesheet
import SwiftUI

public extension Addons {
    /// This registry provides the Live Form elements.
    ///
    /// This provides the `<LiveForm>` and `<LiveSubmitButton>` elements, which allow for grouping form controls together and submitting their data together.
    ///
    /// - Note: `<LiveForm>` only groups form data, it does not alter the presentation of the elements inside it.
    ///
    /// Add it to your app using the `.liveForm` static member:
    /// ```swift
    /// #LiveView(
    ///     .localhost,
    ///     addons: [.liveForm]
    /// )
    /// ```
    @Addon
    public struct LiveForm<Root: RootRegistry> {
        public enum TagName: String {
            case liveForm = "LiveForm"
            case liveSubmitButton = "LiveSubmitButton"
            case liveHiddenField = "LiveHiddenField"
        }
        
        @ViewBuilder
        public static func lookup(_ name: TagName, element: ElementNode) -> some View {
            switch name {
            case .liveForm:
                LiveViewNativeLiveForm.LiveForm<Root>()
            case .liveSubmitButton:
                LiveSubmitButton<Root>()
            case .liveHiddenField:
                LiveHiddenField()
            }
        }
    }
}
