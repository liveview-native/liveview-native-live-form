//
//  LiveForm.swift
//  LiveViewNativeLiveForm
//
//  Created by Shadowfacts on 2/27/23.
//

import SwiftUI
@_spi(LiveForm) import LiveViewNative

struct LiveForm<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    private let context: LiveContext<R>
    
    @EnvironmentObject private var liveViewModel: LiveViewModel
    
    private var formModel: FormModel {
        guard let id = element.attributeValue(for: "id") else {
            fatalError("<live-form> must have an id")
        }
        return liveViewModel.getForm(elementID: id)
    }
    
    init(context: LiveContext<R>) {
        self.context = context
    }
    
    public var body: some View {
        context.with(formModel: formModel).buildChildren(of: element)
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
