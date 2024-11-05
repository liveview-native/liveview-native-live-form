//
//  LiveSubmitButton.swift
//  LiveViewNativeLiveForm
//
//  Created by Shadowfacts on 2/27/23.
//

import SwiftUI
@_spi(LiveForm) import LiveViewNative

/// A button that submits a live form.
///
/// Use the same customization options as ``LiveViewNative.Button``.
///
/// ## Attributes
/// - `after-submit`: An action to perform after the form is submitted. Supported actions:
///     - `clear`: clears all values from the form
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@LiveElement
struct LiveButton<Root: RootRegistry>: View {
    @LiveElementIgnored
    @Environment(\.formModel)
    private var formModel
    
    private var type: String = "button"
    
    @LiveElementIgnored
    private var overrideType: String? = nil
    
    init(type: String? = nil) {
        self.overrideType = type
    }
    
    public var body: some View {
        switch overrideType ?? type {
        case "submit":
            LiveViewNative.Button<Root>(action: {
                Task { try await formModel?.sendSubmitEvent() }
            })
        case "reset":
            LiveViewNative.Button<Root>(action: {
                formModel?.clear()
            })
        default:
            LiveViewNative.Button<Root>()
        }
    }
}
