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
@LiveElement
struct LiveForm<Root: RootRegistry>: View {
    @LiveElementIgnored
    @EnvironmentObject private var liveViewModel: LiveViewModel
    
    @LiveAttribute("phx-trigger-action") private var triggerAction: Bool = false
    private var action: String?
    private var method: String = "POST"
    
    private var id: String?
    
    private var formModel: FormModel {
        guard let id else {
            fatalError("<LiveForm> must have an id")
        }
        return liveViewModel.getForm(elementID: id)
    }
    
    public var body: some View {
        $liveElement.children()
            .environment(\.formModel, formModel)
            .task {
                formModel.pushEventImpl = $liveElement.context.coordinator.pushEvent
                formModel.updateFromElement($liveElement.element, submitAction: submitForm)
                updateHiddenFields()
            }
            .onReceive($liveElement.$element) { _ in
                formModel.updateFromElement($liveElement.element, submitAction: submitForm)
                updateHiddenFields()
            }
            .onChange(of: triggerAction) {
                guard $0 else { return }
                submitForm()
            }
    }
    
    private func submitForm() {
        guard let action,
              let url = URL(string: action, relativeTo: $liveElement.context.url),
              let body = try? formModel.buildFormQuery()
        else { return }
        Task {
            await $liveElement.context.coordinator.session.reconnect(
                url: url,
                httpMethod: method,
                httpBody: body.data(using: .utf8)
            )
        }
    }
    
    /// Collects all ``LiveHiddenField`` elements, and sets their values into the form model.
    private func updateHiddenFields() {
        for child in $liveElement.element.depthFirstChildren() {
            guard case let .nodeElement(element) = child.data(),
                  element.name.name == "LiveHiddenField",
                  let name = element.attributes.first(where: { $0.name == "name" })?.value,
                  let value = element.attributes.first(where: { $0.name == "value" })?.value
            else { continue }
            self.formModel.setValue(value, forName: name, changeEvent: nil)
        }
    }
}
