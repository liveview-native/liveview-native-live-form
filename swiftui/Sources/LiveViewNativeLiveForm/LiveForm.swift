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
    
    @Attribute("phx-trigger-action") private var triggerAction: Bool
    @Attribute("action") private var action: String
    @Attribute("method") private var method: String
    
    private var formModel: FormModel {
        guard let id = element.attributeValue(for: "id") else {
            fatalError("<LiveForm> must have an id")
        }
        return liveViewModel.getForm(elementID: id)
    }
    
    public var body: some View {
        context.buildChildren(of: element)
            .environment(\.formModel, formModel)
            .task {
                formModel.pushEventImpl = context.coordinator.pushEvent
                formModel.updateFromElement(element, submitAction: submitForm)
            }
            .onReceive($element) {
                formModel.updateFromElement(element, submitAction: submitForm)
            }
            .onChange(of: element.attributeBoolean(for: "phx-trigger-action")) {
                guard $0 else { return }
                submitForm()
            }
    }
    
    private func submitForm() {
        guard let url = URL(string: action, relativeTo: context.url),
              let body = try? formModel.buildFormQuery()
        else { return }
        Task {
            await context.coordinator.session.reconnect(
                url: url,
                httpMethod: method,
                httpBody: body.data(using: .utf8)
            )
        }
    }
}
