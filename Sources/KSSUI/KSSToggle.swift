//
//  NativeButton.swift
//
//  Created by Steven W. Klassen on 2020-02-17.
//  Copyright © 2020 Klassen Software Solutions. All rights reserved.
//

import SwiftUI


/**
 SwiftUI wrapper around an NSButton configured to act as a toggle. This is intended to be used when
 the SwiftUI `Toggle` is not sufficient, for example, when you wish to use a multi-font strong or
 a tool tip.
 */
@available(OSX 10.15, *)
public struct KSSToggle: NSViewRepresentable, KSSNativeButtonCommonHelper {
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    /// Specifies a simple string as the content of the button.
    public private(set) var title: String? = nil

    /// Specifies an attributed string as the content of the button.
    public private(set) var attributedTitle: NSAttributedString? = nil

    /// Specifies an image as the content of the button. Note that the appearance of the image may be
    /// modified if `autoInvertImage` is specified.
    public private(set) var image: NSImage? = nil

    /// Binding to the item that will reflect the current state of the toggle.
    @Binding public var isOn: Bool

    /// Specifies an alternate image to be displayed when the button is activated. Note that the appearance
    /// of the image may be modified if `autoInvertImage` is specified.
    public private(set) var alternateImage: NSImage? = nil

    /// If set to true, and if `image` or `alternateImage` exist, they will have their colors automatically
    /// inverted when we are displaying in "dark mode". This is most useful if they are monochrome images.
    public private(set) var autoInvertImage: Bool = true

    /// Allows the border to be turned on/off.
    public private(set) var isBordered: Bool? = nil

    /// Allows a tool tip to be displayed if the cursor hovers over the control for a few moments.
    public private(set) var toolTip: String? = nil

    let buttonType: NSButton.ButtonType? = .pushOnPushOff
    let bezelStyle: NSButton.BezelStyle? = .regularSquare

    /**
     Construct a button with a simple string.
     */
    public init(_ title: String,
                isOn: Binding<Bool>,
                isBordered: Bool? = nil,
                toolTip: String? = nil)
    {
        self.title = title
        self._isOn = isOn
        self.isBordered = isBordered
        self.toolTip = toolTip
    }

    /**
     Construct a button with an attributed string.
     */
    public init(withAttributedTitle attributedTitle: NSAttributedString,
                isOn: Binding<Bool>,
                isBordered: Bool? = nil,
                toolTip: String? = nil)
    {
        self.attributedTitle = attributedTitle
        self._isOn = isOn
        self.isBordered = isBordered
        self.toolTip = toolTip
    }

    /**
     Construct a button with an image.
     */
    public init(withImage image: NSImage,
                isOn: Binding<Bool>,
                alternateImage: NSImage? = nil,
                autoInvertImage: Bool = true,
                isBordered: Bool? = nil,
                toolTip: String? = nil)
    {
        self.image = image
        self.alternateImage = alternateImage
        self.autoInvertImage = autoInvertImage
        self._isOn = isOn
        self.isBordered = isBordered
        self.toolTip = toolTip
    }

    /// :nodoc:
    public func makeNSView(context: NSViewRepresentableContext<Self>) -> NSButton {
        let button = commonMakeButton()
        button.onAction { _ in self.isOn = !self.isOn }
        return button
    }

    /// :nodoc:
    public func updateNSView(_ nsView: NSButton, context: NSViewRepresentableContext<Self>) {
        commonUpdateButton(nsView)
        nsView.state = isOn ? .on : .off
        if nsView.alternateImage == nil {
            nsView.alphaValue = isOn ? 1.0 : 0.8
        }
    }
}
