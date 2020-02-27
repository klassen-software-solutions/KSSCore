//
//  KSSCommandTextField.swift
//
//  Created by Steven W. Klassen on 2020-01-24.
//  Copyright © 2020 Klassen Software Solutions. All rights reserved.
//

import SwiftUI

/**
 TextField control suitable for entering command line type items.

 This control provides a SwiftUI View that can be used for command-like entries. It is implemented as a
 SwiftUI wrapper around a NSTextField control and allows for the following features.

 - Single line text entry,
 - Command line submission on pressing the `Return` or `Enter` keys,
 - Command line history accessed via the up and down arrow keys,
 - Optional validation of the input before submission,
 - Automatic highlighting of errors.
 */
@available(OSX 10.15, *)
public struct KSSCommandTextField: NSViewRepresentable {
    /**
     Binding to the text of the current command. This will be updated when the user presses the `Return`
     or `Enter` keys.
     */
    @Binding public var command: String

    /**
     Help text to be displayed in the text field when it is empty.
     */
    public let helpText: String

    /**
     Function used to validate the text. Typically this would be set by the `validator` modifier.
     */
    public var validatorFn: ((String) -> Bool)? = nil

    /**
     Color used to highlight the field when it fails validation. Typically this would be set by the
     `errorHighlight` modifier.
     */
    public var errorHighlightColor: NSColor = KSSCommandTextField.defaultErrorHighlightColor

    /**
     Construct a new text field with the given binding and help text.
     */
    public init(command: Binding<String>, helpText: String = "command") {
        self._command = command
        self.helpText = helpText
    }

    /**
     Returns a modified View with the validation function set.
     */
    public func validator(perform: @escaping (String) -> Bool) -> KSSCommandTextField {
        var newView = self
        newView.validatorFn = perform
        return newView
    }

    /**
     Returns a modified View with the color used for the error highlights set.
     */
    public func errorHighlight(_ color: NSColor? = nil) -> KSSCommandTextField {
        var newView = self
        newView.errorHighlightColor = color ?? KSSCommandTextField.defaultErrorHighlightColor
        return newView
    }


    @State private var hasFocus = false
    @State private var history = CommandHistory()

    static let defaultErrorHighlightColor = NSColor.systemYellow.withAlphaComponent(0.50)

    /// :nodoc:
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    /// :nodoc:
    public func makeNSView(context: Context) -> NSTextField {
        let textField = NSTextField()
        textField.placeholderString = helpText
        textField.delegate = context.coordinator
        textField.stringValue = command
        return textField
    }

    /// :nodoc:
    public func updateNSView(_ nsView: NSTextField, context: Context) {
        // Intentionally left empty
    }

    // I don't like this. I would prefer having an "errorState" variable like I do with
    // the URLTextField class, and have updateNSView change the background color. However,
    // I cannot for the life of me get the NSTextField to redraw itself at the correct
    // time. If I could figure out how to get a SwiftUI TextField to respond to the
    // keypresses that I need, then I would drop NSTextField altogether. But I've spent
    // almost a week now trying to figure that out without success.
    private func ensureBackgroundColorIs(_ color: NSColor?, for control: NSControl) {
        if let textField = control as? NSTextField {
            textField.backgroundColor = color
        }
    }

    /// :nodoc:
    public class Coordinator: NSObject, NSTextFieldDelegate {
        let parent: KSSCommandTextField

        init(_ parent: KSSCommandTextField) {
            self.parent = parent
        }

        public func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
            if commandSelector == #selector(NSTextView.insertNewline(_:)) {
                submitCommand(control, textView: textView)
            }
            else if commandSelector == #selector(NSTextView.moveUp(_:)) {
                previousInHistory(textView: textView)
            }
            else if commandSelector == #selector(NSTextView.moveDown(_:)) {
                nextInHistory(textView: textView)
            }

            return false
        }

        private func submitCommand(_ control: NSControl, textView: NSTextView) {
            let value = textView.string
            if let fn = parent.validatorFn {
                if !fn(value) {
                    parent.ensureBackgroundColorIs(parent.errorHighlightColor, for: control)
                    return
                }
            }
            parent.ensureBackgroundColorIs(nil, for: control)
            parent.command = value
            parent.history.addCommand(value)
        }

        private func previousInHistory(textView: NSTextView) {
            if let prev = parent.history.previous() {
                textView.string = prev
            }
        }

        private func nextInHistory(textView: NSTextView) {
            if let next = parent.history.next() {
                textView.string = next
            }
        }
    }
}


private final class CommandHistory {
    let maximumHistoryLength: Int
    private var commands: [String] = []
    private var currentCommandPosition = -1

    init(maximumHistoryLength: Int = 1000) {
        precondition(maximumHistoryLength > 1, "A history must allow more than 1 item.")
        self.maximumHistoryLength = maximumHistoryLength
    }

    func addCommand(_ command: String) {
        precondition(isConsistent(), inconsistentStateMessage())
        let last = commands.last
        if !command.isEmpty && command != last {
            commands.append(command)
            while commands.count > maximumHistoryLength {
                _ = commands.remove(at: 0)
            }
            currentCommandPosition = commands.count - 1
        }
    }

    func next() -> String? {
        precondition(isConsistent(), inconsistentStateMessage())
        guard currentCommandPosition < commands.count - 1 else {
            return nil
        }
        currentCommandPosition += 1
        return commands[currentCommandPosition]
    }

    func previous() -> String? {
        precondition(isConsistent(), inconsistentStateMessage())
        guard currentCommandPosition > 0 else {
            return nil
        }
        currentCommandPosition -= 1
        return commands[currentCommandPosition]
    }

    private func isConsistent() -> Bool {
        if commands.count > maximumHistoryLength {
            return false
        }
        if commands.isEmpty {
            return currentCommandPosition == -1
        }
        return currentCommandPosition >= 0 && currentCommandPosition < commands.count
    }

    private func inconsistentStateMessage() -> String {
        return "inconsistent state: "
            + "maximumHistoryLength: \(maximumHistoryLength)"
            + ", currentCommandPosition: \(currentCommandPosition)"
            + ", commands: \(commands)"
    }
}
