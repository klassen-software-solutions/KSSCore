//
//  KSSURLTextField.swift
//
//  Created by Steven W. Klassen on 2020-01-16.
//  Copyright © 2020 Klassen Software Solutions. All rights reserved.
//

import Combine
import SwiftUI

/**
 Provides a text field used to enter a URL.
 */
@available(OSX 10.15, *)
public struct KSSURLTextField: View {
    /**
     A binding to the URL to be updated. Note that setting this only sets the initial value of the field when it
     is created. To change the URL from an outside source you must provide it with a publisher using the
     `urlPublisher` modifier.
     */
    @Binding public var url: URL?

    /**
     The help text to be displayed in the field when it is empty.
     */
    public var helpText: String = "url"

    /**
     The current validator function. This can be used to validate the URL befgore allowing it to be accepted. For
     example, if you want to limit the acceptable URL to `http:` and `https:`, this is the way to do that.
     Typically this would be set using the `validator` modifier.
     */
    public var validatorFn: ((URL) -> Bool)? = nil

    /**
     The current highlight color used to identify the field when the validation fails. Typically this would be set using
     the `errorHighlight` modifier.
     */
    public var errorHighlightColor: Color = Color(KSSCommandTextField.defaultErrorHighlightColor)

    static private var nilUrlPublisher = PassthroughSubject<URL?, Never>().eraseToAnyPublisher()
    private var _urlPublisher: AnyPublisher<URL?, Never> = KSSURLTextField.nilUrlPublisher

    @State private var errorState: Bool = false
    @State private var text: String = ""

    /// :nodoc:
    public var body: some View {
        TextField(helpText, text: $text, onCommit: { self.updateUrl() })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .background(errorState ? self.errorHighlightColor : nil)
            .onAppear { self.text = self.url?.absoluteString ?? "" }
            .onReceive(_urlPublisher, perform: { url in
                self.text = url?.absoluteString ?? ""
                self.updateUrl()
            })
    }

    /**
     This modifier returns a View that includes the given validator function.
     */
    public func validator(perform: @escaping (URL) -> Bool) -> Self {
        var newView = self
        newView.validatorFn = perform
        return newView
    }

    /**
     This modifier returns a View that sets the error highlight color.
     */
    public func errorHighlight(_ color: Color? = nil) -> Self {
        var newView = self
        newView.errorHighlightColor = color ?? Color(KSSCommandTextField.defaultErrorHighlightColor)
        return newView
    }

    /**
     This modifier returns a view that will listen to the given publisher for URL changes. When the publisher
     sends a message, that url will be set into the field. The main use case for this is to allow a recent history
     menu to populate the control, and is necessary since setting the url binding does not actually set the
     url into the underlying control. Hence another means had to be provided.
     */
    public func urlPublisher(_ publisher: AnyPublisher<URL?, Never>) -> Self {
        var newView = self
        newView._urlPublisher = publisher
        return newView
    }

    private func validatedURL() -> URL? {
        if let u = URL(string: text) {
            if let fn = validatorFn {
                if fn(u) {
                    return u
                }
            } else {
                return u
            }
        }
        return nil
    }

    private func updateUrl() {
        if let u = validatedURL() {
            url = u
            errorState = false
        } else if text.isEmpty {
            url = nil
            errorState = false
        } else {
            errorState = true
        }
    }
}
