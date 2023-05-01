//
//  LiveForm.swift
//  LiveViewNativeLiveForm
//
//  Created by Shadowfacts on 2/27/23.
//

import SwiftUI
@_spi(LiveForm) import LiveViewNative

/// A live form defines a context in which that data from form controls is grouped together.
///
/// - Note: The `<LiveForm>` element must have an `id` attribute specified. Additionally, to participate in the form data model, form controls must provide a `name` attribute.
///
/// ## Events
/// - `phx-change`: fires whenever a value in the form changes
/// - `phx-submit`: fires when the form is submitted with the ``LiveSubmitButton``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct LiveForm<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    @LiveContext<R> private var context
    
    @EnvironmentObject private var liveViewModel: LiveViewModel
    
    private var formModel: FormModel {
        guard let id = element.attributeValue(for: "id") else {
            fatalError("<LiveForm> must have an id")
        }
        return liveViewModel.getForm(elementID: id)
    }
    
    public var body: some View {
        context.buildChildren(of: element)
            .environment(\.formModel, formModel)
            .onAppear {
                formModel.pushEventImpl = context.coordinator.pushEvent
                formModel.updateFromElement(element)
            }
            .onReceive($element) {
                formModel.updateFromElement(element)
            }
    }
}
