//
//  LiveFormRegistry.swift
//  LiveViewNativeLiveForm
//
//  Created by Shadowfacts on 2/27/23.
//

import LiveViewNative
import SwiftUI

/// This registry provides the Live Form elements.
///
/// This provides the `<live-form>` and `<live-submit-button>` elements, which allow for grouping form controls together and submitting their data together.
///
/// To participate in the form data model, form controls must provide a `name` attribute.
///
/// - Note: `<live-form>` only groups form data, it does not alter the presentation of the elements inside it.
///
/// Add it to your app using an `AggregateRegistry`:
/// ```swift
/// struct AppRegistries: AggregateRegistry {
///     typealias Registries = Registry2<
///         MyRegistry,
///         LiveFormRegistry<Self>
///     >
/// ```
public struct LiveFormRegistry<Root: RootRegistry>: CustomRegistry {
    public enum TagName: String {
        case liveForm = "live-form"
        case liveSubmitButton = "live-submit-button"
    }
    
    public static func lookup(_ name: TagName, element: ElementNode, context: LiveContext<Root>) -> some View {
        switch name {
        case .liveForm:
            LiveForm<Root>(context: context)
        case .liveSubmitButton:
            LiveSubmitButton<Root>(context: context)
        }
    }
}
