//
//  FileSystemWatcher.swift
//  
//
//  Created by Steven W. Klassen on 2020-09-09.
//

#if os(macOS) || os(iOS)

import os
import Foundation

/**
 This is a wrapper around the File System Events portion of the Core Services. It allows you to easily
 watch for changes in the file system.

 - note: This class is not available in Linux
 */
public class FileSystemWatcher {

    /**
     This is a wrapper around the `FSEventStreamCreateFlags` values that are passed in via the `watch`
     method.
     */
    public struct Flags: OptionSet {
        /// The underlying value of the flag.
        public let rawValue: FSEventStreamCreateFlags

        /// Create a flag from an underlying value.
        public init(rawValue: FSEventStreamCreateFlags) {
            self.rawValue = rawValue
        }

        /// Use the defaults with no extra flags.
        public static let none = Flags(kFSEventStreamCreateFlagNone)

        /// Do not defer the event if the latency period has already passed.
        public static let noDefer = Flags(kFSEventStreamCreateFlagNoDefer)

        /// Ignore changes that have been made by this process.
        public static let ignoreSelf = Flags(kFSEventStreamCreateFlagIgnoreSelf)

        /// Enable root related events. This will enable the event flags described under "Root Events".
        public static let watchRoot = Flags(kFSEventStreamCreateFlagWatchRoot)

        /// Enable file related events. This will enable the event flags described under "File Events" and "File Type Flags"
        public static let fileEvents = Flags(kFSEventStreamCreateFlagFileEvents)
    }

    /**
     Specifies a single file event.
     */
    public struct Event {
        /**
         Specifies the type of the event.
         */
        public enum EventType: Equatable {
            /// A fake event that indicates the need to rescan the event directory and its subdirectories.
            /// `userDropped` and/or `kernelDropped` will be specified and may be used to help
            /// determine the cause of the problem.
            case mustRescan(userDropped: Bool, kernelDropped: Bool)

            /// A change was made in one of the directories leading to the path we are watching. This
            /// event type will only be seen if `Flags.watchRoot` was specified.
            case rootChanged

            /// A volume was mounted.
            case mounted

            /// A volume was unmounted.
            case unmounted

            /// An item was created.
            /// This event type will only be seen if `Flags.fileEvents` was specified.
            case created

            /// An item was removed.
            /// This event type will only be seen if `Flags.fileEvents` was specified.
            case removed

            /// An item was renamed.
            /// This event type will only be seen if `Flags.fileEvents` was specified.
            case renamed

            /// An item was modified.
            /// This event type will only be seen if `Flags.fileEvents` was specified.
            case modified

            /// An item's metadata was modified.
            /// This event type will only be seen if `Flags.fileEvents` was specified.
            case metadataModified(inode: Bool, finder: Bool, xAttributes: Bool)

            /// An item was cloned.
            /// This event type will only be seen if `Flags.fileEvents` was specified.
            @available(OSX 10.13, *)
            case cloned

            /// An item's ownership was changed.
            /// This event type will only be seen if `Flags.fileEvents` was specified.
            case ownerChanged
        }

        /**
         Specifies the type of the item represented by the url.
         */
        public enum ItemType: Equatable {
            /// The item is a file.
            case file

            /// The item is a directory.
            case directory

            /// The item is a symbolic link.
            case symbolicLink

            /// The item is a hard link.
            case hardLink(isLastHardLink: Bool)
        }

        /// The url of the item involved.
        public let url: URL

        /// The raw flags for the event.
        public var rawFlags: FSEventStreamEventFlags { flags.rawValue }

        /// The types of the event. Note that there can be more than one. For example, temporary files may
        /// return created, modified, and removed all in one event.
        public var eventTypes: [EventType] { flags.eventTypes() }

        /// The types of the item. Note that an item can be more than one type, for example,
        /// `.file` and `.hardLink`.
        public var itemTypes: [ItemType] { flags.itemTypes() }

        /// True if the event was produced by the current process.
        public var isOurOwnEvent: Bool { flags.contains(.ownEvent) }

        private let flags: FileEventFlags

        fileprivate init(_ path: String, rawFlags: FSEventStreamEventFlags) {
            self.url = URL(string: "file:/\(path)")!
            self.flags = FileEventFlags(rawValue: rawFlags)
        }
    }

    /**
     Errors generated by a `FileSystemWatcher`.
     */
    public enum Error: Swift.Error, LocalizedError, Equatable {
        /// Thrown if we try to watch a url that is not a file url.
        case notAFile(url: URL)

        /// Thrown if watch is passed flags that are not supported. A flags item containing only
        /// the bad flags is returned in badFlags.
        case unsupportedFlags(badFlags: Flags)

        /// Thrown if we could not create the underlying file system event stream. If this occurs
        /// (which it should not), the only recourse is one of the following:
        /// * perform your file watching manually (i.e. polling),
        /// * go without your file watching if it is not critical to your situation, or
        /// * halt the program with a fatal error.
        case couldNotCreateEventStream

        /// Thrown if we could not start the underlying file system event stream. If this occurs
        /// (which it should not), the only recourse is one of the following:
        /// * perform your file watching manually (i.e. polling),
        /// * go without your file watching if it is not critical to your situation, or
        /// * halt the program with a fatal error.
        case couldNotStartEventStream

        /// -:nodoc:-
        public var errorDescription: String? { "\(String(describing: type(of: self))).\(self): \(desc)" }
    }

    /**
     Refers to the event handler function.

     - note: The os will give us multiple events at once, depending on the `latency` setting and
     how quickly events are being produced. However, this API presents them one at a time. If you want to
     stop processing events in the current underlying batch (say because all you are doing is refreshing
     something regardless of how many events there are), then you should return false from this method.
     */
    public typealias EventHandlerFn = (_ events: [Event]) -> Void

    /// -:nodoc:-
    public init() {}

    /**
     Setup a new watcher for a single url. This will return an id that may be used when you want to
     stop watching.
     - note: All watchers will be automatically stopped when `FileSystemWatcher` goes out
     of scope.
     */
    public func watch(_ url: URL,
                      flags: Flags = .none,
                      latency: TimeInterval = 1.0,
                      handler: @escaping EventHandlerFn) throws -> UUID
    {
        return try watch([url], flags: flags, latency: latency, handler: handler)
    }

    /**
     Setup a new watcher for multiple urls. This will return an id that may be used when you want to
     stop watching.
     - note: All watchers will be automatically stopped when `FileSystemWatcher` goes out
     of scope.
     */
    public func watch(_ urls: [URL],
                      flags: Flags = .none,
                      latency: TimeInterval = 1.0,
                      handler: @escaping EventHandlerFn) throws -> UUID
    {
        if let badUrl = unsupportedURL(urls) {
            throw Error.notAFile(url: badUrl)
        }
        if let badFlags = unsupportedFlags(flags) {
            throw Error.unsupportedFlags(badFlags: badFlags)
        }

        // Create the watching stream.
        let eventStream = try EventStream(urls, flags, latency, handler)
        streams[eventStream.id] = eventStream

        os_log("FileSystemWatcher: started watching as %s", eventStream.id.description)
        for url in urls {
            os_log("FileSystemWatcher: ...%s", url.absoluteString)
        }

        return eventStream.id
    }

    /**
     Stop watching the given watcher.
     - note: If passed a uuid that is not for a currently running watcher, the method will do nothing
     except log a warning message.
     */
    public func stopWatching(_ id: UUID) {
        if let eventStream = streams.removeValue(forKey: id) {
            os_log("FileSystemWatcher: stopped watching %s", eventStream.id.description)
        }
    }

    // MARK: Internal Representation

    var streams = [UUID: EventStream]()

    func flushAll() {
        for stream in streams.values {
            FSEventStreamFlushSync(stream.fsStreamRef)
        }
    }
}


// MARK: Internal Implementations

fileprivate extension FileSystemWatcher.Flags {
    init(_ value: Int) {
        self.init(rawValue: FSEventStreamEventFlags(value))
    }

    static let allValidFlags: Self = [.none, .noDefer, .ignoreSelf, .watchRoot, .fileEvents]
    static let useCFTypes = Self(kFSEventStreamCreateFlagUseCFTypes)
    static let markSelf = Self(kFSEventStreamCreateFlagMarkSelf)
    static let eventStreamAdditionalFlags: Self = [.useCFTypes, .markSelf]
}

extension FileSystemWatcher.Event: CustomDebugStringConvertible {
    public var debugDescription: String {
        return """
            Event(rawFlags: \(self.rawFlags) [\(self.flags)])
                  url: \(self.url)
                  eventTypes: \(self.eventTypes)
                  itemTypes: \(self.itemTypes)
                  isOurOwnEvent: \(self.isOurOwnEvent)
            """
    }
}

extension FileSystemWatcher.Event.EventType: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .mustRescan(let userDropped, let kernelDropped):
            return ".mustRescan(userDropped: \(userDropped), kernelDropped: \(kernelDropped))"
        case .rootChanged:
            return ".rootChanged"
        case .mounted:
            return ".mounted"
        case .unmounted:
            return ".unmounted"
        case .created:
            return ".created"
        case .removed:
            return ".removed"
        case .renamed:
            return ".renamed"
        case .modified:
            return ".modified"
        case .metadataModified(let inode, let finder, let xAttributes):
            return ".metadataModified(inode: \(inode), finder: \(finder), xAttributes: \(xAttributes))"
        case .cloned:
            return ".cloned"
        case .ownerChanged:
            return ".ownerChanged"
        }
    }
}

extension FileSystemWatcher.Event.ItemType: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .file:
            return ".file"
        case .directory:
            return ".directory"
        case .symbolicLink:
            return ".symbolicLink"
        case .hardLink(let isLastHardLink):
            return ".hardLink(isLastHardLink: \(isLastHardLink))"
        }
    }
}

fileprivate extension FileSystemWatcher.Error {
    private var desc: String {
        switch self {
        case .notAFile(let url):
            return "'\(url.absoluteString)' is not a file URL"
        case .unsupportedFlags(let badFlags):
            return "Unsupported flags, rawValue: \(badFlags.rawValue)"
        case .couldNotStartEventStream:
            return "Could not start the FSEventStream"
        case .couldNotCreateEventStream:
            return "Could not create the FSEventStream"
        }
    }
}

fileprivate extension FileSystemWatcher {
    func unsupportedURL(_ urls: [URL]) -> URL? {
        for url in urls {
            if url.scheme != "file" {
                return url
            }
        }
        return nil
    }

    func unsupportedFlags(_ flags: Flags) -> Flags? {
        let badFlags = flags.subtracting(.allValidFlags)
        guard badFlags.isEmpty else {
            return badFlags
        }
        return nil
    }
}


// This is the core of the file system events wrapper. It is heavily influenced by
// the class of the same name in https://github.com/njdehoog/Witness
class EventStream {
    let id = UUID()
    let paths: [String]
    let handler: FileSystemWatcher.EventHandlerFn
    var fsStreamRef: FSEventStreamRef! = nil

    init(_ urls: [URL],
         _ flags: FileSystemWatcher.Flags,
         _ latency: TimeInterval,
         _ handler: @escaping FileSystemWatcher.EventHandlerFn) throws
    {
        self.paths = urls.map { $0.path }
        self.handler = handler

        let combinedFlags = flags.union(.eventStreamAdditionalFlags)
        var context = FSEventStreamContext()
        context.info = unsafeBitCast(self, to: UnsafeMutableRawPointer.self)
        let possibleStream = FSEventStreamCreate(nil,
                                                 fsCallback,
                                                 &context,
                                                 paths as CFArray,
                                                 FSEventStreamEventId(kFSEventStreamEventIdSinceNow),
                                                 latency,
                                                 combinedFlags.rawValue)
        guard possibleStream != nil else {
            throw FileSystemWatcher.Error.couldNotCreateEventStream
        }

        fsStreamRef = possibleStream
        FSEventStreamScheduleWithRunLoop(fsStreamRef,
                                         CFRunLoopGetCurrent(),
                                         CFRunLoopMode.defaultMode.rawValue)
        if !FSEventStreamStart(fsStreamRef) {
            throw FileSystemWatcher.Error.couldNotStartEventStream
        }
    }

    deinit {
        if let stream = fsStreamRef {
            FSEventStreamStop(stream)
            FSEventStreamInvalidate(stream)
            FSEventStreamRelease(stream)
        }
    }
}

fileprivate func fsCallback(_ stream: ConstFSEventStreamRef,
                            _ clientCallbackInfo: UnsafeMutableRawPointer?,
                            _ numEvents: Int,
                            _ eventPaths: UnsafeMutableRawPointer,
                            _ eventFlags: UnsafePointer<FSEventStreamEventFlags>,
                            _ eventIDs: UnsafePointer<FSEventStreamEventId>)
{
    let eventStream = unsafeBitCast(clientCallbackInfo, to: EventStream.self)
    let paths = unsafeBitCast(eventPaths, to: NSArray.self)

    var events = [FileSystemWatcher.Event]()
    for i in 0 ..< numEvents {
        events.append(.init(paths[i] as! String, rawFlags: eventFlags[i]))
    }

    if !events.isEmpty {
        eventStream.handler(events)
    }
}

fileprivate struct FileEventFlags: OptionSet, CustomDebugStringConvertible {
    let rawValue: FSEventStreamEventFlags

    init(rawValue: FSEventStreamEventFlags) {
        self.rawValue = rawValue
    }

    init(_ value: Int) {
        self.init(rawValue: FSEventStreamEventFlags(value))
    }

    static let none = FileEventFlags(kFSEventStreamEventFlagNone)
    static let eventIdsWrapped = FileEventFlags(kFSEventStreamEventFlagEventIdsWrapped)
    static let historyDone = FileEventFlags(kFSEventStreamEventFlagHistoryDone)

    static let mustScanSubDirs = FileEventFlags(kFSEventStreamEventFlagMustScanSubDirs)
    static let userDropped = FileEventFlags(kFSEventStreamEventFlagUserDropped)
    static let kernelDropped = FileEventFlags(kFSEventStreamEventFlagKernelDropped)

    static let rootChanged = FileEventFlags(kFSEventStreamEventFlagRootChanged)

    static let mount = FileEventFlags(kFSEventStreamEventFlagMount)
    static let unmount = FileEventFlags(kFSEventStreamEventFlagUnmount)

    static let itemCreated = FileEventFlags(kFSEventStreamEventFlagItemCreated)
    static let itemRemoved = FileEventFlags(kFSEventStreamEventFlagItemRemoved)
    static let itemRenamed = FileEventFlags(kFSEventStreamEventFlagItemRenamed)
    static let itemModified = FileEventFlags(kFSEventStreamEventFlagItemModified)
    static let itemInodeMetaMod = FileEventFlags(kFSEventStreamEventFlagItemInodeMetaMod)
    static let itemFinderInfoMod = FileEventFlags(kFSEventStreamEventFlagItemFinderInfoMod)
    static let itemXattrMod = FileEventFlags(kFSEventStreamEventFlagItemXattrMod)

    @available(OSX 10.13, *)
    static let itemCloned = FileEventFlags(kFSEventStreamEventFlagItemCloned)

    static let itemChangeOwner = FileEventFlags(kFSEventStreamEventFlagItemChangeOwner)

    static let itemIsFile = FileEventFlags(kFSEventStreamEventFlagItemIsFile)
    static let itemIsDir = FileEventFlags(kFSEventStreamEventFlagItemIsDir)
    static let itemIsSymlink = FileEventFlags(kFSEventStreamEventFlagItemIsSymlink)
    static let itemIsHardLink = FileEventFlags(kFSEventStreamEventFlagItemIsHardlink)
    static let itemIsLastHardLink = FileEventFlags(kFSEventStreamEventFlagItemIsLastHardlink)

    static let ownEvent = FileEventFlags(kFSEventStreamEventFlagOwnEvent)

    func eventTypes() -> [FileSystemWatcher.Event.EventType] {
        var types = [FileSystemWatcher.Event.EventType]()
        if self.contains(.mustScanSubDirs) {
            types.append(.mustRescan(userDropped: self.contains(.userDropped),
                                     kernelDropped: self.contains(.kernelDropped)))
        }
        if self.contains(.rootChanged) {
            types.append(.rootChanged)
        }
        if self.contains(.mount) {
            types.append(.mounted)
        }
        if self.contains(.unmount) {
            types.append(.unmounted)
        }
        if self.contains(.itemCreated) {
            types.append(.created)
        }
        if self.contains(.itemRemoved) {
            types.append(.removed)
        }
        if self.contains(.itemRenamed) {
            types.append(.renamed)
        }
        if self.contains(.itemModified) {
            types.append(.modified)
        }
        if self.contains(.itemInodeMetaMod) || self.contains(.itemFinderInfoMod) || self.contains(.itemXattrMod) {
            types.append(.metadataModified(inode: self.contains(.itemInodeMetaMod),
                                           finder: self.contains(.itemFinderInfoMod),
                                           xAttributes: self.contains(.itemXattrMod)))
        }
        if #available(OSX 10.13, *) {
            if self.contains(.itemCloned) {
                types.append(.cloned)
            }
        }
        if self.contains(.itemChangeOwner) {
            types.append(.ownerChanged)
        }
        return types
    }

    func itemTypes() -> [FileSystemWatcher.Event.ItemType] {
        var types = [FileSystemWatcher.Event.ItemType]()
        if self.contains(.itemIsFile) {
            types.append(.file)
        }
        if self.contains(.itemIsDir) {
            types.append(.directory)
        }
        if self.contains(.itemIsSymlink) {
            types.append(.symbolicLink)
        }
        if self.contains(.itemIsHardLink) {
            types.append(.hardLink(isLastHardLink: self.contains(.itemIsLastHardLink)))
        }
        return types
    }

    public var debugDescription: String {
        if self == .none {
            return "None"
        }

        var strings = [String]()
        if (self.contains(.mustScanSubDirs)) {
            strings.append("MustScanSubDirs")
        }
        if (self.contains(.userDropped)) {
            strings.append("UserDropped")
        }
        if (self.contains(.kernelDropped)) {
            strings.append("KernelDropped")
        }
        if (self.contains(.eventIdsWrapped)) {
            strings.append("EventIdsWrapped")
        }
        if (self.contains(.historyDone)) {
            strings.append("HistoryDone")
        }
        if (self.contains(.rootChanged)) {
            strings.append("RootChanged")
        }
        if (self.contains(.mount)) {
            strings.append("Mount")
        }
        if (self.contains(.unmount)) {
            strings.append("Unmount")
        }
        if (self.contains(.itemCreated)) {
            strings.append("ItemCreated")
        }
        if (self.contains(.itemRemoved)) {
            strings.append("ItemRemoved")
        }
        if (self.contains(.itemInodeMetaMod)) {
            strings.append("ItemInodeMetaMod")
        }
        if (self.contains(.itemRenamed)) {
            strings.append("ItemRenamed")
        }
        if (self.contains(.itemModified)) {
            strings.append("ItemModified")
        }
        if (self.contains(.itemFinderInfoMod)) {
            strings.append("ItemFinderInfoMod")
        }
        if (self.contains(.itemChangeOwner)) {
            strings.append("ItemChangeOwner")
        }
        if (self.contains(.itemXattrMod)) {
            strings.append("ItemXattrMod")
        }
        if (self.contains(.itemIsFile)) {
            strings.append("ItemIsFile")
        }
        if (self.contains(.itemIsDir)) {
            strings.append("ItemIsDirectory")
        }
        if (self.contains(.itemIsSymlink)) {
            strings.append("ItemIsSymLink")
        }
        if (self.contains(.itemIsHardLink)) {
            strings.append("ItemIsHardLink")
        }
        if (self.contains(.itemIsLastHardLink)) {
            strings.append("ItemIsLastHardLink")
        }
        if (self.contains(.ownEvent)) {
            strings.append("OwnEvent")
        }

        return strings.joined(separator: ",")
    }
}

#endif
