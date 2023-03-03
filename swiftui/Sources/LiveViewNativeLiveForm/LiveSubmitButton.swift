//
//  LiveSubmitButton.swift
//  LiveViewNativeLiveForm
//
//  Created by Shadowfacts on 2/27/23.
//

import SwiftUI
@_spi(LiveForm) import LiveViewNative

struct LiveSubmitButton<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    private let context: LiveContext<R>
    @Environment(\.formModel) private var formModel
    
    init(context: LiveContext<R>) {
        self.context = context
    }
    
    public var body: some View {
        LiveViewNative.Button(element: element, context: context, action: submitForm)
    }
    
    private func submitForm() {
        guard let formModel else { return }
        Task {
            do {
                try await formModel.sendSubmitEvent()
                doAfterSubmitAction()
            } catch {
                // todo: error handling
            }
        }
    }
    
    private func doAfterSubmitAction() {
        switch element.attributeValue(for: "after-submit") {
        case "clear":
            formModel?.clear()
        default:
            return
        }
    }
}
