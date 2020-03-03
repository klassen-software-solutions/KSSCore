//
//  NativeButton.swift
//
//  Created by Steven W. Klassen on 2020-02-17.
//  Copyright © 2020 Klassen Software Solutions. All rights reserved.
//

import SwiftUI


/**
 SwiftUI wrapper around an NSButton. This is intended to be used when a SwiftUI Button is not sufficient.
 For example, when you wish to use a multi-font string, or alllow a default action.

 - note: This is based on example code found at
    https://stackoverflow.com/questions/57283931/swiftui-on-mac-how-do-i-designate-a-button-as-being-the-primary
 */
@available(OSX 10.15, *)
public struct KSSNativeButton: NSViewRepresentable {
    /**
     Used to specify a keyboard equivalent to the button action. This can either refer to the return key or
     the escape key.
     */
    public enum KeyEquivalent: String {
        /// Represents the escape key.
        case escape = "\u{1b}"

        /// Represents the return key.
        case `return` = "\r"
    }

    private var title: String?
    private var attributedTitle: NSAttributedString?
    private var keyEquivalent: KeyEquivalent?
    private let action: () -> Void

    /**
     Construct a button with a simple string.

     - parameters:
        - title: The label to be displayed.
        - keyEquivalent: Specifies if this should be the default action of either the escape or return key.
        - action: The action to perform when the button is pressed.
     */
    public init(_ title: String,
                keyEquivalent: KeyEquivalent? = nil,
                action: @escaping () -> Void)
    {
        self.title = title
        self.attributedTitle = nil
        self.keyEquivalent = keyEquivalent
        self.action = action
    }

    /**
     Construct a button with an attributed string.

     - parameters:
     - attributedTitle: The label to be displayed.
     - keyEquivalent: Specifies if this should be the default action of either the escape or return key.
     - action: The action to perform when the button is pressed.
     */
    public init(attributedTitle: NSAttributedString,
                keyEquivalent: KeyEquivalent? = nil,
                action: @escaping () -> Void)
    {
        self.title = nil
        self.attributedTitle = attributedTitle
        self.keyEquivalent = keyEquivalent
        self.action = action
    }

    /// :nodoc:
    public func makeNSView(context: NSViewRepresentableContext<Self>) -> NSButton {
        let button = NSButton(title: "", target: nil, action: nil)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setContentHuggingPriority(.defaultHigh, for: .vertical)
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return button
    }

    /// :nodoc:
    public func updateNSView(_ nsView: NSButton, context: NSViewRepresentableContext<Self>) {
        if attributedTitle == nil {
            nsView.title = title ?? ""
        }

        if title == nil {
            nsView.attributedTitle = attributedTitle ?? NSAttributedString(string: "")
        }

        nsView.keyEquivalent = keyEquivalent?.rawValue ?? ""

        nsView.onAction { _ in
            self.action()
        }
    }
}


private var controlActionClosureProtocolAssociatedObjectKey: UInt8 = 0

fileprivate protocol ControlActionClosureProtocol: NSObjectProtocol {
    var target: AnyObject? { get set }
    var action: Selector? { get set }
}

private final class ActionTrampoline<T>: NSObject {
    let action: (T) -> Void

    init(action: @escaping (T) -> Void) {
        self.action = action
    }

    @objc
    func action(sender: AnyObject) {
        action(sender as! T)
    }
}

fileprivate extension ControlActionClosureProtocol {
    func onAction(_ action: @escaping (Self) -> Void) {
        let trampoline = ActionTrampoline(action: action)
        self.target = trampoline
        self.action = #selector(ActionTrampoline<Self>.action(sender:))
        objc_setAssociatedObject(self, &controlActionClosureProtocolAssociatedObjectKey, trampoline, .OBJC_ASSOCIATION_RETAIN)
    }
}

extension NSControl: ControlActionClosureProtocol {}
