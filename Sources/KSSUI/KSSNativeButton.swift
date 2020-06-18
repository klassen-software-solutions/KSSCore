//
//  NativeButton.swift
//
//  Created by Steven W. Klassen on 2020-02-17.
//  Copyright © 2020 Klassen Software Solutions. All rights reserved.
//

import SwiftUI
import KSSCocoa


/**
 SwiftUI wrapper around an NSButton. This is intended to be used when a SwiftUI Button is not sufficient.
 For example, when you wish to use a multi-font string, or alllow a default action.

 This wrapper allows many of the configuration items available for NSButton to be used.

 - note: This is based on example code found at
    https://stackoverflow.com/questions/57283931/swiftui-on-mac-how-do-i-designate-a-button-as-being-the-primary
 */
@available(OSX 10.15, *)
public struct KSSNativeButton: NSViewRepresentable, KSSNativeButtonCommonHelper {

    @Environment(\.colorScheme) var colorScheme: ColorScheme

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

    /// Specifies a simple string as the content of the button.
    public private(set) var title: String? = nil

    /// Specifies an attributed string as the content of the button.
    public private(set) var attributedTitle: NSAttributedString? = nil

    /// Specifies an image as the content of the button. Note that the appearance of the image may be
    /// modified if `autoInvertImage` is specified.
    public private(set) var image: NSImage? = nil

    /// Specifies a keyboard equivalent to pressing the button.
    public private(set) var keyEquivalent: KeyEquivalent? = nil

    /// Specifies the type of the button.
    public private(set) var buttonType: NSButton.ButtonType? = nil

    /// Specifies an alternate image to be displayed when the button is activated. Note that the appearance
    /// of the image may be modified if `autoInvertImage` is specified.
    public private(set) var alternateImage: NSImage? = nil

    /// Specifies type type of border.
    public private(set) var bezelStyle: NSButton.BezelStyle? = nil

    /// Allows the border to be turned on/off.
    public private(set) var isBordered: Bool? = nil

    /// If set to true, and if `image` or `alternateImage` exist, they will have their colors automatically
    /// inverted when we are displaying in "dark mode". This is most useful if they are monochrome images.
    public private(set) var autoInvertImage: Bool = true

    /// Allows a tool tip to be displayed if the cursor hovers over the control for a few moments.
    public private(set) var toolTip: String? = nil

    private let action: () -> Void

    /**
     Construct a button with a simple string.
     */
    public init(_ title: String,
                keyEquivalent: KeyEquivalent? = nil,
                buttonType: NSButton.ButtonType? = nil,
                bezelStyle: NSButton.BezelStyle? = nil,
                isBordered: Bool? = nil,
                toolTip: String? = nil,
                action: @escaping () -> Void)
    {
        self.title = title
        self.keyEquivalent = keyEquivalent
        self.buttonType = buttonType
        self.bezelStyle = bezelStyle
        self.isBordered = isBordered
        self.toolTip = toolTip
        self.action = action
    }

    /**
     Construct a button with an attributed string.
     */
    public init(withAttributedTitle attributedTitle: NSAttributedString,
                keyEquivalent: KeyEquivalent? = nil,
                buttonType: NSButton.ButtonType? = nil,
                bezelStyle: NSButton.BezelStyle? = nil,
                isBordered: Bool? = nil,
                toolTip: String? = nil,
                action: @escaping () -> Void)
    {
        self.attributedTitle = attributedTitle
        self.keyEquivalent = keyEquivalent
        self.buttonType = buttonType
        self.bezelStyle = bezelStyle
        self.isBordered = isBordered
        self.toolTip = toolTip
        self.action = action
    }

    /**
     Construct a button with an image.
     */
    public init(withImage image: NSImage,
                alternateImage: NSImage? = nil,
                autoInvertImage: Bool = true,
                keyEquivalent: KeyEquivalent? = nil,
                buttonType: NSButton.ButtonType? = nil,
                bezelStyle: NSButton.BezelStyle? = nil,
                isBordered: Bool? = nil,
                toolTip: String? = nil,
                action: @escaping () -> Void)
    {
        self.image = image
        self.alternateImage = alternateImage
        self.autoInvertImage = autoInvertImage
        self.keyEquivalent = keyEquivalent
        self.buttonType = buttonType
        self.bezelStyle = bezelStyle
        self.isBordered = isBordered
        self.toolTip = toolTip
        self.action = action
    }

    /// :nodoc:
    public func makeNSView(context: NSViewRepresentableContext<Self>) -> NSButton {
        let button = commonMakeButton()
        button.onAction { _ in self.action() }
        if let keyEquivalent = keyEquivalent {
            button.keyEquivalent = keyEquivalent.rawValue
        }
        return button
    }

    /// :nodoc:
    public func updateNSView(_ button: NSButton, context: NSViewRepresentableContext<Self>) {
        commonUpdateButton(button)
    }
}

// The following are helper items used to reduce the amount of repeated code between
// the various KSS "native" buttons.
@available(OSX 10.15, *)
protocol KSSNativeButtonCommonHelper {
    var title: String? { get }
    var attributedTitle: NSAttributedString? { get }
    var image: NSImage? { get }

    var buttonType: NSButton.ButtonType? { get }
    var alternateImage: NSImage? { get }
    var bezelStyle: NSButton.BezelStyle? { get }
    var isBordered: Bool? { get }
    var autoInvertImage: Bool { get }
    var toolTip: String? { get }
    var colorScheme: ColorScheme { get }
}

/// :nodoc:
@available(OSX 10.15, *)
extension KSSNativeButtonCommonHelper {
    func commonMakeButton() -> NSButton {
        let button = NSButton(title: "", target: nil, action: nil)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setContentHuggingPriority(.defaultHigh, for: .vertical)
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        if let attributedTitle = attributedTitle {
            button.attributedTitle = attributedTitle
        } else if let title = title {
            button.title = title
        } else if image != nil {
            // Intentionally empty. Since the choise of image is dependant on the
            // colorScheme, which may change, we delay the setting of the image
            // until the commonUpdateButton call.
        } else {
            fatalError("One of 'title', 'attributedTitle' or 'image' is required")
        }

        if let buttonType = buttonType {
            button.setButtonType(buttonType)
        }

        if let bezelStyle = bezelStyle {
            button.bezelStyle = bezelStyle
        }

        if let isBordered = isBordered {
            button.isBordered = isBordered
        }

        if let toolTip = toolTip {
            button.toolTip = toolTip
        }

        return button
    }

    func commonUpdateButton(_ button: NSButton) {
        let shouldInvert = autoInvertImage && (colorScheme == .dark)
        if let image = image {
            button.image = shouldInvert ? image.inverted() : image
        }
        if let alternateImage = alternateImage {
            button.alternateImage = shouldInvert ? alternateImage.inverted() : alternateImage
        }
    }
}

// The following is the "glue" needed to allow the button action to be set (since
// the NSButton selector needs to be an Objective-C object).
fileprivate var controlActionClosureProtocolAssociatedObjectKey: UInt8 = 0

fileprivate final class ActionTrampoline<T>: NSObject {
    public let action: (T) -> Void

    public init(action: @escaping (T) -> Void) {
        self.action = action
    }

    @objc
    public func action(sender: AnyObject) {
        action(sender as! T)
    }
}

/// :nodoc:
protocol KSSNativeButtonControlActionClosureProtocol: NSObjectProtocol {
    var target: AnyObject? { get set }
    var action: Selector? { get set }
}

/// :nodoc:
extension KSSNativeButtonControlActionClosureProtocol {
    func onAction(_ action: @escaping (Self) -> Void) {
        let trampoline = ActionTrampoline(action: action)
        self.target = trampoline
        self.action = #selector(ActionTrampoline<Self>.action(sender:))
        objc_setAssociatedObject(self, &controlActionClosureProtocolAssociatedObjectKey, trampoline, .OBJC_ASSOCIATION_RETAIN)
    }
}

/// :nodoc:
extension NSControl: KSSNativeButtonControlActionClosureProtocol {}
