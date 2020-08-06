//
//  KSSSearchField.swift
//
//  Created by Steven W. Klassen on 2020-07-31.
//  Copyright © 2020 Klassen Software Solutions. All rights reserved.
//

import SwiftUI

/**
 Provides a SwiftUI view based on an NSSearchField.
 */
@available(OSX 10.15, *)
public struct KSSSearchField: NSViewRepresentable, KSSNSControlViewSettable {
    /// Settings applicable to all KSS `NSControl` based Views.
    public var nsControlViewSettings = KSSNSControlViewSettings()

    /// Type used for the search callback.
    public typealias Callback = (String?)->Void

    /// Help text to be displayed in the text field when it is empty. If empty, then no help text will be displayed.
    public let helpText: String

    /// A user defaults key used to store the recent searches. If empty, then recent searches will not be
    /// saved, and the recent searches menu item will not be created.
    public let recentSearchesKey: String

    /// The lambda that will be called when it is time to search. The callback takes an optional string
    /// which will be non-nil and non-empty when there is something to search for, and will be nil
    /// when the search is to be stopped.
    public let searchCallback: Callback?


    /**
     Create a search field. The field is essentially a text field where the user can type a search, an optional
     menu that provides a list of the most recent searches, and a cancel button that is used to stop the
     search.

     - parameters:
        - helpText: A short text that will be displayed in the search field when it is empty.
        - recentSearchesKey: A user defaults key for storing the recent searches.
        - searchCallback: A lambda that will be called when it is time to search.
     */
    public init(helpText: String = "",
                recentSearchesKey: String = "",
                _ searchCallback: Callback? = nil)
    {
        self.helpText = helpText
        self.recentSearchesKey = recentSearchesKey
        self.searchCallback = searchCallback
    }

    // MARK: NSViewRepresentable Items

    /// :nodoc:  Required part of the `NSViewRepresentable` protocol.
    public typealias NSViewType = NSSearchField

    /// :nodoc:  Required part of the `NSViewRepresentable` protocol.
    public func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    /// :nodoc:  Required part of the `NSViewRepresentable` protocol.
    public func makeNSView(context: Context) -> NSSearchField {
        let searchField = NSSearchField()
        searchField.sendsSearchStringImmediately = false
        if !helpText.isEmpty {
            searchField.placeholderString = helpText
        }
        if !recentSearchesKey.isEmpty {
            searchField.recentsAutosaveName = recentSearchesKey
            searchField.maximumRecents = 5
            searchField.addRecentsMenu()
        }
        searchField.delegate = context.coordinator
        _ = applyNSControlViewSettings(searchField, context: context)
        return searchField
    }

    /// :nodoc:  Required part of the `NSViewRepresentable` protocol.
    public func updateNSView(_ searchField: NSSearchField, context: Context) {
        DispatchQueue.main.async {
            _ = self.applyNSControlViewSettings(searchField, context: context)
        }
    }
}

fileprivate extension NSSearchField {
    func addRecentsMenu() {
        let cellMenu = NSMenu(title: "Search Menu")
        cellMenu.addItem(withTitle: "Recents", andTag: NSSearchField.recentsMenuItemTag)
        cellMenu.addItem(NSMenuItem.separator())
        cellMenu.addItem(withTitle: "Clear History", andTag: NSSearchField.clearRecentsMenuItemTag)
        self.searchMenuTemplate = cellMenu
    }
}

fileprivate extension NSMenu {
    func addItem(withTitle title: String, andTag tag: Int) {
        let item = NSMenuItem(title: title, action: nil, keyEquivalent: "")
        item.tag = tag
        self.addItem(item)
    }
}

/// :nodoc:  Required part of the `NSViewRepresentable` protocol.
@available(OSX 10.15, *)
extension KSSSearchField {
    public class Coordinator: NSObject, NSSearchFieldDelegate, NSTextFieldDelegate {
        let owner: KSSSearchField
        var isSearching = false

        init(_ owner: KSSSearchField) {
            self.owner = owner
        }

        public func searchFieldDidStartSearching(_ sender: NSSearchField) {
            isSearching = true
            performSearch(basedOn: sender)
        }
        
        public func searchFieldDidEndSearching(_ sender: NSSearchField) {
            isSearching = false
            owner.searchCallback?(nil)
        }

        public func controlTextDidChange(_ obj: Notification) {
            if isSearching {
                if let sender = obj.object as? NSSearchField {
                    performSearch(basedOn: sender)
                }
            }
        }

        private func performSearch(basedOn searchField: NSSearchField) {
            if let lambda = owner.searchCallback {
                let searchText = searchField.stringValue
                let haveSearchText = isSearching && !searchText.isEmpty
                lambda(haveSearchText ? searchText : nil)
            }
        }
    }
}
